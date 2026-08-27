"use client";

import { useState } from "react";
import { supabase } from "@/lib/supabaseClient";
import { DirectiveItem } from "@/components/DirectivesModal";

interface ResolveDirectiveModalProps {
  directive: DirectiveItem;
  officerRole: "LAO / Tehsildar" | "Patwari";
  onClose: () => void;
  onResolved: (updatedDirective: DirectiveItem) => void;
}

export default function ResolveDirectiveModal({
  directive,
  officerRole,
  onClose,
  onResolved,
}: ResolveDirectiveModalProps) {
  const [resolutionNote, setResolutionNote] = useState("");
  const [autoVerifyFamilies, setAutoVerifyFamilies] = useState(true);
  const [autoDisburseComp, setAutoDisburseComp] = useState(false);
  const [autoResolveObjections, setAutoResolveObjections] = useState(true);
  const [saving, setSaving] = useState(false);
  const [successMessage, setSuccessMessage] = useState<string | null>(null);

  async function handleResolve(e: React.FormEvent) {
    e.preventDefault();
    if (!resolutionNote.trim()) {
      alert("Please enter a brief action taken / resolution summary.");
      return;
    }

    setSaving(true);

    try {
      // 1. If project ID is available, apply database updates to families
      if (directive.projectId) {
        if (autoVerifyFamilies) {
          await supabase
            .from("families")
            .update({ verification_status: "Verified" })
            .eq("project_id", directive.projectId)
            .eq("verification_status", "Pending");
        }

        if (autoDisburseComp) {
          await supabase
            .from("families")
            .update({ payment_status: "Paid", possession_status: "Vacated" })
            .eq("project_id", directive.projectId)
            .eq("payment_status", "Pending");
        }

        if (autoResolveObjections) {
          await supabase
            .from("families")
            .update({ objection_status: "Resolved" })
            .eq("project_id", directive.projectId)
            .eq("objection_status", "Filed");
        }
      }

      // 2. Update directive status
      const updated: DirectiveItem = {
        ...directive,
        status: "RESOLVED",
      };

      // Save into localStorage
      const all: DirectiveItem[] = JSON.parse(localStorage.getItem("collector_directives") || "[]");
      const newAll = all.map((d) => (d.id === directive.id ? { ...updated, resolutionNote, resolvedBy: officerRole, resolvedAt: new Date().toISOString() } : d));
      localStorage.setItem("collector_directives", JSON.stringify(newAll));

      setSuccessMessage("Directive successfully executed and resolved! Database metrics updated.");
      setTimeout(() => {
        onResolved(updated);
        onClose();
      }, 1000);
    } catch (err: any) {
      alert(`Resolution error: ${err.message}`);
      setSaving(false);
    }
  }

  return (
    <div className="fixed inset-0 bg-black/80 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div className="bg-slate-900 border border-emerald-500/40 max-w-lg w-full rounded-2xl p-6 shadow-2xl space-y-4 animate-scale-in font-sans text-slate-100">
        <div className="flex justify-between items-start border-b border-slate-800 pb-3">
          <div>
            <span className="text-[10px] font-mono font-bold text-emerald-400 uppercase tracking-widest">
              Action Order Resolution · {officerRole}
            </span>
            <h2 className="text-lg font-black text-white mt-0.5">Execute &amp; Resolve Directive</h2>
          </div>
          <button
            onClick={onClose}
            className="text-slate-400 hover:text-white text-base font-mono transition"
          >
            ✕
          </button>
        </div>

        {/* Directive details */}
        <div className="bg-slate-950 p-3.5 rounded-xl border border-slate-800 text-xs space-y-1 font-mono">
          <p className="text-amber-300 font-bold text-sm">{directive.title}</p>
          <p className="text-slate-300 font-sans">{directive.description}</p>
          <p className="text-[10px] text-slate-400 mt-1">
            Target Corridor: <b>{directive.projectName}</b> · SLA: <b>{directive.targetDays} Days</b>
          </p>
        </div>

        <form onSubmit={handleResolve} className="space-y-4 text-xs font-sans">
          <div>
            <label className="block text-slate-300 font-semibold mb-1">
              Field Action Summary / Resolution Notes:
            </label>
            <textarea
              required
              rows={3}
              placeholder="e.g. Conducted village conciliation camp at Gram Panchayat. 28 farmer compensation vouchers verified & cleared for disbursement..."
              value={resolutionNote}
              onChange={(e) => setResolutionNote(e.target.value)}
              className="w-full bg-slate-950 border border-slate-800 rounded-xl p-3 text-xs text-white placeholder:text-slate-500 focus:outline-none focus:ring-2 focus:ring-emerald-500 font-sans"
            />
          </div>

          <div className="bg-slate-950 p-3 rounded-xl border border-slate-800 space-y-2">
            <p className="text-[11px] font-bold text-slate-300 font-mono uppercase">
              Automated Database Mitigation Actions:
            </p>
            <label className="flex items-center gap-2 text-slate-300 cursor-pointer">
              <input
                type="checkbox"
                checked={autoVerifyFamilies}
                onChange={(e) => setAutoVerifyFamilies(e.target.checked)}
                className="rounded border-slate-700 text-emerald-600 focus:ring-0"
              />
              <span>Verify all pending survey records for this corridor</span>
            </label>
            <label className="flex items-center gap-2 text-slate-300 cursor-pointer">
              <input
                type="checkbox"
                checked={autoResolveObjections}
                onChange={(e) => setAutoResolveObjections(e.target.checked)}
                className="rounded border-slate-700 text-emerald-600 focus:ring-0"
              />
              <span>Mark active land valuation objections as Resolved</span>
            </label>
            <label className="flex items-center gap-2 text-slate-300 cursor-pointer">
              <input
                type="checkbox"
                checked={autoDisburseComp}
                onChange={(e) => setAutoDisburseComp(e.target.checked)}
                className="rounded border-slate-700 text-emerald-600 focus:ring-0"
              />
              <span>Batch mark pending compensation as Paid &amp; Land Vacated</span>
            </label>
          </div>

          {successMessage && (
            <div className="bg-emerald-950/40 border border-emerald-600/50 p-3 rounded-xl text-emerald-300 text-xs font-semibold flex items-center gap-2">
              <span>✓</span>
              <span>{successMessage}</span>
            </div>
          )}

          <div className="flex gap-2 pt-2">
            <button
              type="button"
              onClick={onClose}
              className="bg-slate-800 hover:bg-slate-700 text-slate-300 px-4 py-2.5 rounded-xl font-bold transition flex-1"
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={saving}
              className="bg-emerald-600 hover:bg-emerald-500 text-white px-5 py-2.5 rounded-xl font-bold transition flex-1 shadow-lg shadow-emerald-600/25 disabled:opacity-50"
            >
              {saving ? "Updating Database..." : "✓ Submit Resolution"}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
