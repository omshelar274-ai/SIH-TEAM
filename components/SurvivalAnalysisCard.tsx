"use client";

import React from "react";
import { RiskResult } from "@/lib/riskScore";

interface SurvivalAnalysisCardProps {
  result: RiskResult;
  projectName: string;
}

export default function SurvivalAnalysisCard({
  result,
  projectName,
}: SurvivalAnalysisCardProps) {
  const curvePoints = result.kaplanMeierCurve || [];
  const svgWidth = 480;
  const svgHeight = 180;
  const padding = 28;

  // Map day (0-360) and survival (0-1) to SVG coordinates
  const pointsString = curvePoints
    .map((pt) => {
      const x = padding + (pt.day / 360) * (svgWidth - padding * 2);
      const y = padding + (1.0 - pt.survivalRate) * (svgHeight - padding * 2);
      return `${x},${y}`;
    })
    .join(" ");

  return (
    <div className="bg-slate-900 border border-slate-750 rounded-2xl p-5 text-slate-100 shadow-xl space-y-5">
      <div className="flex flex-col md:flex-row md:justify-between md:items-start border-b border-slate-800 pb-3 gap-3">
        <div>
          <div className="flex flex-wrap items-center gap-2">
            <span className="text-sky-400 font-mono text-[11px] font-bold uppercase tracking-wider">
              ● Time-to-Event Survival Analysis
            </span>
            <span className="bg-gradient-to-r from-sky-500/20 to-indigo-500/20 text-sky-300 text-[10px] font-bold px-2.5 py-0.5 rounded-full border border-sky-500/30">
              Breslow Cumulative Hazard Estimator
            </span>
            <span className="bg-emerald-500/10 text-emerald-400 text-[10px] font-mono px-2 py-0.5 rounded border border-emerald-500/20">
              CAG Benchmark Calibrated
            </span>
          </div>
          <h4 className="text-sm font-black text-white mt-1.5">{projectName}</h4>
        </div>
        <div className="flex items-center gap-4 text-right">
          <div className="bg-slate-950 px-3 py-1.5 rounded-xl border border-slate-800">
            <span className="text-[10px] text-slate-400 font-mono block">Composite Hazard Ratio</span>
            <p className="text-base font-black text-sky-400">{result.cphHazardRatio}x</p>
          </div>
        </div>
      </div>

      {/* Multi-horizon delay probabilities */}
      <div>
        <div className="flex justify-between items-center mb-2">
          <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider font-mono">
            Multi-Horizon Cumulative Delay Probability Forecast
          </p>
          <span className="text-[10px] font-mono text-slate-500">S(t) = S₀(t)^HR</span>
        </div>
        <div className="grid grid-cols-4 gap-2 text-center font-mono">
          <div className="bg-slate-950 p-2.5 rounded-xl border border-slate-800">
            <p className="text-[10px] text-slate-400">30-Day</p>
            <p className="text-base font-black text-slate-200 mt-0.5">
              {Math.round(result.delayProb30d * 100)}%
            </p>
          </div>
          <div className="bg-slate-950 p-2.5 rounded-xl border border-slate-800">
            <p className="text-[10px] text-slate-400">60-Day</p>
            <p className="text-base font-black text-slate-200 mt-0.5">
              {Math.round(result.delayProb60d * 100)}%
            </p>
          </div>
          <div className="bg-slate-950 p-2.5 rounded-xl border border-slate-800">
            <p className="text-[10px] text-slate-400">90-Day</p>
            <p className={`text-base font-black mt-0.5 ${result.delayProb90d > 0.6 ? "text-amber-400" : "text-sky-400"}`}>
              {Math.round(result.delayProb90d * 100)}%
            </p>
          </div>
          <div className="bg-slate-950 p-2.5 rounded-xl border border-slate-800">
            <p className="text-[10px] text-slate-400">180-Day</p>
            <p className={`text-base font-black mt-0.5 ${result.delayProb180d > 0.7 ? "text-red-400" : "text-amber-400"}`}>
              {Math.round(result.delayProb180d * 100)}%
            </p>
          </div>
        </div>
      </div>

      {/* SVG Kaplan-Meier Curve */}
      <div className="bg-slate-950 p-4 rounded-xl border border-slate-800 space-y-2">
        <div className="flex justify-between items-center text-[10px] font-mono text-slate-400">
          <span className="font-bold text-slate-300">Project Completion Survival Curve S(t)</span>
          <span>Right-Censored Baseline: S₀(t)</span>
        </div>
        
        <div className="flex justify-center overflow-x-auto">
          <svg width={svgWidth} height={svgHeight} className="overflow-visible">
            {/* Grid Lines */}
            <line x1={padding} y1={padding} x2={svgWidth - padding} y2={padding} stroke="#334155" strokeDasharray="3" />
            <line x1={padding} y1={(svgHeight - padding) / 2 + padding / 2} x2={svgWidth - padding} y2={(svgHeight - padding) / 2 + padding / 2} stroke="#1e293b" strokeDasharray="2" />
            <line x1={padding} y1={svgHeight - padding} x2={svgWidth - padding} y2={svgHeight - padding} stroke="#475569" />
            <line x1={padding} y1={padding} x2={padding} y2={svgHeight - padding} stroke="#475569" />

            {/* Axes Labels */}
            <text x={padding - 20} y={padding + 4} fill="#64748b" fontSize="9" fontFamily="monospace">1.0</text>
            <text x={padding - 20} y={(svgHeight - padding) / 2 + padding / 2 + 3} fill="#64748b" fontSize="9" fontFamily="monospace">0.5</text>
            <text x={padding - 20} y={svgHeight - padding + 3} fill="#64748b" fontSize="9" fontFamily="monospace">0.0</text>

            <text x={padding} y={svgHeight - 10} fill="#64748b" fontSize="9" fontFamily="monospace">Day 0</text>
            <text x={padding + (svgWidth - padding * 2) / 2 - 15} y={svgHeight - 10} fill="#64748b" fontSize="9" fontFamily="monospace">Day 180</text>
            <text x={svgWidth - padding - 35} y={svgHeight - 10} fill="#64748b" fontSize="9" fontFamily="monospace">Day 360</text>

            {/* Polyline Curve */}
            {pointsString && (
              <polyline
                fill="none"
                stroke="#38bdf8"
                strokeWidth="2.5"
                strokeLinecap="round"
                strokeLinejoin="round"
                points={`${padding},${padding} ` + pointsString}
              />
            )}

            {/* Data points */}
            {curvePoints.map((pt, idx) => {
              const x = padding + (pt.day / 360) * (svgWidth - padding * 2);
              const y = padding + (1.0 - pt.survivalRate) * (svgHeight - padding * 2);
              return (
                <g key={idx}>
                  <circle cx={x} cy={y} r="3.5" fill="#0284c7" stroke="#38bdf8" strokeWidth="1.5" />
                  {pt.day === 90 && (
                    <text x={x - 14} y={y - 8} fill="#38bdf8" fontSize="8" fontFamily="monospace" fontWeight="bold">
                      90d
                    </text>
                  )}
                </g>
              );
            })}
          </svg>
        </div>

        <div className="flex justify-between items-center text-[10px] text-slate-500 font-mono pt-1">
          <span>Non-Parametric Baseline Hazard Strata</span>
          <span>Breslow Formulation (1972)</span>
        </div>
      </div>

      {/* Statutory Hazard Covariate Table */}
      {result.cphHazardTable && (
        <div className="bg-slate-950 p-3.5 rounded-xl border border-slate-800 space-y-2 font-mono text-xs">
          <div className="flex justify-between items-center text-[10px] text-slate-400">
            <span className="font-bold text-slate-300 uppercase">● Statutory Hazard Covariates (e^β)</span>
            <span>RFCTLARR 2013 Risk Multipliers</span>
          </div>
          <div className="space-y-1.5 pt-1">
            {result.cphHazardTable.map((cov, idx) => (
              <div key={idx} className="flex justify-between items-center text-[11px] bg-slate-900/60 px-2.5 py-1.5 rounded-lg border border-slate-800/80">
                <div className="flex items-center gap-2">
                  <span className={`w-1.5 h-1.5 rounded-full ${cov.active ? "bg-amber-400 animate-pulse" : "bg-slate-600"}`} />
                  <span className={cov.active ? "text-slate-200 font-medium" : "text-slate-400"}>{cov.variable}</span>
                </div>
                <div className="flex items-center gap-3">
                  <span className="text-slate-500 text-[10px]">β = {cov.coefficient}</span>
                  <span className={`font-bold px-1.5 py-0.5 rounded text-[10px] ${cov.active ? "bg-amber-500/20 text-amber-300 border border-amber-500/30" : "bg-slate-800 text-slate-400"}`}>
                    {cov.hazardRatio}x HR
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
