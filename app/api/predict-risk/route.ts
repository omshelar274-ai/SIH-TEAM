import { NextRequest, NextResponse } from "next/server";
import { calculateRisk, ProjectMetrics, DelayDriver, RiskResult } from "@/lib/riskScore";

export const dynamic = "force-dynamic";

const ML_SERVICE_URL = process.env.ML_SERVICE_URL || "http://127.0.0.1:8000";

interface RequestBody {
  metrics: ProjectMetrics;
  totalLandAreaHectares?: number;
  estFamiliesAffected?: number;
}

const FEATURE_LABEL_MAP: Record<string, { label: string; getDetail: (m: ProjectMetrics) => string }> = {
  compensation_paid_pct: {
    label: "Compensation Pending",
    getDetail: (m) => `${m.compensationPaidPct}% of compensation disbursed`,
  },
  days_since_forest_clearance_needed: {
    label: "Pending Approvals / Forest NOC",
    getDetail: (m) => m.forestClearanceApplied ? "Stage-1 applied" : `${m.daysSinceForestClearanceNeeded} days overdue`,
  },
  possession_refusing_pct: {
    label: "Right-of-Way Possession Refusals",
    getDetail: (m) => `${m.possessionRefusingPct}% families refusing to vacate`,
  },
  court_cases_active: {
    label: "Litigation & Court Stays",
    getDetail: (m) => `${m.courtCasesActive} active disputes (${m.courtCasesRecent90d} recent)`,
  },
  court_cases_recent_90d: {
    label: "Litigation Velocity Spike",
    getDetail: (m) => `${m.courtCasesRecent90d} new cases filed in last 90 days`,
  },
  court_case_avg_age_days: {
    label: "Aging Court Injunctions",
    getDetail: (m) => `Average dispute age ${Math.round(m.courtCaseAvgAgeDays)} days`,
  },
  lao_backlog_ratio: {
    label: "LAO Sub-Divisional Workload Backlog",
    getDetail: (m) => `File backlog ratio: ${(m.laoBacklogRatio || 1.5).toFixed(1)}x`,
  },
  document_rejection_rate: {
    label: "Patwari Field Survey Rejections",
    getDetail: (m) => `Friction rejection rate: ${((m.documentRejectionRate || 0.05) * 100).toFixed(0)}%`,
  },
  is_schedule_v_tribal: {
    label: "Schedule V Tribal Land Complexity",
    getDetail: () => "PESA / FRA Gram Sabha consent required",
  },
  st_families: {
    label: "Scheduled Tribe Rehabilitation",
    getDetail: (m) => `${m.stFamilies} ST families affected`,
  },
  months_elapsed: {
    label: "Statutory Project Timeline Decay",
    getDetail: (m) => `${m.monthsElapsed} of ${m.monthsTotal} months elapsed`,
  },
  rr_progress_pct: {
    label: "R&R Resettlement Colony Lag",
    getDetail: (m) => `${m.rrProgressPct}% resettlement completed`,
  },
  dept_response_days: {
    label: "Inter-Department Correspondence Lag",
    getDetail: (m) => `Avg ${m.deptResponseDays} days response time`,
  },
};

function scoreFromProbabilities(probs: Record<string, number>): number {
  const midpoints: Record<string, number> = { LOW: 20, MODERATE: 45, HIGH: 68, CRITICAL: 88 };
  let score = 0;
  for (const [level, p] of Object.entries(probs)) {
    score += (midpoints[level] ?? 50) * p;
  }
  return Math.round(Math.min(98, Math.max(10, score)));
}

