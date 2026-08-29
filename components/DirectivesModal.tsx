"use client";

import React, { useState } from "react";
import { supabase } from "@/lib/supabaseClient";

export interface DirectiveItem {
  id: string;
  projectId: string;
  projectName?: string;
  directiveType: "CAMP" | "LEGAL" | "SURVEY" | "FOREST" | "GENERAL";
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
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

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
      desc: "Instruct Government Pleader to file urgent civil application for vacating interim stay on corridor parcels in Bombay High Court (Nagpur Bench).",
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
      desc: "Submit online compliance report on Parivesh portal and coordinate with DFO Nagpur for joint site inspection.",
      days: 14,
      role: "LAO / Tehsildar",
      type: "FOREST",
    },
  };

  function handleTemplateChange(key: string) {
    setTemplate(key);
    if (templates[key]) {
      setAssignedTo(templates[key].role);
      setTargetDays(templates[key].days);
    }
  }

  async function handleIssue() {
    setSaving(true);
    setError(null);

    const sel = templates[template] || templates.camp;
    const finalDesc = customNote.trim() ? `${sel.desc} Note: ${customNote.trim()}` : sel.desc;

    try {
      const { data: userData } = await supabase.auth.getUser();

      const newDirective = {
        project_id: projectId,
        directive_type: sel.type,
        title: sel.title,
        description: finalDesc,
        target_days: targetDays,
        assigned_to: assignedTo,
        status: "OPEN",
        created_by: userData.user?.id || null,
      };

      const { data, error: insertError } = await supabase
        .from("directives")
        .insert(newDirective)
        .select()
        .single();

      if (insertError) {
        console.warn("Supabase insert notice:", insertError.message);
      }

      const clientItem: DirectiveItem = {
        id: data?.id || `dir-${Date.now()}`,
        projectId,
        projectName,
        directiveType: sel.type,
        title: sel.title,
        description: finalDesc,
        targetDays,
        assignedTo,
        status: "OPEN",
        createdAt: new Date().toISOString(),
      };

      onDirectiveIssued(clientItem);
      onClose();
    } catch (err: any) {
      setError(err?.message || "Failed to dispatch directive.");
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="fixed inset-0 z-50 bg-black/75 backdrop-blur-sm flex items-center justify-center p-4">
      <div className="bg-slate-900 border border-slate-700 text-slate-100 rounded-2xl max-w-lg w-full p-6 shadow-2xl space-y-5 animate-scale-in">
        <div className="flex justify-between items-start border-b border-slate-800 pb-3">
          <div>
            <div className="flex items-center gap-2">
              <span className="w-2 h-2 rounded-full bg-red-500 animate-ping" />
              <span className="text-[10px] font-mono font-bold text-red-400 uppercase tracking-widest">
                District Collector Command Action
              </span>
            </div>
            <h3 className="text-lg font-black text-white mt-1">Issue Executive Directive</h3>
            <p className="text-xs text-slate-400 font-mono truncate max-w-sm">{projectName}</p>
          </div>
          <button
            onClick={onClose}
            className="text-slate-400 hover:text-white text-sm bg-slate-800 hover:bg-slate-700 w-8 h-8 rounded-lg flex items-center justify-center transition"
          >
            ✕
          </button>
        </div>

        {error && (
          <div className="p-3 rounded-xl bg-red-500/10 border border-red-500/20 text-red-400 text-xs font-mono">
            ⚠️ {error}
          </div>
        )}

        <div className="space-y-4 text-xs font-mono">
          <div>
            <label className="block text-slate-300 font-bold mb-1.5">Action Template:</label>
            <div className="grid grid-cols-2 gap-2">
              {Object.entries(templates).map(([k, v]) => (
                <button
                  key={k}
                  type="button"
                  onClick={() => handleTemplateChange(k)}
                  className={`p-2.5 rounded-xl border text-left transition ${
                    template === k
                      ? "bg-indigo-600/30 border-indigo-500 text-white font-bold"
                      : "bg-slate-950 border-slate-800 text-slate-400 hover:border-slate-700"
                  }`}
                >
                  <p className="text-[11px] font-bold text-white truncate">{v.title}</p>
                  <p className="text-[10px] text-slate-500 mt-0.5">{v.role} · {v.days}d SLA</p>
                </button>
              ))}
            </div>
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className="block text-slate-300 font-bold mb-1.5">Assign Officer:</label>
              <select
                value={assignedTo}
                onChange={(e) => setAssignedTo(e.target.value as any)}
                className="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white focus:outline-none focus:ring-1 focus:ring-indigo-500"
              >
                <option value="LAO / Tehsildar">LAO / Tehsildar</option>
                <option value="Patwari">Field Patwari (Talathi)</option>
              </select>
            </div>

            <div>
              <label className="block text-slate-300 font-bold mb-1.5">Statutory SLA Target:</label>
              <div className="flex items-center gap-2">
                <input
                  type="number"
                  min={1}
                  max={60}
                  value={targetDays}
                  onChange={(e) => setTargetDays(Number(e.target.value))}
                  className="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white focus:outline-none focus:ring-1 focus:ring-indigo-500"
                />
                <span className="text-slate-400 text-[11px]">Days</span>
              </div>
            </div>
          </div>

          <div>
            <label className="block text-slate-300 font-bold mb-1.5">Specific Field Instructions (Optional):</label>
            <textarea
              rows={3}
              placeholder="e.g. Prioritize Survey No. 42/1 and 42/2 in Godhani village; report compliance by Friday."
              value={customNote}
              onChange={(e) => setCustomNote(e.target.value)}
              className="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white placeholder:text-slate-600 focus:outline-none focus:ring-1 focus:ring-indigo-500"
            />
          </div>
        </div>

        <div className="pt-2 border-t border-slate-800 flex justify-end gap-2.5 font-mono">
          <button
            type="button"
            onClick={onClose}
            className="px-4 py-2 bg-slate-800 hover:bg-slate-700 text-slate-300 text-xs rounded-xl font-bold transition"
          >
            Cancel
          </button>
          <button
            type="button"
            disabled={saving}
            onClick={handleIssue}
            className="px-5 py-2 bg-red-600 hover:bg-red-500 text-white text-xs rounded-xl font-bold shadow-lg shadow-red-600/25 transition flex items-center gap-2 disabled:opacity-50"
          >
            {saving ? "Transmitting..." : "⚡ Issue Executive Directive"}
          </button>
        </div>
      </div>
    </div>
  );
}
