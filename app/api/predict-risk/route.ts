import { NextRequest, NextResponse } from "next/server";
import {
  calculateRisk,
  buildTopDrivers,
  buildRecommendations,
  ProjectMetrics,
  RiskResult,
} from "@/lib/riskScore";

// Set this to your deployed FastAPI service URL (Render/Railway) once deployed,
// e.g. ML_SERVICE_URL=https://sih-risk-model.onrender.com
const ML_SERVICE_URL = process.env.ML_SERVICE_URL;

interface RequestBody {
  metrics: ProjectMetrics;
  totalLandAreaHectares: number;
  estFamiliesAffected: number;
}

// Blend the classifier's class probabilities into a single 0-100 number so the
// dashboard's score card always has something numeric to show, ML or rule-based.
function scoreFromProbabilities(probs: Record<string, number>): number {
  const midpoints: Record<string, number> = {
    LOW: 20,
    MODERATE: 50,
    HIGH: 72,
    CRITICAL: 92,
  };
  let score = 0;
  for (const [level, p] of Object.entries(probs)) {
    score += (midpoints[level] ?? 50) * p;
  }
  return Math.round(score);
}

export async function POST(req: NextRequest) {
  const { metrics, totalLandAreaHectares, estFamiliesAffected }: RequestBody =
    await req.json();

  if (ML_SERVICE_URL) {
    try {
      const res = await fetch(`${ML_SERVICE_URL}/predict`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          compensation_paid_pct: metrics.compensationPaidPct,
          court_cases_active: metrics.courtCasesActive,
          court_cases_recent_90d: metrics.courtCasesRecent90d,
          court_case_avg_age_days: metrics.courtCaseAvgAgeDays,
          rr_progress_pct: metrics.rrProgressPct,
          st_families: metrics.stFamilies,
          forest_clearance_applied: metrics.forestClearanceApplied,
          days_since_forest_clearance_needed: metrics.daysSinceForestClearanceNeeded,
          months_elapsed: metrics.monthsElapsed,
          months_total: metrics.monthsTotal,
          dept_response_days: metrics.deptResponseDays,
          possession_refusing_pct: metrics.possessionRefusingPct,
          total_land_area_hectares: totalLandAreaHectares,
          est_families_affected: estFamiliesAffected,
        }),
        signal: AbortSignal.timeout(4000), // never hang the dashboard during a demo
      });

      if (res.ok) {
        const ml = await res.json();
        const riskScore = scoreFromProbabilities(ml.risk_probabilities);
        const predicted = ml.predicted_delay_months as number;
        const baseResult = calculateRisk(metrics);

        const result: RiskResult & { source: string } = {
          ...baseResult,
          source: "ml",
          riskScore,
          riskLevel: ml.risk_level,
          delayProbabilityPct: Math.round(
            (1 - (ml.risk_probabilities.LOW ?? 0)) * 100
          ),
          predictedDelayMonths: {
            min: Math.max(0, Math.round(predicted - 2)),
            max: Math.round(predicted + 2),
          },
          topDrivers: buildTopDrivers(metrics),
          recommendations: buildRecommendations(metrics),
        };

        return NextResponse.json(result);
      }
    } catch {
      // fall through to rule-based
    }
  }

  const ruleResult = calculateRisk(metrics);
  return NextResponse.json({ source: "rule-based", ...ruleResult });
}
