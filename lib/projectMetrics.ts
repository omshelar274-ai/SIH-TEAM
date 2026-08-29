import { supabase } from "@/lib/supabaseClient";
import { ProjectMetrics } from "@/lib/riskScore";

export interface ProjectRecord {
  id: string;
  project_name: string;
  project_type: string;
  district: string;
  villages_affected: string;
  total_land_area_hectares: number;
  est_families_affected: number;
  st_families: number;
  start_date: string;
  target_handover_date: string;
  forest_clearance: string;
  forest_clearance_applied: boolean;
  avg_dept_response_days: number;
  status: string;
}

/**
 * Aggregates real ground survey family rows, legal disputes, and R&R status from Supabase
 * into the ProjectMetrics structure consumed by our Multi-Model Ensemble.
 */
export async function fetchProjectMetrics(
  project: ProjectRecord
): Promise<ProjectMetrics> {
  const { data: families } = await supabase
    .from("families")
    .select("payment_status, court_case_status, possession_status, court_case_filed_date, verification_status")
    .eq("project_id", project.id);

  const { data: rehab } = await supabase
    .from("rehabilitation_status")
    .select("colonies_planned, colonies_built")
    .eq("project_id", project.id)
    .maybeSingle();

  const allFamilies = families ?? [];
  const totalFamilies = allFamilies.length;

  const paidCount = allFamilies.filter((f) => f.payment_status === "Paid").length;
  const activeCourtCases = allFamilies.filter((f) => f.court_case_status === "Active");
  const courtCasesActiveCount = activeCourtCases.length;
  const refusingCount = allFamilies.filter((f) => f.possession_status === "Refusing").length;
  const unverifiedCount = allFamilies.filter((f) => f.verification_status === "Pending").length;
  const rejectedCount = allFamilies.filter((f) => f.verification_status === "Rejected").length;

  // Calculate litigation recency (90 days) and average case age
  const now = new Date();
  const ninetyDaysAgo = new Date();
  ninetyDaysAgo.setDate(now.getDate() - 90);

  let courtCasesRecent90d = 0;
  let totalCaseAgeDays = 0;

  activeCourtCases.forEach((c) => {
    if (c.court_case_filed_date) {
      const filedDate = new Date(c.court_case_filed_date);
      if (filedDate >= ninetyDaysAgo) {
        courtCasesRecent90d++;
      }
      const ageDiff = now.getTime() - filedDate.getTime();
      const ageDays = Math.max(0, Math.round(ageDiff / (1000 * 60 * 60 * 24)));
      totalCaseAgeDays += ageDays;
    }
  });

  const courtCaseAvgAgeDays = courtCasesActiveCount > 0 ? totalCaseAgeDays / courtCasesActiveCount : 0;

  const startDate = new Date(project.start_date || "2024-01-01");
  const targetDate = new Date(project.target_handover_date || "2026-12-31");
  const monthsTotal = Math.max(
    1,
    Math.round(
      (targetDate.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24 * 30)
    )
  );
  const monthsElapsed = Math.max(
    0,
    Math.round((now.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24 * 30))
  );

  // Data Quality Tiering & Ground Audit Telemetry
  let dataQualityTier: "VERIFIED" | "PARTIALLY_VERIFIED" | "PENDING_AUDIT" | "BASELINE_ESTIMATE";
  let compensationPaidPct = 0;
  let possessionRefusingPct = 0;
  let laoBacklogRatio = 1.5;
  let documentRejectionRate = 0.05;

  if (totalFamilies > 10) {
    dataQualityTier = "VERIFIED";
    compensationPaidPct = (paidCount / totalFamilies) * 100;
    possessionRefusingPct = (refusingCount / totalFamilies) * 100;
    laoBacklogRatio = Math.min(5.5, Math.max(0.5, (unverifiedCount / totalFamilies) * 3.5 + 1.2));
    documentRejectionRate = rejectedCount / totalFamilies;
  } else if (totalFamilies > 0) {
    dataQualityTier = unverifiedCount > 0 ? "PARTIALLY_VERIFIED" : "VERIFIED";
    compensationPaidPct = (paidCount / totalFamilies) * 100;
    possessionRefusingPct = (refusingCount / totalFamilies) * 100;
    laoBacklogRatio = Math.min(5.5, Math.max(0.5, (unverifiedCount / totalFamilies) * 3.5 + 1.2));
    documentRejectionRate = rejectedCount / totalFamilies;
  } else {
    dataQualityTier = "BASELINE_ESTIMATE";
    // Transparent statutory baseline estimate from project timeline & land categories
    compensationPaidPct = project.status === "Completed" ? 100 : Math.min(80, Math.max(0, (monthsElapsed / monthsTotal) * 50));
    possessionRefusingPct = 0;
    laoBacklogRatio = project.total_land_area_hectares > 500 ? 2.5 : 1.5;
    documentRejectionRate = 0.05;
  }

  const coloniesPlanned = rehab?.colonies_planned ?? Math.max(1, Math.round(project.est_families_affected / 40));
  const coloniesBuilt = rehab?.colonies_built ?? Math.round((compensationPaidPct / 100) * coloniesPlanned);
  const rrProgressPct = coloniesPlanned > 0 ? (coloniesBuilt / coloniesPlanned) * 100 : 0;

  const daysSinceForestClearanceNeeded =
    project.forest_clearance === "Yes" && !project.forest_clearance_applied
      ? Math.max(
          0,
          Math.round((now.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24))
        )
      : 0;

  const isScheduleVTribal = project.project_name.toLowerCase().includes("tribal") || project.st_families > 20 ? 1 : 0;
  const isForestLand = project.forest_clearance === "Yes" ? 1 : 0;
  const isUrbanCommercial = project.project_type === "Metro" || project.project_type === "Smart City" || project.project_type === "Airport" ? 1 : 0;

  return {
    compensationPaidPct: Math.round(compensationPaidPct * 10) / 10,
    courtCasesActive: courtCasesActiveCount,
    courtCasesRecent90d,
    courtCaseAvgAgeDays: Math.round(courtCaseAvgAgeDays),
    rrProgressPct: Math.round(rrProgressPct * 10) / 10,
    stFamilies: project.st_families || 0,
    forestClearanceApplied: project.forest_clearance_applied,
    daysSinceForestClearanceNeeded,
    monthsElapsed,
    monthsTotal,
    deptResponseDays: project.avg_dept_response_days || 12,
    possessionRefusingPct: Math.round(possessionRefusingPct * 10) / 10,
    laoBacklogRatio: Math.round(laoBacklogRatio * 10) / 10,
    documentRejectionRate: Math.round(documentRejectionRate * 100) / 100,
    isScheduleVTribal,
    isForestLand,
    isUrbanCommercial,
    dataQualityTier,
    verifiedFamiliesCount: paidCount,
    pendingFamiliesCount: unverifiedCount,
    rejectedFamiliesCount: rejectedCount,
    totalFamiliesCount: totalFamilies,
  };
}
