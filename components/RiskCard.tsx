import { RiskResult, ProjectMetrics } from "@/lib/riskScore";

const levelConfig: Record<
  RiskResult["riskLevel"],
  { border: string; header: string; badge: string; ring: string; icon: string }
> = {
  CRITICAL: {
    border: "border-red-500/40 shadow-red-500/10",
    header: "bg-gradient-to-r from-red-900 via-rose-900 to-slate-900",
    badge:  "bg-red-500/20 text-red-300 border-red-500/30",
    ring:   "ring-red-500/30",
    icon:   "🔴",
  },
  HIGH: {
    border: "border-amber-500/40 shadow-amber-500/10",
    header: "bg-gradient-to-r from-amber-900 via-orange-950 to-slate-900",
    badge:  "bg-amber-500/20 text-amber-300 border-amber-500/30",
    ring:   "ring-amber-500/30",
    icon:   "🟠",
  },
  MODERATE: {
    border: "border-yellow-500/40 shadow-yellow-500/10",
    header: "bg-gradient-to-r from-yellow-900 via-amber-950 to-slate-900",
    badge:  "bg-yellow-500/20 text-yellow-300 border-yellow-500/30",
    ring:   "ring-yellow-500/30",
    icon:   "🟡",
  },
  LOW: {
    border: "border-emerald-500/40 shadow-emerald-500/10",
    header: "bg-gradient-to-r from-emerald-950 via-teal-950 to-slate-900",
    badge:  "bg-emerald-500/20 text-emerald-300 border-emerald-500/30",
    ring:   "ring-emerald-500/30",
    icon:   "🟢",
  },
};

const urgencyConfig: Record<string, { bg: string; label: string }> = {
  URGENT:  { bg: "bg-red-500/20 text-red-300 border-red-500/40",    label: "URGENT" },
  HIGH:    { bg: "bg-orange-500/20 text-orange-300 border-orange-500/40", label: "HIGH" },
  MONITOR: { bg: "bg-slate-700 text-slate-300 border-slate-600",  label: "MONITOR" },
};

