"use client";

import { useEffect, useState } from "react";
import { useParams, useRouter } from "next/navigation";
import { supabase } from "@/lib/supabaseClient";

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
            const filtered = (allFams || []).filter((f: any) => f.project_id === projectId);
            setFamilies(filtered as FamilyRecord[]);
          }
        } catch {}
      }
      setLoading(false);
    }
    if (projectId) load();
  }, [projectId, router]);

  async function updateStatus(familyId: string, status: "Verified" | "Rejected") {
    setUpdatingId(familyId);
    try {
      // Primary: Call server API bridge (immune to client RLS restrictions)
      const res = await fetch("/api/verify-family", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ familyId, status }),
      });

      if (res.ok) {
        setFamilies((prev) =>
          prev.map((f) => (f.id === familyId ? { ...f, verification_status: status } : f))
        );
      } else {
        // Fallback: Direct client supabase update
        const { error } = await supabase
          .from("families")
          .update({ verification_status: status })
          .eq("id", familyId);

        if (error) {
          alert("Failed to update status: " + error.message);
        } else {
          setFamilies((prev) =>
            prev.map((f) => (f.id === familyId ? { ...f, verification_status: status } : f))
          );
        }
      }
    } catch (err: any) {
      alert("Verification update failed: " + err?.message);
    } finally {
      setUpdatingId(null);
    }
  }

  async function verifyAllPending() {
    const pendingIds = families.filter((f) => f.verification_status === "Pending").map((f) => f.id);
    if (pendingIds.length === 0) return;

    setUpdatingId("bulk");
    try {
      await Promise.all(
        pendingIds.map((id) =>
          fetch("/api/verify-family", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ familyId: id, status: "Verified" }),
          })
        )
      );
      setFamilies((prev) =>
        prev.map((f) =>
          pendingIds.includes(f.id) ? { ...f, verification_status: "Verified" } : f
        )
      );
    } catch {
      // Fallback
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
    <main className="min-h-screen bg-slate-50 py-10 px-6 font-sans">
      <div className="max-w-6xl mx-auto">
        <div className="flex items-center gap-3 mb-6">
          <a
            href="/dashboard/lao"
            className="text-slate-500 hover:text-slate-800 text-sm font-semibold transition"
          >
            ← Back to Portal
          </a>
        </div>

        <div className="flex flex-col md:flex-row md:items-center justify-between mb-8 gap-4 bg-white p-6 rounded-xl border border-slate-200 shadow-sm">
          <div>
            <span className="text-xs font-semibold px-2 py-0.5 rounded-full bg-slate-100 text-slate-500 mb-2 inline-block">
              District: {district}
            </span>
            <h1 className="text-2xl font-bold text-slate-800">{projectName}</h1>
            <p className="text-sm text-slate-400 mt-1">
              Verify family land survey numbers, R&amp;R displacement declarations, and litigation parameters.
            </p>
          </div>

          {pending.length > 0 && (
            <button
              onClick={verifyAllPending}
              disabled={updatingId !== null}
              className="bg-indigo-600 hover:bg-indigo-700 text-white text-sm font-semibold rounded-lg px-4 py-2.5 transition shadow-sm disabled:opacity-50"
            >
              {updatingId === "bulk" ? "Processing..." : `✓ Bulk Approve ${pending.length} Pending`}
            </button>
          )}
        </div>

        {loading ? (
          <div className="text-center py-20 bg-white rounded-xl border border-slate-200">
            <div className="w-8 h-8 border-4 border-indigo-600 border-t-transparent rounded-full animate-spin mx-auto"></div>
            <p className="text-sm text-slate-400 mt-4">Loading family registries...</p>
          </div>
        ) : families.length === 0 ? (
          <div className="text-center py-16 bg-white rounded-xl border border-slate-200 p-8">
            <p className="font-semibold text-slate-700">No family data entered yet</p>
            <p className="text-sm text-slate-400 mt-1">
              The Patwari has not submitted any family records for this project.
            </p>
          </div>
        ) : (
          <div className="space-y-8">
            {/* Pending Audit List */}
            {pending.length > 0 && (
              <div>
                <h2 className="text-base font-bold text-amber-700 mb-3 flex items-center gap-2">
                  <span className="w-2.5 h-2.5 rounded-full bg-amber-500"></span>
                  Awaiting Verification ({pending.length})
                </h2>
                <div className="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
                  <div className="overflow-x-auto">
                    <table className="w-full text-left border-collapse text-sm">
                      <thead>
                        <tr className="bg-slate-50 border-b border-slate-200 text-slate-500 font-semibold uppercase text-xs">
                          <th className="px-6 py-3.5">Beneficiary / Family</th>
                          <th className="px-6 py-3.5">Land Owned (Ha)</th>
                          <th className="px-6 py-3.5">Compensation</th>
                          <th className="px-6 py-3.5">Court Case</th>
                          <th className="px-6 py-3.5">Possession</th>
                          <th className="px-6 py-3.5 text-right">Actions</th>
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-slate-100">
                        {pending.map((f) => (
                          <tr key={f.id} className="hover:bg-slate-50/50 transition">
                            <td className="px-6 py-4 font-semibold text-slate-800">{f.family_name}</td>
                            <td className="px-6 py-4 text-slate-600">{f.land_area_owned || "0"} Ha</td>
                            <td className="px-6 py-4">
                              <p className="text-slate-700 font-medium">₹{f.compensation_amount?.toLocaleString()}</p>
                              <span className={`text-xs font-medium px-2 py-0.5 rounded-full ${
                                f.payment_status === "Paid" ? "bg-green-50 text-green-700" : "bg-amber-50 text-amber-700"
                              }`}>
                                {f.payment_status}
                              </span>
                            </td>
                            <td className="px-6 py-4">
                              <span className={`text-xs font-semibold px-2 py-0.5 rounded-full ${
                                f.court_case_status === "Active" ? "bg-red-50 text-red-700" : "bg-slate-100 text-slate-500"
                              }`}>
                                {f.court_case_status}
                              </span>
                              {f.court_case_filed_date && (
                                <p className="text-xs text-slate-400 mt-1">
                                  Filed: {new Date(f.court_case_filed_date).toLocaleDateString()}
                                </p>
                              )}
                            </td>
                            <td className="px-6 py-4 text-slate-600">{f.possession_status}</td>
                            <td className="px-6 py-4 text-right">
                              <div className="flex justify-end gap-2">
                                <button
                                  onClick={() => updateStatus(f.id, "Verified")}
                                  disabled={updatingId !== null}
                                  className="text-xs font-semibold bg-emerald-50 text-emerald-700 border border-emerald-200 px-3 py-1.5 rounded-lg hover:bg-emerald-100 transition disabled:opacity-50"
                                >
                                  Approve
                                </button>
                                <button
                                  onClick={() => updateStatus(f.id, "Rejected")}
                                  disabled={updatingId !== null}
                                  className="text-xs font-semibold bg-rose-50 text-rose-700 border border-rose-200 px-3 py-1.5 rounded-lg hover:bg-rose-100 transition disabled:opacity-50"
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
                <h2 className="text-base font-bold text-slate-700 mb-3">
                  Verified Records ({verified.length})
                </h2>
                <div className="bg-white rounded-xl border border-slate-200 shadow-sm p-4 divide-y divide-slate-100 max-h-[400px] overflow-y-auto">
                  {verified.length === 0 ? (
                    <p className="text-xs text-slate-400 py-4 text-center">No verified entries</p>
                  ) : (
                    verified.map((f) => (
                      <div key={f.id} className="py-3 flex justify-between items-center text-sm">
                        <div>
                          <p className="font-semibold text-slate-800">{f.family_name}</p>
                          <p className="text-xs text-slate-400">₹{f.compensation_amount?.toLocaleString()} · {f.land_area_owned} Ha</p>
                        </div>
                        <div className="flex items-center gap-3">
                          <span className="text-xs font-semibold text-emerald-600 bg-emerald-50 px-2 py-0.5 rounded-md">
                            Verified
                          </span>
                          <button
                            onClick={() => updateStatus(f.id, "Rejected")}
                            disabled={updatingId !== null}
                            className="text-xs text-slate-400 hover:text-rose-600 transition"
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
                <h2 className="text-base font-bold text-slate-700 mb-3">
                  Rejected Records ({rejected.length})
                </h2>
                <div className="bg-white rounded-xl border border-slate-200 shadow-sm p-4 divide-y divide-slate-100 max-h-[400px] overflow-y-auto">
                  {rejected.length === 0 ? (
                    <p className="text-xs text-slate-400 py-4 text-center">No rejected entries</p>
                  ) : (
                    rejected.map((f) => (
                      <div key={f.id} className="py-3 flex justify-between items-center text-sm">
                        <div>
                          <p className="font-semibold text-slate-850 line-through text-slate-400">{f.family_name}</p>
                          <p className="text-xs text-slate-400">₹{f.compensation_amount?.toLocaleString()}</p>
                        </div>
                        <div className="flex items-center gap-3">
                          <span className="text-xs font-semibold text-rose-600 bg-rose-50 px-2 py-0.5 rounded-md">
                            Rejected
                          </span>
                          <button
                            onClick={() => updateStatus(f.id, "Verified")}
                            disabled={updatingId !== null}
                            className="text-xs text-indigo-600 hover:underline transition font-semibold"
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
      </div>
    </main>
  );
}
