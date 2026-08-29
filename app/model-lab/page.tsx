"use client";

import { useEffect, useState } from "react";
import DashboardLayout from "@/components/DashboardLayout";
import RoleGuard from "@/components/RoleGuard";

interface ModelInfoData {
  frameworkInfo: {
    framework: string;
    classifier: string;
    regressor: string;
    mae_months: number;
    r2_score: number;
    total_features: number;
  };
  featureImportances: Record<string, number>;
  features: string[];
}

const FEATURE_LABELS: Record<string, { label: string; statutory: string; category: string }> = {
  court_cases_active: { label: "Active Court Cases & Stays", statutory: "e-Courts NJDG / High Court Stays", category: "Legal" },
  rr_progress_pct: { label: "R&R Colony Construction %", statutory: "RFCTLARR Act Second Schedule", category: "Resettlement" },
  compensation_paid_pct: { label: "Compensation Award Disbursed %", statutory: "PFMS / RFCTLARR Act §38", category: "Financial" },
  court_case_avg_age_days: { label: "Mean Court Stay Age (Days)", statutory: "NJDG Writ Petition Duration", category: "Legal" },
  days_since_forest_clearance_needed: { label: "Forest Stage-1 Overdue (Days)", statutory: "Forest (Conservation) Act 1980", category: "Forest / Env" },
  lao_backlog_ratio: { label: "LAO Sub-Divisional File Backlog", statutory: "District SDO Caseload Ratio", category: "Administrative" },
  possession_refusing_pct: { label: "Possession Handover Refusal %", statutory: "RFCTLARR Act §38(1)", category: "Right-of-Way" },
  st_families: { label: "Scheduled Tribe Affected Families", statutory: "Constitution Schedule V / PESA", category: "Social / Tribal" },
  dept_response_days: { label: "Inter-Dept Response Lag (Days)", statutory: "District e-Office Records", category: "Administrative" },
  document_rejection_rate: { label: "7/12 Land Title Rejection Rate", statutory: "Revenue Record Room Audit", category: "Land Records" },
  total_land_area_hectares: { label: "Total Corridor Land Area (Ha)", statutory: "MoRTH Section 3A Gazette", category: "Corridor Scale" },
  is_forest_land: { label: "Forest Land Diversion Indicator", statutory: "PARIVESH Portal NOC Record", category: "Forest / Env" },
  months_elapsed: { label: "Months Elapsed Since Sec 11", statutory: "RFCTLARR §19 12-Mo SLA Clock", category: "Timeline SLA" },
  political_cycle_proximity: { label: "Election Proximity (Months)", statutory: "General / Assembly Cycle", category: "External" },
  est_families_affected: { label: "Total Project-Affected Persons", statutory: "Social Impact Assessment (SIA)", category: "Social / Tribal" },
  forest_clearance_applied: { label: "Forest Stage-1 NOC Filed", statutory: "MoEFCC Compliance Register", category: "Forest / Env" },
  court_cases_recent_90d: { label: "New Court Cases in Last 90 Days", statutory: "Litigation Injunction Velocity", category: "Legal" },
  months_total: { label: "Total Allocated Project Window", statutory: "DPR Milestone Schedule", category: "Timeline SLA" },
  is_schedule_v_tribal: { label: "Schedule V Tribal Area Flag", statutory: "PESA 1996 Gram Sabha Consent", category: "Social / Tribal" },
  is_urban_commercial: { label: "Urban / Commercial Corridor Flag", statutory: "Urban Land Ceiling Registry", category: "Corridor Scale" },
};

