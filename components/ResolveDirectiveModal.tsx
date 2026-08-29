"use client";

import React, { useState } from "react";
import { supabase } from "@/lib/supabaseClient";
import { DirectiveItem } from "./DirectivesModal";

interface ResolveDirectiveModalProps {
  directive: DirectiveItem;
  officerRole: "lao" | "patwari" | "collector";
  onClose: () => void;
  onResolved: (resolvedDirective: DirectiveItem) => void;
}

export default function ResolveDirectiveModal({
  directive,
  officerRole,
  onClose,
  onResolved,
}: ResolveDirectiveModalProps) {
  const [resolutionProof, setResolutionProof] = useState("");
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleResolve() {
    if (!resolutionProof.trim()) {
      setError("Please provide a compliance summary or evidence notes before closing.");
      return;
    }

    setSaving(true);
    setError(null);

    try {
      const { data: userData } = await supabase.auth.getUser();

      // Update Supabase directives table
      const { error: updateError } = await supabase
        .from("directives")
        .update({
          status: "RESOLVED",
          resolution_proof: resolutionProof.trim(),
          resolved_at: new Date().toISOString(),
          resolved_by: userData.user?.id || null,
        })
        .eq("id", directive.id);

      if (updateError) {
        console.warn("Supabase update notice:", updateError.message);
      }

      const updated: DirectiveItem = {
        ...directive,
        status: "RESOLVED",
      };

      onResolved(updated);
      onClose();
    } catch (err: any) {
      setError(err?.message || "Failed to mark directive as resolved.");
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="fixed inset-0 z-50 bg-black/75 backdrop-blur-sm flex items-center justify-center p-4">
      <div className="bg-slate-900 border border-emerald-500/30 text-slate-100 rounded-2xl max-w-lg w-full p-6 shadow-2xl space-y-5 animate-scale-in">
        <div className="flex justify-between items-start border-b border-slate-800 pb-3">
          <div>
            <div className="flex items-center gap-2">
              <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse" />
              <span className="text-[10px] font-mono font-bold text-emerald-400 uppercase tracking-widest">
                Action Resolution &amp; Compliance Sign-Off
              </span>
            </div>
            <h3 className="text-lg font-black text-white mt-1">{directive.title}</h3>
            <p className="text-xs text-slate-400 font-mono">Assigned to: {directive.assignedTo} · {directive.targetDays}d SLA</p>
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

        <div className="space-y-3 text-xs font-mono">
          <div className="bg-slate-950 p-3.5 rounded-xl border border-slate-800">
            <p className="text-[10px] font-bold text-slate-400 uppercase">Directive Mandate:</p>
            <p className="text-slate-200 mt-1">{directive.description}</p>
          </div>

          <div>
            <label className="block text-slate-300 font-bold mb-1.5">Compliance Actions &amp; Resolution Proof:</label>
            <textarea
              rows={4}
              required
              placeholder="e.g. Completed special camp in Godhani on 28th Aug. Disbursed ₹42 Lakhs across 8 families. Zero pending title claims."
              value={resolutionProof}
              onChange={(e) => setResolutionProof(e.target.value)}
              className="w-full bg-slate-950 border border-slate-800 rounded-xl p-2.5 text-white placeholder:text-slate-600 focus:outline-none focus:ring-1 focus:ring-emerald-500"
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
            onClick={handleResolve}
            className="px-5 py-2 bg-emerald-600 hover:bg-emerald-500 text-white text-xs rounded-xl font-bold shadow-lg shadow-emerald-600/25 transition flex items-center gap-2 disabled:opacity-50"
          >
            {saving ? "Signing Off..." : "✓ Submit Resolution Proof"}
          </button>
        </div>
      </div>
    </div>
  );
}