export default function RiskCard({
  projectName,
  result,
  metrics,
}: {
  projectName: string;
  result: RiskResult;
  metrics?: ProjectMetrics;
}) {
  const cfg = levelConfig[result.riskLevel];
  const dataTier = metrics?.dataQualityTier || "VERIFIED";

  const tierBadgeConfig: Record<string, { label: string; style: string; icon: string }> = {
    VERIFIED: {
      label: `Verified Ground Survey (${metrics?.verifiedFamiliesCount ?? 0} Families Audited)`,
      style: "bg-emerald-500/20 text-emerald-300 border-emerald-500/30",
      icon: "✓",
    },
    PARTIALLY_VERIFIED: {
      label: `Partially Verified Survey (${metrics?.pendingFamiliesCount ?? 0} Pending LAO Sign-off)`,
      style: "bg-amber-500/20 text-amber-300 border-amber-500/30",
      icon: "⏳",
    },
    BASELINE_ESTIMATE: {
      label: "Statutory Baseline Model (0 Ground Surveys Filed)",
      style: "bg-sky-500/20 text-sky-300 border-sky-500/30",
      icon: "📊",
    },
    PENDING_AUDIT: {
      label: "Pending Field Audit",
      style: "bg-slate-500/20 text-slate-300 border-slate-500/30",
      icon: "📋",
    },
  };

  const currentTier = tierBadgeConfig[dataTier] || tierBadgeConfig.VERIFIED;

  // Multi-Model Concordance Diagnostic
  const survivalTier = result.delayProbabilityPct >= 75 ? "CRITICAL" : result.delayProbabilityPct >= 54 ? "HIGH" : result.delayProbabilityPct >= 34 ? "MODERATE" : "LOW";
  const isDivergent = result.riskLevel !== survivalTier;

  return (
    <div className={`rounded-2xl border ${cfg.border} bg-slate-900 shadow-xl overflow-hidden animate-fade-in`}>
      {/* Header bar */}
      <div className={`${cfg.header} px-6 py-5 text-white border-b border-slate-800`}>
        <div className="flex items-start justify-between gap-4">
          <div className="flex-1 min-w-0">
            <div className="flex flex-wrap items-center gap-2 mb-1.5">
              <span className={`px-2.5 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider border ${cfg.badge}`}>
                {cfg.icon} Classifier: {result.riskLevel}
              </span>
              <span className={`px-2.5 py-0.5 rounded-full text-[10px] font-mono font-bold uppercase tracking-wider border ${currentTier.style}`}>
                {currentTier.icon} {currentTier.label}
              </span>
            </div>
            <h2 className="font-extrabold text-xl leading-snug truncate text-white">{projectName}</h2>
          </div>

          {/* 90-Day Delay Probability Gauge */}
          <div className="shrink-0 text-right">
            <div className={`w-24 h-16 rounded-2xl ring-2 ${cfg.ring} bg-slate-950/80 px-2 py-1.5 flex flex-col items-center justify-center`}>
              <span className="text-xl font-black leading-none text-white">{result.delayProbabilityPct}%</span>
              <p className="text-slate-400 text-[9px] font-mono mt-1 text-center leading-tight">90d Delay Prob</p>
            </div>
          </div>
        </div>

        {/* Multi-Model Convergence / Disagreement Diagnostic Strip */}
        <div className="mt-3 px-3 py-2 rounded-xl bg-slate-950/70 border border-slate-800 text-[11px] font-mono flex flex-col sm:flex-row sm:items-center justify-between gap-2">
          <div className="flex items-center gap-2">
            <span className="text-sky-400 font-bold">⚖ Model Outputs:</span>
            <span className="text-slate-300">
              Classifier: <strong className="text-white">{result.riskLevel}</strong> · Survival Hazard: <strong className="text-sky-300">{result.delayProbabilityPct}%</strong> (90d window)
            </span>
          </div>
          {isDivergent ? (
            <span className="text-[10px] bg-amber-500/20 text-amber-300 border border-amber-500/30 px-2.5 py-0.5 rounded-full shrink-0 font-bold">
              ⚡ Multi-Horizon Disparity ({result.riskLevel} vs {survivalTier} tier)
            </span>
          ) : (
            <span className="text-[10px] bg-emerald-500/20 text-emerald-300 border border-emerald-500/30 px-2.5 py-0.5 rounded-full shrink-0 font-bold">
              ✓ Multi-Model Consensus
            </span>
          )}
        </div>

        {/* Metrics strip */}
        <div className="mt-3 grid grid-cols-3 gap-4 pt-3 border-t border-white/10 font-mono text-xs">
          <div>
            <p className="text-slate-400 text-[10px] uppercase tracking-wide">Time-to-Event Hazard</p>
            <p className="font-black text-sm text-sky-400 mt-0.5">{result.cphHazardRatio}x Baseline</p>
          </div>
          <div className="border-x border-white/10 px-3">
            <p className="text-slate-400 text-[10px] uppercase tracking-wide">Predicted Delay (Regressor)</p>
            <p className="font-black text-sm text-white mt-0.5">{result.predictedDelayMonths.min}–{result.predictedDelayMonths.max} Mo</p>
          </div>
          <div>
            <p className="text-slate-400 text-[10px] uppercase tracking-wide">Active Red Flags</p>
            <p className="font-black text-sm text-rose-400 mt-0.5">{result.topDrivers.filter(d => d.redFlag).length} Flags</p>
          </div>
        </div>
      </div>

      {/* Body */}
      <div className="grid grid-cols-1 md:grid-cols-2 divide-y md:divide-y-0 md:divide-x divide-slate-800 bg-slate-900/50">
        {/* Top drivers */}
        <div className="p-5">
          <h3 className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-3 font-mono">
            ● Local Feature Attribution (Deviation-Weighted)
          </h3>
          <div className="space-y-3">
            {result.topDrivers.map((d) => (
              <div key={d.driver}>
                <div className="flex justify-between items-center text-xs mb-1">
                  <span className={`font-semibold ${d.redFlag ? "text-red-400" : "text-slate-300"}`}>
                    {d.redFlag ? "⚠ " : ""}{d.driver}
                  </span>
                  <span className="text-slate-400 font-mono text-[11px] font-medium">{d.impactPct}%</span>
                </div>
                <div className="w-full h-1.5 bg-slate-800 rounded-full overflow-hidden">
                  <div
                    className={`h-full rounded-full transition-all duration-500 ${d.redFlag ? "bg-red-500" : "bg-indigo-500"}`}
                    style={{ width: `${Math.min(100, d.impactPct * 2)}%` }}
                  />
                </div>
                <p className="text-[10px] text-slate-400 mt-0.5">{d.detail}</p>
              </div>
            ))}
          </div>
        </div>

        {/* Recommendations */}
        <div className="p-5">
          <h3 className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-3 font-mono">
            ● Statutory Action Directives
          </h3>
          <ul className="space-y-2.5">
            {result.recommendations.map((r, i) => {
              const ucfg = urgencyConfig[r.urgency] ?? urgencyConfig.MONITOR;
              return (
                <li key={i} className="flex items-start gap-2.5 text-xs bg-slate-950 p-2.5 rounded-xl border border-slate-800">
                  <span className={`mt-0.5 shrink-0 rounded-md border ${ucfg.bg} text-[10px] font-bold px-1.5 py-0.5`}>
                    {ucfg.label}
                  </span>
                  <div>
                    <p className="font-semibold text-slate-200 leading-snug">{r.action}</p>
                    {r.withinDays > 0 && (
                      <p className="text-[10px] text-slate-400 mt-0.5 font-mono">SLA: Within {r.withinDays} days · {r.detail}</p>
                    )}
                    {r.withinDays === 0 && (
                      <p className="text-[10px] text-slate-400 mt-0.5">{r.detail}</p>
                    )}
                  </div>
                </li>
              );
            })}
          </ul>
        </div>
      </div>
    </div>
  );
}
