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
  const [activeCases, setActiveCases] = useState<number>(baseMetrics.courtCasesActive);
  const [recentCases, setRecentCases] = useState<number>(baseMetrics.courtCasesRecent90d);
  const [forestApplied, setForestApplied] = useState<boolean>(baseMetrics.forestClearanceApplied);
  const [possessionRefusing, setPossessionRefusing] = useState<number>(baseMetrics.possessionRefusingPct);

  // Compute baseline and simulated result in real time
  const baseResult: RiskResult = simulateWhatIf(baseMetrics, {});
  const simulatedResult: RiskResult = simulateWhatIf(baseMetrics, {
    compensationPaidPct: compensation,
    courtCasesActive: activeCases,
    courtCasesRecent90d: recentCases,
    forestClearanceApplied: forestApplied,
    daysSinceForestClearanceNeeded: forestApplied ? 0 : Math.max(90, baseMetrics.daysSinceForestClearanceNeeded),
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
              ● Policy Simulation Engine
            </span>
            <span className="bg-indigo-500/20 text-indigo-300 text-[10px] px-2 py-0.5 rounded-full border border-indigo-500/30 font-bold">
              Interactive What-If Interventions
            </span>
          </div>
          <h3 className="text-lg font-black text-white mt-1">{projectName}</h3>
          <p className="text-xs text-slate-400">
            Simulate administrative interventions below to observe real-time risk reduction and statutory lead-time gains.
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
          <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider font-mono">Current Score</p>
          <p className="text-2xl font-black text-slate-200 mt-0.5">{baseResult.riskScore}/100</p>
          <span className="text-[10px] text-slate-400 font-mono">{baseResult.riskLevel}</span>
        </div>
        <div className="border-x border-slate-800 px-2">
          <p className="text-[10px] font-bold text-indigo-400 uppercase tracking-wider font-mono">Simulated Score</p>
          <p className={`text-2xl font-black mt-0.5 ${simulatedResult.riskScore > 60 ? "text-amber-400" : "text-emerald-400"}`}>
            {simulatedResult.riskScore}/100
          </p>
          <span className="text-[10px] text-indigo-300 font-mono">{simulatedResult.riskLevel}</span>
        </div>
        <div>
          <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider font-mono">Net Impact</p>
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
              <span>💰</span> Compensation Disbursed (PFMS):
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
            className="w-full h-1.5 bg-slate-800 rounded-lg appearance-none cursor-pointer accent-indigo-500"
          />
        </div>

        {/* 2. Active Litigation / Injunctions */}
        <div>
          <div className="flex justify-between items-center mb-1.5">
            <span className="text-slate-300 font-bold flex items-center gap-1.5">
              <span>⚖️</span> Active Court Cases & Injunctions:
            </span>
            <span className="text-amber-400 font-extrabold">{activeCases} cases</span>
          </div>
          <input
            type="range"
            min="0"
            max="30"
            step="1"
            value={activeCases}
            onChange={(e) => setActiveCases(Number(e.target.value))}
            className="w-full h-1.5 bg-slate-800 rounded-lg appearance-none cursor-pointer accent-amber-500"
          />
        </div>

        {/* 3. Recent 90-Day Dispute Velocity */}
        <div>
          <div className="flex justify-between items-center mb-1.5">
            <span className="text-slate-300 font-bold flex items-center gap-1.5">
              <span>⚡</span> Litigation Velocity (New in Last 90d):
            </span>
            <span className="text-rose-400 font-extrabold">{recentCases} cases</span>
          </div>
          <input
            type="range"
            min="0"
            max="15"
            step="1"
            value={recentCases}
            onChange={(e) => setRecentCases(Number(e.target.value))}
            className="w-full h-1.5 bg-slate-800 rounded-lg appearance-none cursor-pointer accent-rose-500"
          />
        </div>

        {/* 4. Possession Refusal % */}
        <div>
          <div className="flex justify-between items-center mb-1.5">
            <span className="text-slate-300 font-bold flex items-center gap-1.5">
              <span>🚫</span> Land Possession Refusal Rate:
            </span>
            <span className="text-red-400 font-extrabold">{possessionRefusing}%</span>
          </div>
          <input
            type="range"
            min="0"
            max="50"
            step="1"
            value={possessionRefusing}
            onChange={(e) => setPossessionRefusing(Number(e.target.value))}
            className="w-full h-1.5 bg-slate-800 rounded-lg appearance-none cursor-pointer accent-red-500"
          />
        </div>

        {/* 5. Forest Clearance Status */}
        <div className="flex items-center justify-between p-3 rounded-xl bg-slate-950 border border-slate-800">
          <span className="text-slate-300 font-bold flex items-center gap-1.5">
            <span>🌲</span> Stage-1 / Stage-2 Forest NOC Granted:
          </span>
          <button
            type="button"
            onClick={() => setForestApplied(!forestApplied)}
            className={`px-3 py-1 rounded-lg text-xs font-bold transition ${
              forestApplied
                ? "bg-emerald-500/20 text-emerald-400 border border-emerald-500/30"
                : "bg-red-500/20 text-red-400 border border-red-500/30"
            }`}
          >
            {forestApplied ? "✓ Clearance Secured" : "⚠ Overdue / Pending"}
          </button>
        </div>
      </div>

      {/* Reset Interventions */}
      <div className="flex justify-between items-center pt-2 border-t border-slate-800 text-[11px] font-mono">
        <button
          type="button"
          onClick={() => {
            setCompensation(baseMetrics.compensationPaidPct);
            setActiveCases(baseMetrics.courtCasesActive);
            setRecentCases(baseMetrics.courtCasesRecent90d);
            setForestApplied(baseMetrics.forestClearanceApplied);
            setPossessionRefusing(baseMetrics.possessionRefusingPct);
          }}
          className="text-slate-400 hover:text-white transition underline"
        >
          ↺ Reset to Ground Telemetry
        </button>
        <span className="text-slate-500">Real-Time Survival Re-computation</span>
      </div>
    </div>
  );
}
