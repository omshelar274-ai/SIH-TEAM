"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { supabase } from "@/lib/supabaseClient";
import { DirectiveItem } from "@/components/DirectivesModal";
import DashboardLayout from "@/components/DashboardLayout";
import RoleGuard from "@/components/RoleGuard";
import ResolveDirectiveModal from "@/components/ResolveDirectiveModal";

interface ProjectRow {
  id: string;
  project_name: string;
  project_type: string;
  district: string;
  villages_affected: string;
  status: string;
  start_date: string;
  target_handover_date: string;
  est_families_affected: number;
}

interface FamilySummary {
  projectId: string;
  total: number;
  pending: number;
  paid: number;
  activeCases: number;
  error?: string | null;
}

export default function PatwariDashboardPage() {
  const [projects, setProjects] = useState<ProjectRow[]>([]);
  const [summaries, setSummaries] = useState<Record<string, FamilySummary>>({});
  const [loading, setLoading] = useState(true);
  const [userName, setUserName] = useState("Field Patwari (Talathi)");
  const [district, setDistrict] = useState("Nagpur");
  const [directives, setDirectives] = useState<DirectiveItem[]>([]);
  const [resolvingDirective, setResolvingDirective] = useState<DirectiveItem | null>(null);

  async function loadDirectives() {
    try {
      const { data: dbDirs } = await supabase
        .from("directives")
        .select("id, project_id, directive_type, title, description, target_days, assigned_to, status, created_at")
        .order("created_at", { ascending: false });

      if (dbDirs) {
        setDirectives(
          dbDirs
            .filter((d: any) => d.assigned_to === "Patwari" || d.assigned_to === "patwari" || d.assigned_to === "LAO / Tehsildar")
            .map((d: any) => ({
              id: d.id,
              projectId: d.project_id,
              directiveType: d.directive_type,
              title: d.title,
              description: d.description,
              targetDays: d.target_days,
              assignedTo: d.assigned_to,
              status: d.status,
              createdAt: d.created_at,
            }))
        );
      }
    } catch {}
  }

  useEffect(() => {
    loadDirectives();
  }, []);

  function handleDirectiveResolved(updated: DirectiveItem) {
    setDirectives((prev) => prev.map((d) => (d.id === updated.id ? updated : d)));
    load();
  }

  async function load() {
    setLoading(true);
    try {
      let userDistrict = "Nagpur";
      try {
        const { data: { user } } = await supabase.auth.getUser();
        if (user) {
          const { data: profile } = await supabase
            .from("profiles")
            .select("full_name, district")
            .eq("id", user.id)
            .single();
          if (profile?.district) userDistrict = profile.district;
          if (profile?.full_name) setUserName(profile.full_name);
        }
      } catch {}
      setDistrict(userDistrict);

      const { data: projectData, error: projErr } = await supabase
        .from("projects")
        .select("id, project_name, project_type, district, villages_affected, status, start_date, target_handover_date, est_families_affected")
        .eq("district", userDistrict)
        .order("created_at", { ascending: false });

      if (projErr) {
        console.error("[Patwari Dashboard] Error loading projects:", projErr);
      }

      const rows = (projectData as ProjectRow[]) ?? [];
      setProjects(rows);

      const summaryMap: Record<string, FamilySummary> = {};
      await Promise.all(rows.map(async (p) => {
        try {
          const { data: fams, error: famsErr } = await supabase
            .from("families")
            .select("payment_status, court_case_status, verification_status")
            .eq("project_id", p.id);

          if (famsErr) {
            console.error(`[Patwari Dashboard] Failed to load families for project ${p.id} (${p.project_name}):`, famsErr);
            summaryMap[p.id] = {
              projectId: p.id,
              total: 0,
              pending: 0,
              paid: 0,
              activeCases: 0,
              error: famsErr.message || "Database query failed",
            };
          } else {
            summaryMap[p.id] = {
              projectId: p.id,
              total: fams?.length ?? 0,
              pending: fams?.filter(f => f.verification_status === "Pending").length ?? 0,
              paid: fams?.filter(f => f.payment_status === "Paid").length ?? 0,
              activeCases: fams?.filter(f => f.court_case_status === "Active").length ?? 0,
              error: null,
            };
          }
        } catch (err: any) {
          console.error(`[Patwari Dashboard] Exception loading families for project ${p.id}:`, err);
          summaryMap[p.id] = {
            projectId: p.id,
            total: 0,
            pending: 0,
            paid: 0,
            activeCases: 0,
            error: err?.message || "Unexpected query failure",
          };
        }
      }));
      setSummaries(summaryMap);
    } catch (err) {
      console.error("[Patwari Dashboard] Critical load error:", err);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    load();
  }, []);

  function daysUntil(dateStr: string) {
    const diff = new Date(dateStr).getTime() - Date.now();
    return Math.max(0, Math.ceil(diff / (1000 * 60 * 60 * 24)));
  }

  return (
    <RoleGuard allowedRoles={["patwari", "collector"]}>
      <DashboardLayout>
      <main className="py-8 px-6 font-sans text-slate-100 min-h-screen">
        <div className="max-w-4xl mx-auto space-y-6">
          {/* Header */}
          <div className="bg-gradient-to-r from-emerald-900 to-teal-950 border border-emerald-800/60 rounded-2xl p-8 shadow-2xl relative overflow-hidden">
            <div className="flex items-center gap-2 mb-1">
              <span className="text-[10px] font-mono font-bold uppercase tracking-widest bg-emerald-500/20 text-emerald-300 border border-emerald-500/30 px-2.5 py-0.5 rounded-full">
                Ground Revenue Survey Portal · District {district}
              </span>
            </div>
            <h1 className="text-3xl font-black text-white tracking-tight">
              Patwari (Talathi) Field Entry Portal
            </h1>
            <p className="text-emerald-200 text-xs mt-2 max-w-xl">
              Welcome, <span className="font-bold text-white">{userName}</span>. Register ground survey parcel records, verify family land titles, compensation disbursement vouchers, and resolve field conciliation objections.
            </p>
          </div>

          {/* Collector Directives Alert */}
          {directives.length > 0 && (
            <div className="bg-slate-900 border border-amber-500/40 rounded-2xl p-5 shadow-2xl space-y-3">
              <div className="flex justify-between items-center border-b border-slate-800 pb-2">
                <span className="text-xs font-mono font-bold text-amber-400 flex items-center gap-2">
                  <span className="w-2 h-2 rounded-full bg-amber-400 animate-ping" />
                  📢 Administrative Directives Assigned to Field Team
                </span>
                <span className="text-[10px] text-slate-400 font-mono">Issued by Collector / LAO</span>
              </div>

              <div className="space-y-2 text-xs font-mono">
                {directives.map((d) => (
                  <div key={d.id} className="bg-slate-950 p-3.5 rounded-xl border border-slate-800 flex flex-col sm:flex-row sm:items-center justify-between gap-2">
                    <div>
                      <p className="font-bold text-white text-sm leading-tight">{d.title}</p>
                      <p className="text-xs text-slate-300 font-sans mt-0.5">{d.description}</p>
                      <p className="text-[10px] text-slate-400 mt-1">
                        Corridor: <b>{d.projectName}</b> · SLA: <b>{d.targetDays} Days</b>
                      </p>
                    </div>
                    <div className="flex items-center gap-2 shrink-0">
                      <span className={`text-[9px] px-2 py-0.5 rounded-full font-bold uppercase ${
                        d.status === "RESOLVED" ? "bg-emerald-500/20 text-emerald-300" : "bg-amber-500/20 text-amber-300"
                      }`}>
                        {d.status}
                      </span>
                      {d.status !== "RESOLVED" && (
                        <button
                          onClick={() => setResolvingDirective(d)}
                          className="bg-emerald-600 hover:bg-emerald-500 text-white px-3 py-1.5 rounded-lg text-xs font-bold shadow-md shadow-emerald-600/20 transition"
                        >
                          ✓ Execute &amp; Resolve
                        </button>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Assigned Corridors Header */}
          <div className="flex justify-between items-center">
            <div>
              <h2 className="text-lg font-bold text-white font-mono">
                Assigned Revenue Corridors ({projects.length})
              </h2>
              <p className="text-xs text-slate-400">
                Select any corridor below to enter or edit beneficiary family records.
              </p>
            </div>
            <button onClick={() => load()} className="text-xs text-emerald-400 bg-emerald-950/40 border border-emerald-800/60 px-3 py-1.5 rounded-lg hover:bg-emerald-900/50 font-mono transition">
              ↻ Refresh
            </button>
          </div>

          {loading ? (
            <div className="text-center py-20 bg-slate-900 rounded-2xl border border-slate-800">
              <div className="w-8 h-8 border-4 border-emerald-500 border-t-transparent rounded-full animate-spin mx-auto" />
              <p className="text-xs text-slate-400 mt-4 font-mono">Loading assigned {district} project corridors...</p>
            </div>
          ) : projects.length === 0 ? (
            <div className="text-center py-16 bg-slate-900 rounded-2xl border border-slate-800 p-8 space-y-2">
              <p className="text-slate-300 font-bold text-sm">No active projects found in {district}.</p>
              <p className="text-xs text-slate-500">Run the seed SQL in Supabase to populate project corridors.</p>
            </div>
          ) : (
            <div className="space-y-4">
              {projects.map((p) => {
                const summary = summaries[p.id] || { total: 0, pending: 0, paid: 0, activeCases: 0 };
                const daysLeft = daysUntil(p.target_handover_date);

                return (
                  <div key={p.id} className="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl space-y-4">
                    <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 border-b border-slate-800 pb-3">
                      <div>
                        <span className="text-[10px] font-mono font-bold bg-slate-800 text-slate-300 px-2 py-0.5 rounded-full uppercase">
                          {p.project_type} · {p.district}
                        </span>
                        <h3 className="text-lg font-black text-white mt-1">{p.project_name}</h3>
                        <p className="text-xs text-slate-400 mt-0.5">Villages: {p.villages_affected}</p>
                      </div>
                      <div className="text-right font-mono">
                        <span className="text-[10px] text-slate-400 block">Target Handover</span>
                        <span className="text-xs font-bold text-amber-400">{daysLeft} days remaining</span>
                      </div>
                    </div>

                    {/* Error Banner if Query Failed */}
                    {summary.error && (
                      <div className="bg-red-950/40 border border-red-800/60 rounded-xl p-3 text-xs text-red-300 flex items-center gap-2">
                        <span className="text-red-400 font-bold">⚠</span>
                        <span>Could not load family records: {summary.error}</span>
                      </div>
                    )}

                    {/* Summary Metric Strip */}
                    <div className="grid grid-cols-4 gap-2 text-center text-xs font-mono">
                      <div className="bg-slate-950 p-2.5 rounded-xl border border-slate-800">
                        <p className="text-[10px] text-slate-400">Total Families</p>
                        <p className="text-base font-black text-white mt-0.5">{summary.total}</p>
                      </div>
                      <div className="bg-slate-950 p-2.5 rounded-xl border border-slate-800">
                        <p className="text-[10px] text-slate-400">Pending LAO Audit</p>
                        <p className="text-base font-black text-amber-400 mt-0.5">{summary.pending}</p>
                      </div>
                      <div className="bg-slate-950 p-2.5 rounded-xl border border-slate-800">
                        <p className="text-[10px] text-slate-400">Paid Comp.</p>
                        <p className="text-base font-black text-emerald-400 mt-0.5">{summary.paid}</p>
                      </div>
                      <div className="bg-slate-950 p-2.5 rounded-xl border border-slate-800">
                        <p className="text-[10px] text-slate-400">Active Disputes</p>
                        <p className="text-base font-black text-red-400 mt-0.5">{summary.activeCases}</p>
                      </div>
                    </div>

                    {/* Ground Data Entry Action Button */}
                    <div className="flex justify-between items-center pt-2">
                      <span className="text-xs text-slate-400 font-mono">
                        {summary.total} ground land parcel records in Supabase
                      </span>
                      <Link
                        href={`/projects/${p.id}/families`}
                        className="bg-emerald-600 hover:bg-emerald-500 text-white text-xs px-5 py-2.5 rounded-xl font-bold transition flex items-center gap-2 shadow-lg shadow-emerald-600/25 active:scale-95"
                      >
                        <span>📝 Enter / Edit Family Ground Survey Records</span>
                        <span>→</span>
                      </Link>
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>

        {/* Resolve Directive Modal */}
        {resolvingDirective && (
          <ResolveDirectiveModal
            directive={resolvingDirective}
            officerRole="patwari"
            onClose={() => setResolvingDirective(null)}
            onResolved={handleDirectiveResolved}
          />
        )}
        </main>
      </DashboardLayout>
    </RoleGuard>
  );
}
