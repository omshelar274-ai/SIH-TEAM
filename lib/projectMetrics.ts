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
 * Pulls a project's row plus its families and rehabilitation_status rows from
 * Supabase and assembles them into the ProjectMetrics shape the risk engine expects.
 * Falls back to sensible defaults (0 families entered yet, no R&R progress yet)
 * so a freshly created project still renders a risk card instead of crashing.
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

  // Aggregate metrics using ONLY verified families (per workflow gating requirement)
  const verifiedFamilies = families?.filter((f) => f.verification_status === "Verified") ?? [];
  const totalFamilies = verifiedFamilies.length;
  const paidCount = verifiedFamilies.filter((f) => f.payment_status === "Paid").length;
  const activeCourtCases = verifiedFamilies.filter((f) => f.court_case_status === "Active");
  const courtCasesActiveCount = activeCourtCases.length;
  const refusingCount = verifiedFamilies.filter((f) => f.possession_status === "Refusing").length;

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

  // No family data entered yet -> can't claim any compensation progress; assume worst case (0%)
  // rather than division-by-zero producing a misleadingly optimistic 100%.
  const compensationPaidPct = totalFamilies > 0 ? (paidCount / totalFamilies) * 100 : 0;
  const possessionRefusingPct =
    totalFamilies > 0 ? (refusingCount / totalFamilies) * 100 : 0;

  const coloniesPlanned = rehab?.colonies_planned ?? 0;
  const coloniesBuilt = rehab?.colonies_built ?? 0;
  const rrProgressPct = coloniesPlanned > 0 ? (coloniesBuilt / coloniesPlanned) * 100 : 0;

  const startDate = new Date(project.start_date);
  const targetDate = new Date(project.target_handover_date);
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

  const daysSinceForestClearanceNeeded =
    project.forest_clearance === "Yes" && !project.forest_clearance_applied
      ? Math.max(
          0,
          Math.round((now.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24))
        )
      : 0;

  return {
    compensationPaidPct,
    courtCasesActive: courtCasesActiveCount,
    courtCasesRecent90d,
    courtCaseAvgAgeDays,
    rrProgressPct,
    stFamilies: project.st_families,
    forestClearanceApplied: project.forest_clearance_applied,
    daysSinceForestClearanceNeeded,
    monthsElapsed,
    monthsTotal,
    deptResponseDays: project.avg_dept_response_days,
    possessionRefusingPct,
  };
}
