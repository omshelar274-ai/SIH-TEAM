"use client";

import { useEffect, useState } from "react";
import { useParams, useRouter } from "next/navigation";
import Link from "next/link";
import { supabase } from "@/lib/supabaseClient";
import DashboardLayout from "@/components/DashboardLayout";
import RoleGuard from "@/components/RoleGuard";

interface FamilyRecord {
  id: string;
  family_name: string;
  land_area_owned: number;
  compensation_amount: number;
  payment_status: string;
  court_case_status: string;
  court_case_filed_date: string | null;
  possession_status: string;
  verification_status: "Pending" | "Verified" | "Rejected";
}

export default function VerifyProjectDataPage() {
  const params = useParams();
  const router = useRouter();
  const projectId = params.id as string;

  const [projectName, setProjectName] = useState("");
  const [families, setFamilies] = useState<FamilyRecord[]>([]);
  const [loading, setLoading] = useState(true);
  const [updatingId, setUpdatingId] = useState<string | null>(null);
  const [district, setDistrict] = useState("");

  useEffect(() => {
    async function load() {
      // 1. Fetch project name
      const { data: project, error: pErr } = await supabase
        .from("projects")
        .select("project_name, district")
        .eq("id", projectId)
        .single();

      if (pErr || !project) {
        alert("Project not found");
        router.push("/dashboard/lao");
        return;
      }
      setProjectName(project.project_name);
      setDistrict(project.district);

      // 2. Fetch family rows
      const { data: familyData, error: fErr } = await supabase
        .from("families")
        .select("*")
        .eq("project_id", projectId)
        .order("created_at", { ascending: true });

      if (!fErr && familyData && familyData.length > 0) {
        setFamilies(familyData as FamilyRecord[]);
      } else {
        // Resilient API fallback
        try {
          const res = await fetch(`/api/study-data?district=${encodeURIComponent(project.district || "Nagpur")}`);
          if (res.ok) {
            const { families: allFams } = await res.json();
            const matching = (allFams || []).filter((f: any) => f.project_id === projectId);
            if (matching.length > 0) {
              setFamilies(matching);
            }
          }
        } catch {}
      }
      setLoading(false);
    }
    if (projectId) load();
  }, [projectId, router]);

  async function updateStatus(
    id: string,
    status: "Verified" | "Rejected" | "Pending"
  ) {
    setUpdatingId(id);
    try {
      // 1. Try server API route first
      const apiRes = await fetch("/api/verify-family", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ familyId: id, status }),
      });

      if (apiRes.ok) {
        setFamilies((prev) =>
          prev.map((f) => (f.id === id ? { ...f, verification_status: status } : f))
        );
        return;
      }

      // 2. Direct client fallback
      const { error } = await supabase
        .from("families")
        .update({ verification_status: status })
        .eq("id", id);

      if (error) {
        alert("Error updating status: " + error.message);
      } else {
        setFamilies((prev) =>
          prev.map((f) => (f.id === id ? { ...f, verification_status: status } : f))
        );
      }
    } finally {
      setUpdatingId(null);
    }
  }

  async function verifyAllPending() {
    const pendingIds = families
      .filter((f) => f.verification_status === "Pending")
      .map((f) => f.id);
    if (pendingIds.length === 0) return;

    setUpdatingId("bulk");
    try {
      const apiRes = await fetch("/api/verify-family", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ familyIds: pendingIds, status: "Verified" }),
      });

      if (apiRes.ok) {
        setFamilies((prev) =>
          prev.map((f) =>
            pendingIds.includes(f.id) ? { ...f, verification_status: "Verified" } : f
          )
        );
        return;
      }

      await supabase
        .from("families")
        .update({ verification_status: "Verified" })
        .in("id", pendingIds);
      setFamilies((prev) =>
        prev.map((f) =>
          pendingIds.includes(f.id) ? { ...f, verification_status: "Verified" } : f
        )
      );
    } finally {
      setUpdatingId(null);
    }
  }

  const pending = families.filter((f) => f.verification_status === "Pending");
  const verified = families.filter((f) => f.verification_status === "Verified");
  const rejected = families.filter((f) => f.verification_status === "Rejected");

  return (
    <RoleGuard allowedRoles={["lao"]}>
      <DashboardLayout>
        <main className="min-h-screen py-8 px-6 font-sans text-slate-100 max-w-6xl mx-auto space-y-6">
          <div className="flex items-center gap-3">
            <Link
              href="/dashboard/lao"
              className="text-xs font-mono font-bold text-slate-400 hover:text-white bg-slate-900 border border-slate-800 px-3.5 py-2 rounded-xl transition"
            >
              ← Back to LAO Portal
            </Link>
          </div>

          <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-slate-900 p-6 rounded-2xl border border-slate-800 shadow-xl">
            <div>
              <span className="text-[10px] font-mono font-bold px-2.5 py-0.5 rounded-full bg-blue-500/20 text-blue-300 border border-blue-500/30 mb-2 inline-block">
                District: {district || "Nagpur"} · LAO Statutory Audit Queue
              </span>
              <h1 className="text-2xl font-black text-white">{projectName}</h1>
              <p className="text-xs text-slate-400 mt-1">
                Verify family land survey numbers, R&amp;R displacement declarations, and litigation parameters.
              </p>
            </div>

            {pending.length > 0 && (
              <button
                onClick={verifyAllPending}
                disabled={updatingId !== null}
                className="bg-blue-600 hover:bg-blue-500 text-white text-xs font-bold rounded-xl px-4 py-2.5 transition shadow-lg shadow-blue-600/20 disabled:opacity-50"
              >
                {updatingId === "bulk" ? "Processing..." : `✓ Bulk Approve ${pending.length} Pending`}
              </button>
            )}
          </div>

          {loading ? (
            <div className="text-center py-20 bg-slate-900 rounded-2xl border border-slate-800">
              <div className="w-8 h-8 border-4 border-blue-500 border-t-transparent rounded-full animate-spin mx-auto" />
              <p className="text-xs font-mono text-slate-400 mt-4">Loading family registries...</p>
            </div>
          ) : families.length === 0 ? (
            <div className="text-center py-16 bg-slate-900 rounded-2xl border border-slate-800 p-8">
              <p className="font-bold text-white">No family data entered yet</p>
              <p className="text-xs text-slate-400 mt-1">
                The Patwari has not submitted any family records for this project.
              </p>
            </div>
          ) : (
            <div className="space-y-8">
              {/* Pending Audit List */}
              {pending.length > 0 && (
                <div>
                  <h2 className="text-sm font-bold font-mono text-amber-400 mb-3 flex items-center gap-2">
                    <span className="w-2.5 h-2.5 rounded-full bg-amber-400 animate-pulse" />
                    Awaiting Verification ({pending.length})
                  </h2>
                  <div className="bg-slate-900 rounded-2xl border border-slate-800 shadow-xl overflow-hidden">
                    <div className="overflow-x-auto">
                      <table className="w-full text-left border-collapse text-xs font-mono">
                        <thead>
                          <tr className="bg-slate-950 border-b border-slate-800 text-slate-400 font-bold uppercase text-[10px]">
                            <th className="px-5 py-3">Beneficiary / Family</th>
                            <th className="px-5 py-3">Land Owned (Ha)</th>
                            <th className="px-5 py-3">Compensation</th>
                            <th className="px-5 py-3">Court Case</th>
                            <th className="px-5 py-3">Possession</th>
                            <th className="px-5 py-3 text-right">Actions</th>
                          </tr>
                        </thead>
                        <tbody className="divide-y divide-slate-800/60">
                          {pending.map((f) => (
                            <tr key={f.id} className="hover:bg-slate-800/40 transition">
                              <td className="px-5 py-3.5 font-bold text-white">{f.family_name}</td>
                              <td className="px-5 py-3.5 text-slate-300">{f.land_area_owned || "0"} Ha</td>
                              <td className="px-5 py-3.5">
                                <p className="text-white font-bold">₹{f.compensation_amount?.toLocaleString()}</p>
                                <span className={`text-[9px] px-2 py-0.5 rounded-full font-bold ${
                                  f.payment_status === "Paid" ? "bg-emerald-500/20 text-emerald-300" : "bg-amber-500/20 text-amber-300"
                                }`}>
                                  {f.payment_status}
                                </span>
                              </td>
                              <td className="px-5 py-3.5">
                                <span className={`text-[9px] font-bold px-2 py-0.5 rounded-full ${
                                  f.court_case_status === "Active" ? "bg-red-500/20 text-red-300" : "bg-slate-800 text-slate-400"
                                }`}>
                                  {f.court_case_status}
                                </span>
                                {f.court_case_filed_date && (
                                  <p className="text-[9px] text-slate-500 mt-1">
                                    Filed: {new Date(f.court_case_filed_date).toLocaleDateString()}
                                  </p>
                                )}
                              </td>
                              <td className="px-5 py-3.5 text-slate-300">{f.possession_status}</td>
                              <td className="px-5 py-3.5 text-right">
                                <div className="flex justify-end gap-2">
                                  <button
                                    onClick={() => updateStatus(f.id, "Verified")}
                                    disabled={updatingId !== null}
                                    className="text-[10px] font-bold bg-emerald-600/20 hover:bg-emerald-600/30 text-emerald-300 border border-emerald-500/30 px-3 py-1 rounded-lg transition disabled:opacity-50"
                                  >
                                    Approve
                                  </button>
                                  <button
                                    onClick={() => updateStatus(f.id, "Rejected")}
                                    disabled={updatingId !== null}
                                    className="text-[10px] font-bold bg-rose-600/20 hover:bg-rose-600/30 text-rose-300 border border-rose-500/30 px-3 py-1 rounded-lg transition disabled:opacity-50"
                                  >
                                    Reject
                                  </button>
                                </div>
                              </td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              )}

              {/* Verified & Archive Lists */}
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                <div>
                  <h2 className="text-xs font-mono font-bold text-slate-400 uppercase tracking-wider mb-3">
                    Verified Records ({verified.length})
                  </h2>
                  <div className="bg-slate-900 rounded-2xl border border-slate-800 shadow-xl p-4 divide-y divide-slate-800/60 max-h-[400px] overflow-y-auto">
                    {verified.length === 0 ? (
                      <p className="text-xs text-slate-500 py-4 text-center font-mono">No verified entries</p>
                    ) : (
                      verified.map((f) => (
                        <div key={f.id} className="py-3 flex justify-between items-center text-xs font-mono">
                          <div>
                            <p className="font-bold text-white">{f.family_name}</p>
                            <p className="text-[10px] text-slate-400">₹{f.compensation_amount?.toLocaleString()} · {f.land_area_owned} Ha</p>
                          </div>
                          <div className="flex items-center gap-3">
                            <span className="text-[10px] font-bold text-emerald-300 bg-emerald-500/20 px-2 py-0.5 rounded-full border border-emerald-500/30">
                              ✓ Verified
                            </span>
                            <button
                              onClick={() => updateStatus(f.id, "Rejected")}
                              disabled={updatingId !== null}
                              className="text-[10px] text-slate-500 hover:text-rose-400 transition underline"
                            >
                              Revoke
                            </button>
                          </div>
                        </div>
                      ))
                    )}
                  </div>
                </div>

                <div>
                  <h2 className="text-xs font-mono font-bold text-slate-400 uppercase tracking-wider mb-3">
                    Rejected Records ({rejected.length})
                  </h2>
                  <div className="bg-slate-900 rounded-2xl border border-slate-800 shadow-xl p-4 divide-y divide-slate-800/60 max-h-[400px] overflow-y-auto">
                    {rejected.length === 0 ? (
                      <p className="text-xs text-slate-500 py-4 text-center font-mono">No rejected entries</p>
                    ) : (
                      rejected.map((f) => (
                        <div key={f.id} className="py-3 flex justify-between items-center text-xs font-mono">
                          <div>
                            <p className="font-bold text-slate-400 line-through">{f.family_name}</p>
                            <p className="text-[10px] text-slate-500">₹{f.compensation_amount?.toLocaleString()}</p>
                          </div>
                          <div className="flex items-center gap-3">
                            <span className="text-[10px] font-bold text-rose-300 bg-rose-500/20 px-2 py-0.5 rounded-full border border-rose-500/30">
                              ✕ Rejected
                            </span>
                            <button
                              onClick={() => updateStatus(f.id, "Verified")}
                              disabled={updatingId !== null}
                              className="text-[10px] text-blue-400 hover:text-blue-300 transition underline"
                            >
                              Re-approve
                            </button>
                          </div>
                        </div>
                      ))
                    )}
                  </div>
                </div>
              </div>
            </div>
          )}
        </main>
      </DashboardLayout>
    </RoleGuard>
  );
}
