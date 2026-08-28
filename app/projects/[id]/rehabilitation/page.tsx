"use client";

import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import Link from "next/link";
import { supabase } from "@/lib/supabaseClient";
import DashboardLayout from "@/components/DashboardLayout";

export default function RehabilitationPage() {
  const params = useParams();
  const projectId = params.id as string;

  const [projectName, setProjectName] = useState("");
  const [rowId, setRowId] = useState<string | null>(null);
  const [form, setForm] = useState({
    colonies_planned: "",
    colonies_built: "",
    families_shifted: "",
  });
  const [saving, setSaving] = useState(false);
  const [saved, setSaved] = useState(false);

  useEffect(() => {
    async function load() {
      // Fetch project name
      const { data: proj } = await supabase
        .from("projects")
        .select("project_name, est_families_affected")
        .eq("id", projectId)
        .single();
      if (proj) setProjectName(proj.project_name);

      // Fetch existing R&R row
      const { data } = await supabase
        .from("rehabilitation_status")
        .select("*")
        .eq("project_id", projectId)
        .maybeSingle();

      if (data) {
        setRowId(data.id);
        setForm({
          colonies_planned: String(data.colonies_planned ?? ""),
          colonies_built:   String(data.colonies_built ?? ""),
          families_shifted: String(data.families_shifted ?? ""),
        });
      }
    }
    if (projectId) load();
  }, [projectId]);

  function update<K extends keyof typeof form>(key: K, value: string) {
    setForm((f) => ({ ...f, [key]: value }));
    setSaved(false);
  }

  async function handleSave(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);

    const payload = {
      project_id: projectId,
      colonies_planned: Number(form.colonies_planned || 0),
      colonies_built:   Number(form.colonies_built || 0),
      families_shifted: Number(form.families_shifted || 0),
      updated_at: new Date().toISOString(),
    };

    if (rowId) {
      await supabase.from("rehabilitation_status").update(payload).eq("id", rowId);
    } else {
      const { data } = await supabase
        .from("rehabilitation_status")
        .insert(payload)
        .select()
        .single();
      if (data) setRowId(data.id);
    }

    setSaving(false);
    setSaved(true);
  }

  const coloniesPlanned = Number(form.colonies_planned) || 0;
  const coloniesBuilt   = Number(form.colonies_built)   || 0;
  const coloniesPct     = coloniesPlanned > 0 ? Math.round((coloniesBuilt / coloniesPlanned) * 100) : 0;

  return (
    <DashboardLayout>
      <main className="min-h-screen bg-slate-950 py-10 px-6 font-sans text-slate-100">
        <div className="max-w-xl mx-auto space-y-6">
          <div className="flex items-center justify-between">
            <div>
              <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full border border-teal-500/30 bg-teal-500/10 text-teal-300 text-xs font-semibold mb-2 font-mono">
                <span>🏘️</span> RFCTLARR 2013 · Second Schedule R&R
              </div>
              <h1 className="text-2xl font-black text-white">Rehabilitation & Resettlement</h1>
              {projectName && <p className="text-xs text-slate-400 mt-1 font-medium">{projectName}</p>}
            </div>
            <Link href="/dashboard/patwari" className="text-xs font-bold text-slate-400 hover:text-white bg-slate-900 border border-slate-800 px-3.5 py-2 rounded-xl transition">
              ← Return
            </Link>
          </div>

          {/* Live Progress Preview */}
          {coloniesPlanned > 0 && (
            <div className="bg-slate-900 border border-slate-800 rounded-2xl p-5 shadow-xl animate-fade-in space-y-3">
              <div className="flex items-center justify-between">
                <span className="text-xs font-mono font-bold text-slate-400 uppercase tracking-wider">
                  Colony Construction Milestone
                </span>
                <span className={`text-xs font-bold font-mono ${coloniesPct < 40 ? "text-red-400" : coloniesPct < 70 ? "text-amber-400" : "text-emerald-400"}`}>
                  {coloniesPct}% Completed
                </span>
              </div>
              <div className="flex items-end justify-between">
                <p className="text-2xl font-black text-white">
                  {coloniesBuilt} <span className="text-sm text-slate-500 font-semibold font-mono">/ {coloniesPlanned} units</span>
                </p>
              </div>
              <div className="w-full h-2 bg-slate-950 rounded-full overflow-hidden border border-slate-800">
                <div
                  className={`h-full rounded-full transition-all duration-700 ${
                    coloniesPct < 40 ? "bg-red-500" : coloniesPct < 70 ? "bg-amber-500" : "bg-emerald-500"
                  }`}
                  style={{ width: `${coloniesPct}%` }}
                />
              </div>
              <p className="text-[11px] text-slate-400 font-mono">
                {coloniesPct < 40
                  ? "⚠ R&R lag is a primary delay driver. Priority construction needed to avoid physical possession blockage."
                  : coloniesPct < 70
                  ? "✓ Resettlement construction is progressing steadily."
                  : "✓ R&R infrastructure complete. Possession handover clearance ready."}
              </p>
            </div>
          )}

          <form
            onSubmit={handleSave}
            className="bg-slate-900 border border-slate-800 rounded-2xl p-6 space-y-5 shadow-xl"
          >
            <div>
              <label className="block text-xs font-semibold text-slate-300 mb-1.5 font-mono">
                Resettlement Colonies Planned <span className="text-slate-500 font-normal">(Total Units)</span>
              </label>
              <input
                type="number"
                min="0"
                className="w-full bg-slate-950 border border-slate-800 rounded-xl px-4 py-2.5 text-xs text-white placeholder:text-slate-600 focus:outline-none focus:ring-2 focus:ring-teal-500 transition"
                value={form.colonies_planned}
                onChange={(e) => update("colonies_planned", e.target.value)}
                placeholder="e.g. 120"
                required
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-300 mb-1.5 font-mono">
                Colonies Constructed & Civil Works Verified
              </label>
              <input
                type="number"
                min="0"
                className="w-full bg-slate-950 border border-slate-800 rounded-xl px-4 py-2.5 text-xs text-white placeholder:text-slate-600 focus:outline-none focus:ring-2 focus:ring-teal-500 transition"
                value={form.colonies_built}
                onChange={(e) => update("colonies_built", e.target.value)}
                placeholder="e.g. 85"
                required
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-300 mb-1.5 font-mono">
                Families Successfully Relocated & Resettled
              </label>
              <input
                type="number"
                min="0"
                className="w-full bg-slate-950 border border-slate-800 rounded-xl px-4 py-2.5 text-xs text-white placeholder:text-slate-600 focus:outline-none focus:ring-2 focus:ring-teal-500 transition"
                value={form.families_shifted}
                onChange={(e) => update("families_shifted", e.target.value)}
                placeholder="e.g. 70"
                required
              />
            </div>

            {saved && (
              <div className="p-3 rounded-xl bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 text-xs font-mono">
                ✓ R&R field records saved to Supabase and synced with multi-model survival metrics!
              </div>
            )}

            <button
              type="submit"
              disabled={saving}
              className="w-full bg-teal-600 hover:bg-teal-500 text-white py-3 rounded-xl text-xs font-bold transition shadow-lg shadow-teal-600/20 active:scale-95 disabled:opacity-50 font-mono"
            >
              {saving ? "Updating Statutory Ledger..." : "Save R&R Field Record →"}
            </button>
          </form>
        </div>
      </main>
    </DashboardLayout>
  );
}
