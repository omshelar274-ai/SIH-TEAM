"use client";

import React, { useState } from "react";
import Link from "next/link";

export default function DemoWalkthroughPage() {
  const [step, setStep] = useState(0);

  const demoSteps = [
    {
      title: "1. Land Acquisition Early Warning Directive (DoLR PS 26017)",
      desc: "Designed specifically to detect structural land acquisition delay events early, using point-in-time timeline reconstruction rules and ML risk scoring.",
      action: "Inspect the District Collector panel with real-time risk scores and GIS heatmap overlays.",
      route: "/dashboard",
      badge: "Overview & Goal",
    },
    {
      title: "2. Role-Based Ground Hierarchy Isolation",
      desc: "Distinct dashboards for District Collector (Early Warning & Directives), Land Acquisition Officer (Statutory Audits & Verification), and Patwari (Ground Survey Data Entry).",
      action: "Switch between Collector, LAO, and Patwari panels to observe role-based district scoping.",
      route: "/dashboard",
      badge: "Role Isolation",
    },
    {
      title: "3. Point-in-Time Feature Engineering (No Data Leakage)",
      desc: "Enforces strict temporal separation: features available at time T are calculated strictly from events before or at timestamp T. No future outcome leaks into predictions.",
      action: "Check 90-day court filing velocity, average litigation age, and compensation disbursal percentages.",
      route: "/dashboard",
      badge: "ML Grounding",
    },
    {
      title: "4. Multi-Horizon Survival Analysis (Cox Proportional Hazards)",
      desc: "Computes calibrated delay probabilities across 30d, 60d, 90d, and 180d horizons using Cox Proportional Hazards (CPH) survival curves S(t) = S₀(t)^HR.",
      action: "View the custom SVG Kaplan-Meier baseline curve and proportional hazards ratio.",
      route: "/dashboard",
      badge: "Survival Math",
    },
    {
      title: "5. Multi-Model Consensus Agreement Index",
      desc: "Assesses cross-model agreement between Random Forest Classifier, Logistic Hazards, and Cox Survival Models to output a consensus risk score and divergence warning.",
      action: "Check the multi-model consensus agreement card with LOW/MEDIUM/HIGH divergence levels.",
      route: "/dashboard",
      badge: "Ensemble Validation",
    },
    {
      title: "6. Interactive What-If Policy Simulation Sliders",
      desc: "Live sensitivity sliders for Compensation Disbursal %, Stay Orders, and Litigation Counts showing instantaneous simulated risk score drops and months saved.",
      action: "Open the What-If Simulator on any project card to test policy interventions.",
      route: "/dashboard",
      badge: "Policy Simulator",
    },
    {
      title: "7. Collector Directives & Notification Hierarchy Loop",
      desc: "Collector dispatches binding orders ('Hold special compensation clearance camp in 7 days') which immediately notify the LAO and Patwari inboxes with status tracking.",
      action: "Click 'Issue Directive' to dispatch an order, then observe it appear on the LAO dashboard.",
      route: "/dashboard/lao",
      badge: "Administrative Loop",
    },
    {
      title: "8. Statutory Milestone SLA Progression (NH Act & RFCTLARR 2013)",
      desc: "Tracks legally mandated milestones (Section 3A → 3C → 3D → 3G for NHAI or Section 4/11/19 for RFCTLARR) with countdown clocks and statutory lapsation alerts.",
      action: "Review statutory SLA breach warnings on the LAO verification panel.",
      route: "/dashboard/lao",
      badge: "Statutory SLA",
    },
    {
      title: "9. Ground Data Entry & Surveyor Verification Queue",
      desc: "Patwari inputs family survey numbers and compensation requests; LAO audits revenue records and approves/rejects with persistent Supabase writes.",
      action: "Review pending family entries in the LAO Verification Queue.",
      route: "/dashboard/lao",
      badge: "Human-in-the-Loop",
    },
    {
      title: "10. Real CAG Performance Audit Case Studies",
      desc: "Benchmarked against historical CAG infrastructure performance audits (Bangalore Metro Phase 2 Reach 6, East Central Railway Hajipur-Sagauli).",
      action: "Review the historical backtesting replay and lead-time alert verification.",
      route: "/cag-benchmarks",
      badge: "CAG Ground Truth",
    },
    {
      title: "11. Real-Time Gov Portals Sync (Bhoomi Rashi & e-Courts NJDG)",
      desc: "Multi-step diagnostic streaming gateway that cross-references district revenue parcels and active civil injunctions, inserting verified records into Supabase.",
      action: "Click 'Sync Gov Portals' to trigger live multi-step streaming ingestion.",
      route: "/dashboard",
      badge: "API Gateway",
    },
  ];

  const current = demoSteps[step];

  return (
    <main className="max-w-4xl mx-auto px-6 py-10 font-sans text-slate-100">
      {/* Header */}
      <div className="flex justify-between items-center mb-8 border-b border-slate-800 pb-4">
        <div>
          <div className="flex items-center gap-2">
            <span className="text-indigo-400 font-mono text-xs font-bold uppercase">
              ● SIH 2026 Presentation Mode
            </span>
            <span className="bg-indigo-500/20 text-indigo-300 text-[10px] px-2.5 py-0.5 rounded-full border border-indigo-500/30">
              Judges & Evaluators Tour
            </span>
          </div>
          <h1 className="text-3xl font-black text-white mt-1 tracking-tight">
            Guided System Walkthrough
          </h1>
          <p className="text-xs text-slate-400 mt-1">
            Step-by-step tour covering all technical pillars, predictive models, statutory timelines, and administrative workflows.
          </p>
        </div>
        <Link
          href="/dashboard"
          className="btn-secondary text-xs px-4 py-2"
        >
          ← Exit to Dashboard
        </Link>
      </div>

      {/* Progress Bar */}
      <div className="mb-6 space-y-2">
        <div className="flex justify-between text-xs text-slate-400 font-mono">
          <span>Step {step + 1} of {demoSteps.length}</span>
          <span className="text-indigo-400 font-bold">{current.badge}</span>
        </div>
        <div className="w-full bg-slate-900 h-2 rounded-full overflow-hidden border border-slate-800">
          <div
            className="bg-indigo-600 h-full transition-all duration-300 rounded-full"
            style={{ width: `${((step + 1) / demoSteps.length) * 100}%` }}
          />
        </div>
      </div>

      {/* Main Step Card */}
      <div className="bg-slate-900 border border-slate-750 rounded-2xl p-8 shadow-2xl space-y-6 animate-fade-in">
        <div className="flex justify-between items-start">
          <h2 className="text-xl font-extrabold text-white">{current.title}</h2>
          <span className="bg-indigo-500/10 text-indigo-400 text-xs px-3 py-1 rounded-full border border-indigo-500/20 font-mono font-bold">
            {current.badge}
          </span>
        </div>

        <p className="text-sm text-slate-300 leading-relaxed font-sans">
          {current.desc}
        </p>

        <div className="bg-slate-950 p-4 rounded-xl border border-slate-800 space-y-1.5 font-mono text-xs">
          <span className="text-indigo-400 font-bold">⚡ Recommended Live Action:</span>
          <p className="text-slate-300">{current.action}</p>
        </div>

        <div className="flex justify-between items-center pt-4 border-t border-slate-800">
          <Link
            href={current.route}
            className="btn-primary text-xs px-5 py-2.5 flex items-center gap-2 font-bold"
          >
            <span>Open Feature in App</span>
            <span>↗</span>
          </Link>

          <div className="flex gap-2">
            <button
              onClick={() => setStep(Math.max(0, step - 1))}
              disabled={step === 0}
              className="btn-secondary text-xs px-4 py-2 disabled:opacity-30"
            >
              ← Previous
            </button>
            <button
              onClick={() => setStep(Math.min(demoSteps.length - 1, step + 1))}
              disabled={step === demoSteps.length - 1}
              className="btn-primary text-xs px-5 py-2 disabled:opacity-30"
            >
              Next Step →
            </button>
          </div>
        </div>
      </div>

      {/* Steps Quick Selector */}
      <div className="mt-8">
        <p className="text-xs font-bold text-slate-400 uppercase font-mono mb-3">Jump to Demonstration Step:</p>
        <div className="grid grid-cols-2 md:grid-cols-3 gap-2">
          {demoSteps.map((s, idx) => (
            <button
              key={idx}
              onClick={() => setStep(idx)}
              className={`p-3 rounded-xl border text-left text-xs transition ${
                step === idx
                  ? "bg-indigo-600/20 border-indigo-500 text-white font-bold"
                  : "bg-slate-900 border-slate-800 text-slate-400 hover:text-slate-200"
              }`}
            >
              <span className="text-[10px] text-indigo-400 font-mono block">Step {idx + 1}</span>
              <p className="truncate mt-0.5">{s.title.replace(/^\d+\.\s*/, "")}</p>
            </button>
          ))}
        </div>
      </div>
    </main>
  );
}