export async function POST(req: NextRequest) {
  let activeMetrics: ProjectMetrics = {
    compensationPaidPct: 40,
    courtCasesActive: 3,
    courtCasesRecent90d: 1,
    courtCaseAvgAgeDays: 140,
    rrProgressPct: 35,
    stFamilies: 8,
    forestClearanceApplied: true,
    daysSinceForestClearanceNeeded: 30,
    monthsElapsed: 12,
    monthsTotal: 36,
    deptResponseDays: 12,
    possessionRefusingPct: 15,
    laoBacklogRatio: 1.8,
    documentRejectionRate: 0.08,
  };
  let landArea = 450;
  let familiesAffected = 120;

  try {
    const body: RequestBody = await req.json();
    if (body && body.metrics) {
      activeMetrics = { ...activeMetrics, ...body.metrics };
      if (body.totalLandAreaHectares) landArea = body.totalLandAreaHectares;
      if (body.estFamiliesAffected) familiesAffected = body.estFamiliesAffected;
    }
  } catch (jsonErr) {
    console.warn("Payload read warning:", jsonErr);
  }

  if (ML_SERVICE_URL) {
    try {
      const pythonPayload = {
        compensation_paid_pct: activeMetrics.compensationPaidPct ?? 40,
        court_cases_active: activeMetrics.courtCasesActive ?? 3,
        court_cases_recent_90d: activeMetrics.courtCasesRecent90d ?? 1,
        court_case_avg_age_days: activeMetrics.courtCaseAvgAgeDays ?? 140,
        rr_progress_pct: activeMetrics.rrProgressPct ?? 35,
        st_families: activeMetrics.stFamilies ?? 8,
        forest_clearance_applied: activeMetrics.forestClearanceApplied ?? true,
        days_since_forest_clearance_needed: activeMetrics.daysSinceForestClearanceNeeded ?? 30,
        months_elapsed: activeMetrics.monthsElapsed ?? 12,
        months_total: activeMetrics.monthsTotal ?? 36,
        dept_response_days: activeMetrics.deptResponseDays ?? 12,
        possession_refusing_pct: activeMetrics.possessionRefusingPct ?? 15,
        total_land_area_hectares: landArea,
        est_families_affected: familiesAffected,
        lao_backlog_ratio: activeMetrics.laoBacklogRatio ?? 1.8,
        document_rejection_rate: activeMetrics.documentRejectionRate ?? 0.08,
        political_cycle_proximity: activeMetrics.politicalCycleProximity ?? 24,
        is_schedule_v_tribal: activeMetrics.isScheduleVTribal ?? (activeMetrics.stFamilies > 15 ? 1 : 0),
        is_forest_land: activeMetrics.isForestLand ?? (activeMetrics.daysSinceForestClearanceNeeded > 0 ? 1 : 0),
        is_urban_commercial: activeMetrics.isUrbanCommercial ?? 0,
      };

      const res = await fetch(`${ML_SERVICE_URL}/predict`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(pythonPayload),
        signal: AbortSignal.timeout(4000),
      });

      if (res.ok) {
        const ml = await res.json();
        const baseResult = calculateRisk(activeMetrics);

        const surv = ml.survival_analysis || {};
        const riskScore = ml.risk_score != null ? ml.risk_score : baseResult.riskScore;
        const delayProbabilityPct = riskScore;
        const delayProb90d = Math.round(riskScore) / 100;
        const delayProb30d = Math.round(delayProb90d * 0.58 * 100) / 100;
        const delayProb60d = Math.round(delayProb90d * 0.79 * 100) / 100;
        const delayProb180d = Math.round(Math.min(0.98, delayProb90d * 1.18) * 100) / 100;

        const riskLevel = riskScore >= 75 ? "CRITICAL" : riskScore >= 54 ? "HIGH" : riskScore >= 34 ? "MODERATE" : "LOW";
        const predictedMonths = ml.predicted_delay_months ?? (riskScore >= 75 ? 18 : riskScore >= 54 ? 10 : riskScore >= 34 ? 5 : 2);

        // Dynamic local feature attributions from Python ML
        const rawDrivers = ml.top_drivers || ml.local_feature_attribution || [];
        const dynamicTopDrivers: DelayDriver[] = rawDrivers.map((d: any) => {
          const feat = d.feature || "";
          const config = FEATURE_LABEL_MAP[feat] || {
            label: feat.replace(/_/g, " ").replace(/\b\w/g, (c: string) => c.toUpperCase()),
            getDetail: () => "Dynamic local feature impact",
          };
          const impactPct = Math.round((d.local_pct ?? (d.importance * 100)) || 15);
          return {
            driver: config.label,
            impactPct,
            redFlag: impactPct > 20,
            detail: config.getDetail(activeMetrics),
          };
        });

        const kaplanMeierCurve = (surv.survival_curve || []).map((pt: any) => ({
          day: pt.day,
          survivalRate: pt.survival_rate ?? pt.survivalRate ?? 0.5,
        }));

        const cphHazardTable = (surv.hazard_table || []).map((h: any) => ({
          variable: h.variable,
          coefficient: h.beta ?? 0.5,
          hazardRatio: Math.round(Math.exp(h.beta ?? 0.5) * 100) / 100,
          statutoryBasis: h.statutory_basis || "RFCTLARR Statutory Benchmark",
          active: h.active ?? false,
        }));

        const result: RiskResult = {
          ...baseResult,
          riskScore,
          riskLevel: ml.risk_level || "MODERATE",
          delayProbabilityPct,
          predictedDelayMonths: {
            min: Math.max(0, Math.round(predictedMonths - 2)),
            max: Math.round(predictedMonths + 3),
          },
          topDrivers: dynamicTopDrivers.length > 0 ? dynamicTopDrivers : baseResult.topDrivers,
          cphHazardRatio: surv.ensemble_hazard_ratio ?? surv.hazard_ratio ?? surv.cph_hazard_ratio ?? baseResult.cphHazardRatio,
          delayProb30d,
          delayProb60d,
          delayProb90d,
          delayProb180d,
          kaplanMeierCurve: kaplanMeierCurve.length > 0 ? kaplanMeierCurve : baseResult.kaplanMeierCurve,
          cphHazardTable: cphHazardTable.length > 0 ? cphHazardTable : baseResult.cphHazardTable,
          modelDetails: {
            classifier: "GradientBoostingClassifier (Scikit-Learn)",
            regressor: "RandomForestRegressor (Scikit-Learn)",
            survivalMethod: "Literature-Calibrated Breslow Hazard Model",
          },
          shapContributions: dynamicTopDrivers.map((d) => ({
            factor: d.driver,
            impact: d.impactPct,
          })),
        };

        return NextResponse.json({
          source: "ml",
          ...result,
        });
      }
    } catch (e) {
      console.warn("Python ML service unreachable, utilizing calibrated fallback engine:", e);
    }
  }

  // High-fidelity calibrated fallback engine
  const ruleResult = calculateRisk(activeMetrics);
  return NextResponse.json({
    source: "rule-based",
    ...ruleResult,
  });
}
