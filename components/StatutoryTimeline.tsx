"use client";

import React from "react";

interface Milestone {
  code: string;
  name: string;
  statutoryLimitDays: number;
  elapsedDays: number;
  status: "COMPLETED" | "ACTIVE" | "UPCOMING" | "OVERDUE";
  legalRef: string;
}

interface StatutoryTimelineProps {
  projectType: string;
  currentStage?: string;
  stageAgeingDays?: number;
}

export default function StatutoryTimeline({
  projectType,
  currentStage = "DECLARATION",
  stageAgeingDays = 45,
}: StatutoryTimelineProps) {
  const isHighway = projectType.toLowerCase().includes("highway") || projectType.toLowerCase().includes("road");

  const highwayMilestones: Milestone[] = [
    {
      code: "Section 3A",
      name: "Preliminary Notification (Intention to Acquire)",
      statutoryLimitDays: 60,
      elapsedDays: 45,
      status: "COMPLETED",
      legalRef: "National Highways Act 1956, §3A",
    },
    {
      code: "Section 3C",
      name: "Objection Hearing Window",
      statutoryLimitDays: 21,
      elapsedDays: 28,
      status: "OVERDUE",
      legalRef: "National Highways Act 1956, §3C (21-Day SLA)",
    },
    {
      code: "Section 3D",
      name: "Declaration of Acquisition (Vesting with Central Govt)",
      statutoryLimitDays: 365,
      elapsedDays: stageAgeingDays,
      status: "ACTIVE",
      legalRef: "National Highways Act 1956, §3D (365-Day Lapsation)",
    },
    {
      code: "Section 3G",
      name: "Competent Authority Award Determination",
      statutoryLimitDays: 180,
      elapsedDays: 0,
      status: "UPCOMING",
      legalRef: "National Highways Act 1956, §3G",
    },
    {
      code: "Section 3H",
      name: "Compensation Deposit & Possession Handover",
      statutoryLimitDays: 90,
      elapsedDays: 0,
      status: "UPCOMING",
      legalRef: "National Highways Act 1956, §3H",
    },
  ];

  const rfctlarrMilestones: Milestone[] = [
    {
      code: "Section 4(1)",
      name: "Social Impact Assessment (SIA) Notification",
      statutoryLimitDays: 180,
      elapsedDays: 120,
      status: "COMPLETED",
      legalRef: "RFCTLARR Act 2013, §4",
    },
    {
      code: "Section 11(1)",
      name: "Preliminary Notification & Objections (§15)",
      statutoryLimitDays: 60,
      elapsedDays: 55,
      status: "COMPLETED",
      legalRef: "RFCTLARR Act 2013, §11 & §15 (60-Day Window)",
    },
    {
      code: "Section 19(1)",
      name: "Declaration & Summary of Rehabilitation Scheme",
      statutoryLimitDays: 365,
      elapsedDays: stageAgeingDays,
      status: stageAgeingDays > 365 ? "OVERDUE" : "ACTIVE",
      legalRef: "RFCTLARR Act 2013, §19 (365-Day Lapsation Window)",
    },
    {
      code: "Section 23/27",
      name: "Collector Award & Compensation Determination",
      statutoryLimitDays: 365,
      elapsedDays: 0,
      status: "UPCOMING",
      legalRef: "RFCTLARR Act 2013, §23",
    },
    {
      code: "Section 38",
      name: "Enforcing Possession Post Full Compensation Disbursal",
      statutoryLimitDays: 90,
      elapsedDays: 0,
      status: "UPCOMING",
      legalRef: "RFCTLARR Act 2013, §38",
    },
  ];

  const milestones = isHighway ? highwayMilestones : rfctlarrMilestones;

  return (
    <div className="bg-slate-900 border border-slate-750 text-slate-100 rounded-2xl p-5 shadow-xl space-y-4 font-mono text-xs">
      <div className="flex justify-between items-center border-b border-slate-800 pb-3">
        <div>
          <span className="text-amber-400 font-bold uppercase tracking-wider text-[11px]">
            ● Statutory Milestone Progress Clock
          </span>
          <p className="text-[10px] text-slate-400 font-sans mt-0.5">
            {isHighway ? "National Highways Act 1956 Legal Corridor" : "RFCTLARR Act 2013 Statutory Progression"}
          </p>
        </div>
        <span className="text-[10px] bg-slate-800 text-slate-300 px-2.5 py-1 rounded-lg border border-slate-700">
          Stage Ageing: <b>{stageAgeingDays} days</b>
        </span>
      </div>

      <div className="space-y-3">
        {milestones.map((m, idx) => {
          const isOverdue = m.status === "OVERDUE";
          const isActive = m.status === "ACTIVE";
          const isCompleted = m.status === "COMPLETED";

          return (
            <div
              key={idx}
              className={`p-3 rounded-xl border transition-all ${
                isOverdue
                  ? "bg-red-500/10 border-red-500/40 text-red-200"
                  : isActive
                  ? "bg-indigo-500/10 border-indigo-500/40 text-indigo-200"
                  : isCompleted
                  ? "bg-emerald-500/10 border-emerald-500/30 text-slate-300"
                  : "bg-slate-950 border-slate-800/60 text-slate-400"
              }`}
            >
              <div className="flex justify-between items-start">
                <div className="flex items-center gap-2">
                  <span className="font-extrabold text-white text-xs">{m.code}:</span>
                  <span className="font-semibold text-xs text-slate-200">{m.name}</span>
                </div>
                <span
                  className={`text-[9px] px-2 py-0.5 rounded-full font-bold uppercase tracking-wider ${
                    isOverdue
                      ? "bg-red-500/20 text-red-400 border border-red-500/30"
                      : isActive
                      ? "bg-indigo-500/20 text-indigo-300 border border-indigo-500/30 animate-pulse"
                      : isCompleted
                      ? "bg-emerald-500/20 text-emerald-400 border border-emerald-500/30"
                      : "bg-slate-800 text-slate-400"
                  }`}
                >
                  {m.status}
                </span>
              </div>

              <div className="flex justify-between items-center mt-2 text-[10px] text-slate-400 border-t border-slate-800/50 pt-1.5">
                <span>{m.legalRef}</span>
                <span>
                  Statutory SLA: <b>{m.statutoryLimitDays}d</b> · Elapsed: <b>{m.elapsedDays}d</b>
                </span>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}