export default function ModelLabPage() {
  const [modelData, setModelData] = useState<ModelInfoData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function fetchModelInfo() {
      setLoading(true);
      setError(null);

      try {
        const res = await fetch("/api/model-info");
        if (!res.ok) {
          throw new Error(`Failed to load model metadata artifacts (HTTP ${res.status}).`);
        }
        const data = await res.json();
        setModelData(data);
      } catch (err: any) {
        setError(err?.message || "Failed to load model metadata artifacts from disk.");
      } finally {
        setLoading(false);
      }
    }

    fetchModelInfo();
  }, []);

  const featureEntries = modelData?.featureImportances
    ? Object.entries(modelData.featureImportances).sort((a, b) => b[1] - a[1])
    : [];

  return (
    <RoleGuard allowedRoles={["collector", "lao", "patwari"]}>
      <DashboardLayout>
        <div className="p-6 lg:p-8 space-y-8 max-w-7xl mx-auto">
          {/* Header */}
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full border border-indigo-500/30 bg-indigo-500/10 text-indigo-300 text-xs font-semibold mb-3">
              <span className="w-1.5 h-1.5 rounded-full bg-indigo-400 animate-pulse" />
              Machine Learning Model Transparency
            </div>
            <h1 className="text-2xl lg:text-3xl font-black text-white tracking-tight">
              Predictive Model Lab
            </h1>
            <p className="mt-1 text-slate-400 text-xs leading-relaxed max-w-3xl">
              Transparent evaluation metrics and feature importance weights read directly from our trained Scikit-Learn binaries and disk metadata files (<code className="text-indigo-400 font-mono">framework_info.json</code> and <code className="text-indigo-400 font-mono">feature_importances.json</code>).
            </p>
          </div>

          {/* Loading & Error States */}
          {loading && (
            <div className="rounded-2xl border border-slate-800 bg-slate-900/50 p-12 text-center">
              <div className="w-8 h-8 border-2 border-indigo-500 border-t-transparent rounded-full animate-spin mx-auto mb-3" />
              <p className="text-xs font-mono text-slate-400">Reading real model artifact files from disk...</p>
            </div>
          )}

          {error && (
            <div className="rounded-2xl border border-rose-500/30 bg-rose-500/10 p-6 text-rose-300 text-xs space-y-2">
              <p className="font-bold font-mono">⚠️ MODEL METADATA UNAVAILABLE:</p>
              <p>{error}</p>
              <p className="text-slate-400">Please ensure <code className="font-mono">python sih-ml/train_model.py</code> has been executed to generate artifact binaries.</p>
            </div>
          )}

          {!loading && !error && modelData && (
            <>
              {/* Primary Trained Models Architecture Strip */}
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                {/* 1. Classifier Box */}
                <div className="rounded-2xl border border-indigo-500/30 bg-slate-900/80 p-6 space-y-3">
                  <div className="flex items-center justify-between">
                    <span className="text-[10px] font-mono font-bold bg-indigo-500/20 text-indigo-300 border border-indigo-500/30 px-2 py-0.5 rounded-full">
                      Classification Model
                    </span>
                    <span className="text-xs font-mono text-slate-400">{modelData.frameworkInfo.framework}</span>
                  </div>
                  <h2 className="text-lg font-bold text-white">
                    {modelData.frameworkInfo.classifier}
                  </h2>
                  <div className="space-y-1.5 text-xs font-mono text-slate-300 pt-2 border-t border-slate-800">
                    <p className="flex justify-between">
                      <span className="text-slate-400">Target Output:</span>
                      <span className="text-white font-bold">4 Discrete Risk Strata</span>
                    </p>
                    <p className="flex justify-between">
                      <span className="text-slate-400">Classes:</span>
                      <span className="text-indigo-300">LOW, MODERATE, HIGH, CRITICAL</span>
                    </p>
                    <p className="flex justify-between">
                      <span className="text-slate-400">Estimators / Depth:</span>
                      <span className="text-slate-200">200 trees / Max Depth 6</span>
                    </p>
                    <p className="flex justify-between">
                      <span className="text-slate-400">Input Variables:</span>
                      <span className="text-emerald-400 font-bold">{modelData.frameworkInfo.total_features} Features</span>
                    </p>
                  </div>
                </div>

                {/* 2. Regressor Box */}
                <div className="rounded-2xl border border-sky-500/30 bg-slate-900/80 p-6 space-y-3">
                  <div className="flex items-center justify-between">
                    <span className="text-[10px] font-mono font-bold bg-sky-500/20 text-sky-300 border border-sky-500/30 px-2 py-0.5 rounded-full">
                      Delay Regressor
                    </span>
                    <span className="text-xs font-mono text-emerald-400">Censoring-Free</span>
                  </div>
                  <h2 className="text-lg font-bold text-white">
                    {modelData.frameworkInfo.regressor}
                  </h2>
                  <div className="space-y-1.5 text-xs font-mono text-slate-300 pt-2 border-t border-slate-800">
                    <p className="flex justify-between">
                      <span className="text-slate-400">Mean Absolute Error:</span>
                      <span className="text-emerald-400 font-bold">{modelData.frameworkInfo.mae_months} Months</span>
                    </p>
                    <p className="flex justify-between">
                      <span className="text-slate-400">Test R² Score:</span>
                      <span className="text-emerald-400 font-bold">{modelData.frameworkInfo.r2_score}</span>
                    </p>
                    <p className="flex justify-between">
                      <span className="text-slate-400">Training Filter:</span>
                      <span className="text-sky-300">stage_completed == 1</span>
                    </p>
                    <p className="flex justify-between">
                      <span className="text-slate-400">Censoring Protection:</span>
                      <span className="text-slate-200">Right-Censored Data Excluded</span>
                    </p>
                  </div>
                </div>

                {/* 3. Survival Method Box */}
                <div className="rounded-2xl border border-purple-500/30 bg-slate-900/80 p-6 space-y-3">
                  <div className="flex items-center justify-between">
                    <span className="text-[10px] font-mono font-bold bg-purple-500/20 text-purple-300 border border-purple-500/30 px-2 py-0.5 rounded-full">
                      Survival Analysis
                    </span>
                    <span className="text-xs font-mono text-purple-300">Time-to-Event</span>
                  </div>
                  <h2 className="text-lg font-bold text-white">
                    Literature-Calibrated Breslow Hazard
                  </h2>
                  <div className="space-y-1.5 text-xs font-mono text-slate-300 pt-2 border-t border-slate-800">
                    <p className="flex justify-between">
                      <span className="text-slate-400">Formulation:</span>
                      <span className="text-purple-300 font-bold">S(t) = S₀(t)^HR</span>
                    </p>
                    <p className="flex justify-between">
                      <span className="text-slate-400">Benchmark Source:</span>
                      <span className="text-slate-200">CAG Audit Report 12/2021</span>
                    </p>
                    <p className="flex justify-between">
                      <span className="text-slate-400">Evaluation Horizons:</span>
                      <span className="text-slate-200">30d, 60d, 90d, 180d, 360d</span>
                    </p>
                    <p className="flex justify-between">
                      <span className="text-slate-400">Method Type:</span>
                      <span className="text-amber-300">Calibrated Hazard (Not Fitted Cox)</span>
                    </p>
                  </div>
                </div>
              </div>

              {/* Real Feature Importance Breakdown from disk */}
              <div className="rounded-2xl border border-slate-800 bg-slate-900/70 p-6 space-y-6">
                <div>
                  <div className="flex items-center justify-between">
                    <h2 className="text-sm font-bold text-white font-mono uppercase tracking-wider">
                      📊 Real Feature Importances (From Scikit-Learn Training Run)
                    </h2>
                    <span className="text-xs font-mono text-indigo-400">
                      feature_importances.json ({featureEntries.length} features)
                    </span>
                  </div>
                  <p className="text-xs text-slate-400 mt-1">
                    Gini importance / mean decrease in impurity calculated across decision tree splits during model fitting.
                  </p>
                </div>

                <div className="space-y-3">
                  {featureEntries.map(([featKey, weight]) => {
                    const info = FEATURE_LABELS[featKey] || { label: featKey, statutory: "Domain Variable", category: "General" };
                    const pct = Math.round(weight * 1000) / 10;
                    return (
                      <div key={featKey} className="space-y-1">
                        <div className="flex flex-col sm:flex-row sm:items-center justify-between text-xs font-mono gap-1">
                          <div className="flex items-center gap-2">
                            <span className="font-bold text-white">{info.label}</span>
                            <span className="text-[10px] text-slate-500 font-mono">({featKey})</span>
                          </div>
                          <div className="flex items-center gap-3">
                            <span className="text-[10px] text-slate-400">{info.statutory}</span>
                            <span className="font-bold text-indigo-300 shrink-0 w-14 text-right">{pct}%</span>
                          </div>
                        </div>
                        <div className="h-2 w-full bg-slate-800 rounded-full overflow-hidden">
                          <div
                            className="h-full bg-gradient-to-r from-indigo-500 to-cyan-400 rounded-full transition-all duration-500"
                            style={{ width: `${Math.min(100, pct * 3.5)}%` }}
                          />
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>

              {/* Training Dataset Provenance & Methodology Transparency */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div className="rounded-2xl border border-slate-800 bg-slate-900/70 p-6 space-y-4">
                  <h2 className="text-sm font-bold text-white font-mono uppercase tracking-wider">
                    🧪 Training Dataset Provenance
                  </h2>
                  <div className="space-y-2.5 text-xs text-slate-300 leading-relaxed font-sans">
                    <p>
                      <strong className="text-white">Dataset Characterization:</strong> The machine learning models are trained on a <strong>6,000-sample Literature-Calibrated Synthetic Dataset</strong> generated by <code className="text-indigo-300 font-mono">generate_dataset.py</code>.
                    </p>
                    <p>
                      <strong className="text-white">Rationale:</strong> There is currently no open-access, longitudinal government repository containing parcel-level delay durations and court outcomes for public infrastructure in India. We modeled realistic continuous distributions spanning 4 distinct administrative personas.
                    </p>
                    <p>
                      <strong className="text-white">Stratification:</strong> The training dataset is balanced across 4 risk tiers (LOW, MODERATE, HIGH, CRITICAL) with stochastic Gaussian noise injection to prevent decision tree overfitting.
                    </p>
                  </div>
                </div>

                <div className="rounded-2xl border border-slate-800 bg-slate-900/70 p-6 space-y-4">
                  <h2 className="text-sm font-bold text-white font-mono uppercase tracking-wider">
                    ⚠️ Longitudinal Calibration Status
                  </h2>
                  <div className="space-y-2.5 text-xs text-slate-300 leading-relaxed font-sans">
                    <div className="p-3 bg-amber-950/30 border border-amber-800/40 rounded-xl space-y-1">
                      <p className="font-bold text-amber-300 font-mono text-xs">
                        [AWAITING LONGITUDINAL GROUND-TRUTH REVENUE DATA]
                      </p>
                      <p className="text-[11px] text-slate-400">
                        Empirical Calibration Curves (Brier Score), ROC Curves, and False Positive / False Negative case audits are not displayed here because computing them honestly requires 12–24 months of completed corridor handover outcomes.
                      </p>
                    </div>
                    <p className="text-[11px] text-slate-400">
                      We explicitly refrain from generating synthetic ROC curves or simulated confusion matrices to maintain strict statistical integrity.
                    </p>
                  </div>
                </div>
              </div>
            </>
          )}
        </div>
      </DashboardLayout>
    </RoleGuard>
  );
}
