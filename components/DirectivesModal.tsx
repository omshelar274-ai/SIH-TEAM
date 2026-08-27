"use client";

import React, { useState } from "react";

export interface DirectiveItem {
  id: string;
  projectId: string;
  projectName: string;
  directiveType: "CAMP" | "LEGAL" | "SURVEY" | "FOREST";
  title: string;
  description: string;
  targetDays: number;
  assignedTo: "LAO / Tehsildar" | "Patwari";
  status: "OPEN" | "IN_PROGRESS" | "RESOLVED";
  createdAt: string;
}

interface DirectivesModalProps {
  projectId: string;
  projectName: string;
  onClose: () => void;
  onDirectiveIssued: (directive: DirectiveItem) => void;
}

export default function DirectivesModal({
  projectId,
  projectName,
  onClose,
  onDirectiveIssued,
}: DirectivesModalProps) {
  const [template, setTemplate] = useState<string>("camp");
  const [assignedTo, setAssignedTo] = useState<"LAO / Tehsildar" | "Patwari">("LAO / Tehsildar");
  const [targetDays, setTargetDays] = useState<number>(7);
  const [customNote, setCustomNote] = useState<string>("");

  const templates: Record<string, { title: string; desc: string; days: number; role: "LAO / Tehsildar" | "Patwari"; type: DirectiveItem["directiveType"] }> = {
    camp: {
      title: "Hold Special Compensation Clearance Camp",
      desc: "Deploy mobile revenue team to complete pending disbursements for verified landowner parcels.",
      days: 7,
      role: "LAO / Tehsildar",
      type: "CAMP",
    },
    legal: {
      title: "File High Court Stay Vacation Application",
      desc: "Instruct Government Pleader to file urgent civil application for vacating interim stay on corridor parcels.",
      days: 14,
      role: "LAO / Tehsildar",
      type: "LEGAL",
    },
    possession: {
      title: "Deploy Field Team for Possession Refusal Conciliation",
      desc: "Engage Gram Panchayat leadership and affected families to resolve possession refusal objections.",
      days: 10,
      role: "Patwari",
      type: "SURVEY",
    },
    forest: {
      title: "Expedite Stage-1 Forest Clearance Proposal",
      desc: "Submit online compliance report on Parivesh portal and coordinate with DFO Pune for joint site inspection.",
      days: 5,
      role: "LAO / Tehsildar",
      type: "FOREST",
    },
  };

  function handleSelectTemplate(key: string) {
    setTemplate(key);
    const sel = templates[key];
    if (sel) {
      setTargetDays(sel.days);
      setAssignedTo(sel.role);
    }
  }

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    const sel = templates[template];
    const newDirective: DirectiveItem = {
      id: `dir-${Date.now()}`,
      projectId,
      projectName,
      directiveType: sel.type,
      title: sel.title,
      description: customNote ? `${sel.desc} Note: ${customNote}` : sel.desc,
      targetDays,
      assignedTo,
      status: "OPEN",
      createdAt: new Date().toISOString(),
    };

    // Store in localStorage for instantaneous cross-tab sync between Collector, LAO, and Patwari
    const existing = JSON.parse(localStorage.getItem("collector_directives") || "[]");
    localStorage.setItem("collector_directives", JSON.stringify([newDirective, ...existing]));

    onDirectiveIssued(newDirective);
    onClose();
  }

  return (
    <div className="fixed inset-0 bg-black/75 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div className="bg-slate-900 border border-slate-750 text-slate-100 rounded-2xl p-6 max-w-lg w-full shadow-2xl space-y-5 animate-fade-in font-sans">
        <div className="flex justify-between items-start border-b border-slate-800 pb-3">
          <div>
            <div className="flex items-center gap-2">
              <span className="text-amber-400 font-mono text-xs font-bold uppercase">
                ● Collector Action Directive
              </span>
              <span className="bg-amber-500/20 text-amber-300 text-[10px] px-2 py-0.5 rounded-full border border-amber-500/30">
                Official Order
              </span>
            </div>
            <h3 className="text-lg font-black text-white mt-1">Issue Administrative Directive</h3>
            <p className="text-xs text-slate-400">Target Project: <b>{projectName}</b></p>
          </div>
          <button
            onClick={onClose}
            className="text-slate-400 hover:text-white bg-slate-800 w-8 h-8 rounded-lg flex items-center justify-center transition font-bold"
          >
            ✕
          </button>
        </div>

        <form onSubmit={handleSubmit} className="space-y-4 text-xs font-mono">
          {/* Directive Type Presets */}
          <div>
            <label className="block text-slate-300 font-bold mb-2">Select Directive Template:</label>
            <div className="grid grid-cols-2 gap-2">
              {Object.entries(templates).map(([k, v]) => (
                <button
                  key={k}
                  type="button"
                  onClick={() => handleSelectTemplate(k)}
                  className={`p-3 rounded-xl border text-left transition ${
                    template === k
                      ? "bg-indigo-600/20 border-indigo-500 text-white font-bold"
                      : "bg-slate-950 border-slate-800 text-slate-400 hover:text-slate-200"
                  }`}
                >
                  <p className="text-[11px] leading-tight">{v.title}</p>
                  <span className="text-[9px] text-slate-400 block mt-1">SLA: {v.days}d · {v.role}</span>
                </button>
              ))}
            </div>
          </div>

          {/* Assigned Authority */}
          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className="block text-slate-300 font-bold mb-1">Assigned Authority:</label>
              <select
                value={assignedTo}
                onChange={(e) => setAssignedTo(e.target.value as any)}
                className="w-full bg-slate-950 border border-slate-800 rounded-lg p-2 text-white font-sans text-xs"
              >
                <option value="LAO / Tehsildar">LAO / Tehsildar</option>
                <option value="Patwari">Patwari (Talathi)</option>
              </select>
            </div>
            <div>
              <label className="block text-slate-300 font-bold mb-1">Execution SLA Target:</label>
              <input
                type="number"
                min="1"
                max="60"
                value={targetDays}
                onChange={(e) => setTargetDays(Number(e.target.value))}
                className="w-full bg-slate-950 border border-slate-800 rounded-lg p-2 text-white font-sans text-xs"
              />
            </div>
          </div>

          {/* Custom Note */}
          <div>
            <label className="block text-slate-300 font-bold mb-1">Additional Collector Remarks / Orders:</label>
            <textarea
              rows={2}
              placeholder="e.g. Priority clearance for Section 3C objections in Wadgaon village."
              value={customNote}
              onChange={(e) => setCustomNote(e.target.value)}
              className="w-full bg-slate-950 border border-slate-800 rounded-lg p-2 text-white font-sans text-xs"
            />
          </div>

          <div className="flex gap-3 pt-2">
            <button
              type="button"
              onClick={onClose}
              className="btn-secondary flex-1 py-2.5 text-xs font-sans"
            >
              Cancel
            </button>
            <button
              type="submit"
              className="btn-primary flex-1 py-2.5 text-xs font-sans font-bold bg-amber-600 hover:bg-amber-500 text-white"
            >
              🚀 Dispatch Binding Order
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
