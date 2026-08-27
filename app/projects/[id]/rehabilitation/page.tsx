"use client";

import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import { supabase } from "@/lib/supabaseClient";

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
    <main className="min-h-screen bg-slate-50 py-10 px-6">
      <div className="max-w-xl mx-auto">
        <div className="page-header">
          <div>
            <p className="text-xs text-slate-400 mb-0.5">Rehabilitation &amp; Resettlement</p>
            <h1 className="text-2xl font-bold text-slate-800">R&amp;R Progress Entry</h1>
            {projectName && <p className="text-sm text-slate-500 mt-0.5">{projectName}</p>}
          </div>
          <a href="/dashboard/patwari" className="btn-secondary text-xs px-3 py-1.5 rounded-lg">
            ← Back
          </a>
        </div>

        {/* Live progress preview */}
        {coloniesPlanned > 0 && (
          <div className="card p-5 mb-6 animate-fade-in">
            <p className="stat-label">Colony Construction Progress</p>
            <div className="flex items-end justify-between mt-2 mb-3">
              <p className="stat-value">{coloniesBuilt} <span className="text-lg text-slate-400 font-semibold">/ {coloniesPlanned}</span></p>
              <span className={`text-sm font-bold ${coloniesPct < 40 ? "text-red-500" : coloniesPct < 70 ? "text-amber-500" : "text-emerald-600"}`}>
                {coloniesPct}%
              </span>
            </div>
            <div className="w-full h-2 bg-slate-100 rounded-full overflow-hidden">
              <div
                className={`h-full rounded-full transition-all duration-700 ${
                  coloniesPct < 40 ? "bg-red-500" : coloniesPct < 70 ? "bg-amber-500" : "bg-emerald-500"
                }`}
                style={{ width: `${coloniesPct}%` }}
              />
            </div>
            <p className="text-xs text-slate-400 mt-2">
              {coloniesPct < 40
                ? "⚠ R&R lag is a MODERATE-HIGH risk factor. Accelerate colony construction."
                : coloniesPct < 70
                ? "Progress is on track. Maintain current pace."
                : "✓ Good R&R progress. Risk contribution is low."}
            </p>
          </div>
        )}

        <form
          onSubmit={handleSave}
          className="card p-6 space-y-5"
        >
          <div>
            <label className="block text-sm font-semibold text-slate-700 mb-1.5">
              Colonies Planned <span className="text-slate-400 font-normal">(total resettlement units)</span>
            </label>
            <input
              type="number"
              min="0"
              className="input"
              value={form.colonies_planned}
              onChange={(e) => update("colonies_planned", e.target.value)}
              placeholder="e.g. 5"
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-slate-700 mb-1.5">
              Colonies Built <span className="text-slate-400 font-normal">(ready for occupation)</span>
            </label>
            <input
              type="number"
              min="0"
              className="input"
              value={form.colonies_built}
              onChange={(e) => update("colonies_built", e.target.value)}
              placeholder="e.g. 2"
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-slate-700 mb-1.5">
              Families Shifted <span className="text-slate-400 font-normal">(actual physical displacement)</span>
            </label>
            <input
              type="number"
              min="0"
              className="input"
              value={form.families_shifted}
              onChange={(e) => update("families_shifted", e.target.value)}
              placeholder="e.g. 89"
            />
          </div>

          <button
            type="submit"
            disabled={saving}
            className="btn-primary w-full"
          >
            {saving ? (
              <span className="flex items-center justify-center gap-2">
                <span className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                Saving...
              </span>
            ) : "Save R&R Progress"}
          </button>

          {saved && (
            <div className="rounded-lg bg-emerald-50 border border-emerald-200 text-emerald-700 text-sm p-3 text-center animate-fade-in">
              ✓ Saved — Collector's dashboard will reflect this on next load.
            </div>
          )}
        </form>

        <p className="text-xs text-slate-400 text-center mt-4">
          R&amp;R progress contributes <strong>7%</strong> to the project risk score (PRAGATI-informed weighting).
        </p>
      </div>
    </main>
  );
}
