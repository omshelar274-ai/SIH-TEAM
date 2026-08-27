import { RiskResult } from "@/lib/riskScore";

const levelConfig: Record<
  RiskResult["riskLevel"],
  { border: string; header: string; badge: string; ring: string; icon: string }
> = {
  CRITICAL: {
    border: "border-red-300",
    header: "bg-gradient-to-r from-red-600 to-rose-600",
    badge:  "bg-red-100 text-red-700",
    ring:   "ring-red-200",
    icon:   "🔴",
  },
  HIGH: {
    border: "border-orange-300",
    header: "bg-gradient-to-r from-orange-500 to-amber-500",
    badge:  "bg-orange-100 text-orange-700",
    ring:   "ring-orange-200",
    icon:   "🟠",
  },
  MODERATE: {
    border: "border-yellow-300",
    header: "bg-gradient-to-r from-yellow-500 to-amber-400",
    badge:  "bg-yellow-100 text-yellow-700",
    ring:   "ring-yellow-200",
    icon:   "🟡",
  },
  LOW: {
    border: "border-emerald-300",
    header: "bg-gradient-to-r from-emerald-500 to-teal-500",
    badge:  "bg-emerald-100 text-emerald-700",
    ring:   "ring-emerald-200",
    icon:   "🟢",
  },
};

const urgencyConfig: Record<string, { bg: string; label: string }> = {
  URGENT:  { bg: "bg-red-500",    label: "URGENT" },
  HIGH:    { bg: "bg-orange-500", label: "HIGH" },
  MONITOR: { bg: "bg-slate-400",  label: "MONITOR" },
};

export default function RiskCard({
  projectName,
  result,
}: {
  projectName: string;
  result: RiskResult;
}) {
  const cfg = levelConfig[result.riskLevel];

  // Gauge arc calculation
  const gaugeAngle = (result.riskScore / 100) * 180; // 0-180 degrees

  return (
    <div className={`rounded-2xl border-2 ${cfg.border} bg-white shadow-sm overflow-hidden animate-fade-in`}>
      {/* Header bar */}
      <div className={`${cfg.header} px-6 py-5 text-white`}>
        <div className="flex items-start justify-between gap-4">
          <div className="flex-1 min-w-0">
            <div className="flex items-center gap-2 mb-1">
              <span className="text-white/70 text-xs font-semibold uppercase tracking-wider">{result.riskLevel} RISK</span>
            </div>
            <h2 className="font-bold text-lg leading-snug truncate">{projectName}</h2>
          </div>

          {/* Score gauge */}
          <div className="shrink-0 text-right">
            <div className={`w-16 h-16 rounded-full ring-4 ${cfg.ring} bg-white/15 flex items-center justify-center`}>
              <span className="text-2xl font-black leading-none">{result.riskScore}</span>
            </div>
            <p className="text-white/70 text-2xs mt-1">out of 100</p>
          </div>
        </div>

        {/* Metrics strip */}
        <div className="mt-4 flex items-center gap-6 text-sm">
          <div>
            <p className="text-white/60 text-2xs uppercase tracking-wide">Delay Probability</p>
            <p className="font-bold">{result.delayProbabilityPct}%</p>
          </div>
          <div className="w-px h-8 bg-white/20" />
          <div>
            <p className="text-white/60 text-2xs uppercase tracking-wide">Predicted Delay</p>
            <p className="font-bold">{result.predictedDelayMonths.min}–{result.predictedDelayMonths.max} months</p>
          </div>
          <div className="w-px h-8 bg-white/20" />
          <div>
            <p className="text-white/60 text-2xs uppercase tracking-wide">Risk Drivers</p>
            <p className="font-bold">{result.topDrivers.filter(d => d.redFlag).length} red flags</p>
          </div>
        </div>
      </div>

      {/* Body */}
      <div className="grid grid-cols-1 md:grid-cols-2 divide-y md:divide-y-0 md:divide-x divide-slate-100">
        {/* Top drivers */}
        <div className="p-5">
          <h3 className="text-xs font-bold text-slate-500 uppercase tracking-wider mb-3">
            Delay Driver Analysis
          </h3>
          <div className="space-y-2.5">
            {result.topDrivers.map((d) => (
              <div key={d.driver}>
                <div className="flex justify-between items-center text-sm mb-1">
                  <span className={`font-semibold ${d.redFlag ? "text-red-600" : "text-slate-600"}`}>
                    {d.redFlag ? "⚠ " : ""}{d.driver}
                  </span>
                  <span className="text-slate-400 text-xs font-medium">{d.impactPct}%</span>
                </div>
                <div className="w-full h-1.5 bg-slate-100 rounded-full overflow-hidden">
                  <div
                    className={`h-full rounded-full ${d.redFlag ? "bg-red-400" : "bg-slate-300"}`}
                    style={{ width: `${Math.min(100, d.impactPct * 2)}%` }}
                  />
                </div>
                <p className="text-2xs text-slate-400 mt-0.5">{d.detail}</p>
              </div>
            ))}
          </div>
        </div>

        {/* Recommendations */}
        <div className="p-5">
          <h3 className="text-xs font-bold text-slate-500 uppercase tracking-wider mb-3">
            Recommended Actions
          </h3>
          <ul className="space-y-2.5">
            {result.recommendations.map((r, i) => {
              const ucfg = urgencyConfig[r.urgency] ?? urgencyConfig.MONITOR;
              return (
                <li key={i} className="flex items-start gap-2.5 text-sm">
                  <span className={`mt-0.5 shrink-0 rounded-md ${ucfg.bg} text-white text-2xs font-bold px-1.5 py-0.5`}>
                    {ucfg.label}
                  </span>
                  <div>
                    <p className="font-semibold text-slate-800 leading-snug">{r.action}</p>
                    {r.withinDays > 0 && (
                      <p className="text-2xs text-slate-400 mt-0.5">Within {r.withinDays} days · {r.detail}</p>
                    )}
                    {r.withinDays === 0 && (
                      <p className="text-2xs text-slate-400 mt-0.5">{r.detail}</p>
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
