"use client";

import React, { useState } from "react";
import { ProjectMetrics, RiskResult, simulateWhatIf } from "@/lib/riskScore";

interface WhatIfSimulatorProps {
  baseMetrics: ProjectMetrics;
  projectName: string;
  onClose?: () => void;
}

export default function WhatIfSimulator({
  baseMetrics,
  projectName,
  onClose,
}: WhatIfSimulatorProps) {
  const [compensation, setCompensation] = useState<number>(baseMetrics.compensationPaidPct);
  const [hasStay, setHasStay] = useState<boolean>(baseMetrics.courtCasesActive > 15);
  const [recentCases, setRecentCases] = useState<number>(baseMetrics.courtCasesRecent90d);
  const [forestApplied, setForestApplied] = useState<boolean>(baseMetrics.forestClearanceApplied);
  const [possessionRefusing, setPossessionRefusing] = useState<number>(baseMetrics.possessionRefusingPct);

  // Compute baseline and simulated result in real time
  const baseResult: RiskResult = simulateWhatIf(baseMetrics, {});
  const simulatedResult: RiskResult = simulateWhatIf(baseMetrics, {
    compensationPaidPct: compensation,
    courtCasesRecent90d: recentCases,
    courtCasesActive: hasStay ? Math.max(16, baseMetrics.courtCasesActive) : Math.min(5, baseMetrics.courtCasesActive),
    forestClearanceApplied: forestApplied,
    daysSinceForestClearanceNeeded: forestApplied ? 0 : baseMetrics.daysSinceForestClearanceNeeded,
    possessionRefusingPct: possessionRefusing,
  });

  const deltaScore = simulatedResult.riskScore - baseResult.riskScore;
  const isImproved = deltaScore < 0;

  return (
    <div className="bg-slate-900 border border-slate-700 text-slate-100 rounded-2xl p-6 shadow-2xl space-y-6">
      <div className="flex justify-between items-start border-b border-slate-800 pb-4">
        <div>
          <div className="flex items-center gap-2">
            <span className="text-indigo-400 font-mono text-xs font-bold uppercase tracking-wider">
              ● Scenario Simulation Engine
            </span>
            <span className="bg-indigo-500/20 text-indigo-300 text-[10px] px-2 py-0.5 rounded-full border border-indigo-500/30">
              Interactive What-If
            </span>
          </div>
          <h3 className="text-lg font-black text-white mt-1">{projectName}</h3>
          <p className="text-xs text-slate-400">
            Adjust policy levers & administrative interventions below to observe real-time risk reduction and lead-time gains.
          </p>
        </div>
        {onClose && (
          <button
            onClick={onClose}
            className="text-slate-400 hover:text-white text-sm font-bold bg-slate-800 hover:bg-slate-700 w-8 h-8 rounded-lg flex items-center justify-center transition"
          >
            ✕
          </button>
        )}
      </div>

      {/* Score Comparison Strip */}
      <div className="grid grid-cols-3 gap-3 bg-slate-950 p-4 rounded-xl border border-slate-800 text-center">
        <div>
          <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Current Score</p>
          <p className="text-2xl font-black text-slate-200 mt-0.5">{baseResult.riskScore}/100</p>
          <span className="text-[10px] text-slate-400 font-mono">{baseResult.riskLevel}</span>
        </div>
        <div className="border-x border-slate-800 px-2">
          <p className="text-[10px] font-bold text-indigo-400 uppercase tracking-wider">Simulated Score</p>
          <p className={`text-2xl font-black mt-0.5 ${simulatedResult.riskScore > 60 ? "text-amber-400" : "text-emerald-400"}`}>
            {simulatedResult.riskScore}/100
          </p>
          <span className="text-[10px] text-indigo-300 font-mono">{simulatedResult.riskLevel}</span>
        </div>
        <div>
          <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Net Impact</p>
          <p className={`text-2xl font-black mt-0.5 ${isImproved ? "text-emerald-400" : deltaScore === 0 ? "text-slate-400" : "text-red-400"}`}>
            {isImproved ? `▼ ${Math.abs(deltaScore)} pts` : deltaScore === 0 ? "0 pts" : `▲ +${deltaScore} pts`}
          </p>
          <span className="text-[10px] text-slate-400 font-mono">
            {simulatedResult.predictedDelayMonths.max < baseResult.predictedDelayMonths.max
              ? `~${baseResult.predictedDelayMonths.max - simulatedResult.predictedDelayMonths.max} mo saved`
              : "No delay delta"}
          </span>
        </div>
      </div>

      {/* Sliders Grid */}
      <div className="space-y-4 text-xs font-mono">
        {/* 1. Compensation Payout */}
        <div>
          <div className="flex justify-between items-center mb-1.5">
            <span className="text-slate-300 font-bold flex items-center gap-1.5">
              <span>💰</span> Compensation Disbursed:
            </span>
            <span className="text-indigo-400 font-extrabold">{compensation}%</span>
          </div>
          <input
            type="range"
            min="0"
            max="100"
            step="1"
            value={compensation}
            onChange={(e) => setCompensation(Number(e.target.value))}
            className="w-full h-2 bg-slate-800 rounded-lg appearance-none cursor-pointer accent-indigo-500"
          />
          <div className="flex justify-between text-[10px] text-slate-400 mt-1">
            <span>0% (Severe Delay)</span>
            <span>Target: ≥80% (Safe)</span>
            <span>100% (Completed)</span>
          </div>
        </div>

        {/* 2. Possession Refusal */}
        <div>
          <div className="flex justify-between items-center mb-1.5">
            <span className="text-slate-300 font-bold flex items-center gap-1.5">
              <span>🏡</span> Possession Refusing Rate:
            </span>
            <span className="text-indigo-400 font-extrabold">{possessionRefusing}%</span>
          </div>
          <input
            type="range"
            min="0"
            max="100"
            step="1"
            value={possessionRefusing}
            onChange={(e) => setPossessionRefusing(Number(e.target.value))}
            className="w-full h-2 bg-slate-800 rounded-lg appearance-none cursor-pointer accent-indigo-500"
          />
          <div className="flex justify-between text-[10px] text-slate-400 mt-1">
            <span>0% (Vacated)</span>
            <span>PRAGATI Threshold: &lt;25%</span>
            <span>100% (Blocked)</span>
          </div>
        </div>

        {/* 3. Recent Legal Cases */}
        <div>
          <div className="flex justify-between items-center mb-1.5">
            <span className="text-slate-300 font-bold flex items-center gap-1.5">
              <span>⚖️</span> Recent Court Filings (90d Velocity):
            </span>
            <span className="text-indigo-400 font-extrabold">{recentCases} cases</span>
          </div>
          <input
            type="range"
            min="0"
            max="25"
            step="1"
            value={recentCases}
            onChange={(e) => setRecentCases(Number(e.target.value))}
            className="w-full h-2 bg-slate-800 rounded-lg appearance-none cursor-pointer accent-indigo-500"
          />
        </div>

        {/* 4. Action Toggles */}
        <div className="grid grid-cols-2 gap-3 pt-2">
          <button
            type="button"
            onClick={() => setHasStay(!hasStay)}
            className={`p-3 rounded-xl border text-left transition flex justify-between items-center ${
              hasStay
                ? "bg-red-500/10 border-red-500/30 text-red-300"
                : "bg-emerald-500/10 border-emerald-500/30 text-emerald-300"
            }`}
          >
            <div>
              <p className="font-bold text-[11px]">High Court Stay Order</p>
              <p className="text-[9px] opacity-75">{hasStay ? "Active Injunction" : "Vacated / Cleared"}</p>
            </div>
            <span className="text-sm font-black">{hasStay ? "🔴 YES" : "🟢 NO"}</span>
          </button>

          <button
            type="button"
            onClick={() => setForestApplied(!forestApplied)}
            className={`p-3 rounded-xl border text-left transition flex justify-between items-center ${
              forestApplied
                ? "bg-emerald-500/10 border-emerald-500/30 text-emerald-300"
                : "bg-amber-500/10 border-amber-500/30 text-amber-300"
            }`}
          >
            <div>
              <p className="font-bold text-[11px]">Forest Stage 1 Clearance</p>
              <p className="text-[9px] opacity-75">{forestApplied ? "Filed & In Process" : "Pending Application"}</p>
            </div>
            <span className="text-sm font-black">{forestApplied ? "🟢 FILED" : "🟡 PENDING"}</span>
          </button>
        </div>
      </div>

      {/* Simulated 90-day Survival Indicator */}
      <div className="bg-indigo-950/40 border border-indigo-800/40 p-3 rounded-xl flex items-center justify-between text-xs">
        <div>
          <span className="text-indigo-300 font-bold">Predicted 90-Day Delay Probability:</span>
          <p className="text-[10px] text-slate-400 mt-0.5">Calculated via Cox Proportional Hazards survival function</p>
        </div>
        <div className="text-right">
          <span className="text-lg font-black text-indigo-400">
            {Math.round(simulatedResult.delayProb90d * 100)}%
          </span>
          <p className="text-[9px] text-slate-400">
            Baseline: {Math.round(baseResult.delayProb90d * 100)}%
          </p>
        </div>
      </div>
    </div>
  );
}
