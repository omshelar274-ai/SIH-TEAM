import { NextResponse } from "next/server";
import fs from "fs";
import path from "path";

export const dynamic = "force-dynamic";

const FALLBACK_FRAMEWORK_INFO = {
  framework: "scikit-learn",
  classifier: "GradientBoostingClassifier",
  regressor: "RandomForestRegressor",
  mae_months: 1.64,
  r2_score: 0.917,
  total_features: 20,
};

const FALLBACK_FEATURE_IMPORTANCES = {
  court_cases_active: 0.2447,
  rr_progress_pct: 0.2265,
  compensation_paid_pct: 0.1438,
  court_case_avg_age_days: 0.1053,
  days_since_forest_clearance_needed: 0.0815,
  lao_backlog_ratio: 0.0592,
  possession_refusing_pct: 0.0476,
  st_families: 0.0374,
  dept_response_days: 0.0105,
  document_rejection_rate: 0.0089,
  total_land_area_hectares: 0.0063,
  is_forest_land: 0.0054,
  months_elapsed: 0.0051,
  political_cycle_proximity: 0.0048,
  est_families_affected: 0.0045,
  forest_clearance_applied: 0.0035,
  court_cases_recent_90d: 0.0031,
  months_total: 0.0008,
  is_schedule_v_tribal: 0.0006,
  is_urban_commercial: 0.0004,
};

export async function GET() {
  try {
    const basePath = path.join(process.cwd(), "sih-ml", "model");

    const frameworkInfoPath = path.join(basePath, "framework_info.json");
    const featureImportancesPath = path.join(basePath, "feature_importances.json");
    const featuresPath = path.join(basePath, "features.json");

    let frameworkInfo = FALLBACK_FRAMEWORK_INFO;
    let featureImportances = FALLBACK_FEATURE_IMPORTANCES;
    let features: string[] = Object.keys(FALLBACK_FEATURE_IMPORTANCES);

    if (fs.existsSync(frameworkInfoPath)) {
      frameworkInfo = JSON.parse(fs.readFileSync(frameworkInfoPath, "utf-8"));
    }
    if (fs.existsSync(featureImportancesPath)) {
      featureImportances = JSON.parse(fs.readFileSync(featureImportancesPath, "utf-8"));
    }
    if (fs.existsSync(featuresPath)) {
      features = JSON.parse(fs.readFileSync(featuresPath, "utf-8"));
    }

    return NextResponse.json({
      success: true,
      source: fs.existsSync(frameworkInfoPath) ? "disk_artifacts" : "embedded_artifacts",
      frameworkInfo,
      featureImportances,
      features,
    });
  } catch (err: any) {
    return NextResponse.json({
      success: true,
      source: "embedded_artifacts_fallback",
      frameworkInfo: FALLBACK_FRAMEWORK_INFO,
      featureImportances: FALLBACK_FEATURE_IMPORTANCES,
      features: Object.keys(FALLBACK_FEATURE_IMPORTANCES),
    });
  }
}
