"use client";

import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import { supabase } from "@/lib/supabaseClient";

interface Family {
  id: string;
  family_name: string;
  land_area_owned: number | null;
  compensation_amount: number | null;
  payment_status: string;
  objection_status: string;
  court_case_status: string;
  court_case_filed_date: string | null;
  possession_status: string;
  verification_status: "Pending" | "Verified" | "Rejected";
}

export default function FamiliesPage() {
  const params = useParams();
  const projectId = params.id as string;

  const [families, setFamilies] = useState<Family[]>([]);
  const [form, setForm] = useState({
    family_name: "",
    land_area_owned: "",
    compensation_amount: "",
    payment_status: "Not Calculated",
    objection_status: "None",
    court_case_status: "None",
    court_case_filed_date: "",
    possession_status: "Occupied",
  });
  const [saving, setSaving] = useState(false);

  async function loadFamilies() {
    const { data } = await supabase
      .from("families")
      .select("*")
      .eq("project_id", projectId)
      .order("created_at", { ascending: false });
    if (data) setFamilies(data as Family[]);
  }

  useEffect(() => {
    if (projectId) loadFamilies();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [projectId]);

  function update<K extends keyof typeof form>(key: K, value: string) {
    setForm((f) => ({ ...f, [key]: value }));
  }

  async function handleAdd(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);

    const { data: userData } = await supabase.auth.getUser();

    // Verification status defaults to 'Pending' (Audited by LAO)
    await supabase.from("families").insert({
      project_id: projectId,
      family_name: form.family_name,
      land_area_owned: form.land_area_owned ? Number(form.land_area_owned) : null,
      compensation_amount: form.compensation_amount
        ? Number(form.compensation_amount)
        : null,
      payment_status: form.payment_status,
      objection_status: form.objection_status,
      court_case_status: form.court_case_status,
      court_case_filed_date: form.court_case_status === "Active" && form.court_case_filed_date ? form.court_case_filed_date : null,
      possession_status: form.possession_status,
      verification_status: "Pending",
      entered_by: userData.user?.id,
    });

    setForm({
      family_name: "",
      land_area_owned: "",
      compensation_amount: "",
      payment_status: "Not Calculated",
      objection_status: "None",
      court_case_status: "None",
      court_case_filed_date: "",
      possession_status: "Occupied",
    });
    setSaving(false);
    loadFamilies();
  }

  return (
    <main className="min-h-screen bg-slate-50 py-10 px-6">
      <div className="max-w-3xl mx-auto">
      <div className="page-header">
        <div>
          <p className="text-xs text-slate-400 mb-0.5">Patwari · Field Data Entry</p>
          <h1 className="text-2xl font-bold text-slate-800">Family-wise Beneficiary Records</h1>
        </div>
        <a href="/dashboard/patwari" className="btn-secondary text-xs px-3 py-1.5 rounded-lg">
          ← Back
        </a>
      </div>

      <form
        onSubmit={handleAdd}
        className="card grid grid-cols-2 gap-4 p-6 mb-8"
      >
        <div className="col-span-2">
          <label className="block text-xs font-semibold text-slate-500 mb-1.5">Beneficiary Name / Titleholder</label>
          <input
            required
            placeholder="e.g. Ramesh Kumar Patel"
            className="input"
            value={form.family_name}
            onChange={(e) => update("family_name", e.target.value)}
          />
        </div>
        
        <div>
          <label className="block text-xs font-semibold text-slate-500 mb-1.5">Land Area (Ha)</label>
          <input
            type="number"
            step="any"
            placeholder="e.g. 1.4"
            className="input"
            value={form.land_area_owned}
            onChange={(e) => update("land_area_owned", e.target.value)}
          />
        </div>

        <div>
          <label className="block text-xs font-semibold text-slate-500 mb-1.5">Compensation Amount (₹)</label>
          <input
            type="number"
            placeholder="e.g. 450000"
            className="input"
            value={form.compensation_amount}
            onChange={(e) => update("compensation_amount", e.target.value)}
          />
        </div>

        <div>
          <label className="block text-xs font-semibold text-slate-500 mb-1.5">Payment Status</label>
          <select className="input" value={form.payment_status} onChange={(e) => update("payment_status", e.target.value)}>
            <option>Not Calculated</option>
            <option>Pending</option>
            <option>Paid</option>
          </select>
        </div>

        <div>
          <label className="block text-xs font-semibold text-slate-500 mb-1.5">Objection Status</label>
          <select className="input" value={form.objection_status} onChange={(e) => update("objection_status", e.target.value)}>
            <option>None</option>
            <option>Filed</option>
            <option>Resolved</option>
          </select>
        </div>

        <div>
          <label className="block text-xs font-semibold text-slate-500 mb-1.5">Litigation Status</label>
          <select className="input" value={form.court_case_status} onChange={(e) => update("court_case_status", e.target.value)}>
            <option>None</option>
            <option>Active</option>
            <option>Resolved</option>
          </select>
        </div>

        <div>
          <label className="block text-xs font-semibold text-slate-500 mb-1.5">Possession Status</label>
          <select className="input" value={form.possession_status} onChange={(e) => update("possession_status", e.target.value)}>
            <option>Occupied</option>
            <option>Vacated</option>
            <option>Refusing</option>
          </select>
        </div>

        {form.court_case_status === "Active" && (
          <div className="col-span-2 bg-amber-50 p-4 rounded-xl border border-amber-200 animate-fade-in">
            <label className="block text-xs font-semibold text-amber-700 mb-1.5">⚖ Court Case Filing Date</label>
            <input
              required
              type="date"
              className="input"
              value={form.court_case_filed_date}
              onChange={(e) => update("court_case_filed_date", e.target.value)}
            />
            <p className="text-2xs text-amber-600 mt-1.5">⚡ This filing date drives the litigation velocity signal in the ML risk score.</p>
          </div>
        )}

        <button type="submit" disabled={saving} className="btn-primary col-span-2 mt-2">
          {saving ? (
            <span className="flex items-center justify-center gap-2">
              <span className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
              Adding...
            </span>
          ) : "+ Add Family Record (Awaiting LAO Approval)"}
        </button>
      </form>

      <h2 className="section-title">
        {families.length} Beneficiar{families.length === 1 ? "y" : "ies"} Recorded
      </h2>
      <div className="space-y-3">
        {families.map((f) => (
          <div
            key={f.id}
            className="card px-5 py-4 text-sm flex justify-between items-start gap-4 hover:shadow-md transition-shadow animate-fade-in"
          >
            <div className="flex-1 min-w-0">
              <span className="font-semibold text-slate-800 block">{f.family_name}</span>
              <div className="flex flex-wrap gap-2 mt-2">
                <span className={`badge ${
                  f.payment_status === "Paid" ? "badge-verified" : f.payment_status === "Pending" ? "badge-pending" : "bg-slate-100 text-slate-500 border border-slate-200"
                }`}>{f.payment_status}</span>
                {f.court_case_status === "Active" && (
                  <span className="badge badge-critical">⚖ Active Case{f.court_case_filed_date ? ` · Filed ${new Date(f.court_case_filed_date).toLocaleDateString("en-IN")}` : ""}</span>
                )}
                {f.possession_status === "Refusing" && (
                  <span className="badge badge-high">🚫 Refusing</span>
                )}
                {f.possession_status === "Vacated" && (
                  <span className="badge badge-low">✓ Vacated</span>
                )}
              </div>
            </div>
            
            <div className="text-right shrink-0">
              <span className={`badge ${
                f.verification_status === "Verified" ? "badge-verified"
                : f.verification_status === "Rejected" ? "badge-rejected"
                : "badge-pending"
              }`}>
                {f.verification_status}
              </span>
              <p className="text-2xs text-slate-400 mt-1.5">
                {f.verification_status === "Pending" ? "Awaiting LAO Audit" : "Workflow Complete"}
              </p>
            </div>
          </div>
        ))}
      </div>
      </div>
    </main>
  );
}
