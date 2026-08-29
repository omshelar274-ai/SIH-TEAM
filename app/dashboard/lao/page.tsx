"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { supabase } from "@/lib/supabaseClient";
import { ProjectRecord } from "@/lib/projectMetrics";
import { DirectiveItem } from "@/components/DirectivesModal";
import StatutoryTimeline from "@/components/StatutoryTimeline";
import DashboardLayout from "@/components/DashboardLayout";
import RoleGuard from "@/components/RoleGuard";
import ResolveDirectiveModal from "@/components/ResolveDirectiveModal";

interface ProjectVerificationCount {
  project: ProjectRecord;
  pendingCount: number;
  totalCount: number;
}

export default function LAODashboardPage() {
  const [projects, setProjects] = useState<ProjectVerificationCount[]>([]);
  const [loading, setLoading] = useState(true);
  const [userName, setUserName] = useState("LAO / Tehsildar");
  const [district, setDistrict] = useState("Nagpur");
  const [directives, setDirectives] = useState<DirectiveItem[]>([]);
  const [expandedTimelineId, setExpandedTimelineId] = useState<string | null>(null);
  const [resolvingDirective, setResolvingDirective] = useState<DirectiveItem | null>(null);

  async function loadDirectives() {
    try {
      const { data: dbDirs } = await supabase
        .from("directives")
        .select("id, project_id, directive_type, title, description, target_days, assigned_to, status, created_at")
        .order("created_at", { ascending: false });

      if (dbDirs) {
        setDirectives(
          dbDirs.map((d: any) => ({
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

  async function handleUpdateDirectiveStatus(id: string, newStatus: DirectiveItem["status"]) {
    try {
      await supabase.from("directives").update({ status: newStatus, updated_at: new Date().toISOString() }).eq("id", id);
      setDirectives((prev) => prev.map((d) => (d.id === id ? { ...d, status: newStatus } : d)));
    } catch {}
  }

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

      const { data: projectData, error: projectErr } = await supabase
        .from("projects")
        .select("*")
        .eq("district", userDistrict)
        .order("created_at", { ascending: false });

      if (projectErr || !projectData) {
        return;
      }

      const projectsWithCounts = await Promise.all(
        (projectData as ProjectRecord[]).map(async (project) => {
          let pending = 0;
          let total = 0;
          try {
            const { data: families } = await supabase
              .from("families")
              .select("verification_status")
              .eq("project_id", project.id);

            pending = families?.filter((f) => f.verification_status === "Pending").length ?? 0;
            total = families?.length ?? 0;
          } catch {}

          return {
            project,
            pendingCount: pending,
            totalCount: total,
          };
        })
      );

      setProjects(projectsWithCounts);
    } catch (err) {
      console.warn("LAO load error:", err);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    load();
  }, []);

  const pendingDirectives = directives.filter((d) => d.status !== "RESOLVED");

  return (
    <RoleGuard allowedRoles={["lao", "collector"]}>
      <DashboardLayout>
      <main className="py-8 px-6 font-sans text-slate-100 min-h-screen">
        <div className="max-w-4xl mx-auto space-y-6">
          {/* Header Strip */}
          <div className="bg-gradient-to-r from-blue-900 to-indigo-950 border border-blue-800/60 rounded-2xl p-8 shadow-2xl relative overflow-hidden">
            <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
              <div>
                <p className="text-blue-300 font-mono text-xs font-bold uppercase tracking-wider mb-1">
                  Workflow Gateway · District {district}
                </p>
                <h1 className="text-3xl font-black text-white tracking-tight">
                  Land Acquisition Officer / Tehsildar Panel
                </h1>
                <p className="text-blue-200 mt-2 max-w-xl text-xs">
                  Welcome, <span className="font-bold text-white">{userName}</span>. Execute binding Collector directives, monitor statutory SLA clocks, and audit revenue survey records.
                </p>
              </div>
              <div className="flex gap-2">
                <Link href="/demo" className="bg-white/10 hover:bg-white/20 border border-white/20 text-white text-xs px-3.5 py-2 rounded-xl font-bold transition">
                  🧭 Guided Tour
                </Link>
              </div>
            </div>
          </div>

          {/* Collector Directives Notification Inbox */}
          {directives.length > 0 && (
            <div className="bg-slate-900 border border-amber-500/40 rounded-2xl p-6 shadow-2xl space-y-4">
              <div className="flex justify-between items-center border-b border-slate-800 pb-3">
                <div className="flex items-center gap-2">
                  <span className="w-2.5 h-2.5 rounded-full bg-amber-400 animate-ping" />
                  <h2 className="text-sm font-bold text-white font-mono uppercase tracking-wider flex items-center gap-2">
                    <span>🚨 Collector Directives &amp; Action Orders</span>
                    <span className="bg-amber-500/20 text-amber-300 text-[10px] px-2 py-0.5 rounded-full">
                      {pendingDirectives.length} Action Needed
                    </span>
                  </h2>
                </div>
                <span className="text-[10px] text-slate-400 font-mono">Dispatched by District Collector</span>
              </div>

              <div className="space-y-3 font-mono text-xs">
                {directives.map((d) => (
                  <div
                    key={d.id}
                    className={`p-4 rounded-xl border transition ${
                      d.status === "RESOLVED"
                        ? "bg-emerald-950/20 border-emerald-800/40 text-slate-400"
                        : d.status === "IN_PROGRESS"
                        ? "bg-sky-950/30 border-sky-800/60 text-slate-200"
                        : "bg-amber-950/30 border-amber-700/60 text-slate-100"
                    }`}
                  >
                    <div className="flex flex-col md:flex-row md:items-center justify-between gap-2">
                      <div>
                        <div className="flex items-center gap-2">
                          <span className="font-extrabold text-white text-sm">{d.title}</span>
                          <span className={`text-[9px] px-2 py-0.5 rounded-full font-bold uppercase ${
                            d.status === "RESOLVED" ? "bg-emerald-500/20 text-emerald-300" : d.status === "IN_PROGRESS" ? "bg-sky-500/20 text-sky-300" : "bg-amber-500/20 text-amber-300"
                          }`}>
                            {d.status}
                          </span>
                        </div>
                        <p className="text-xs text-slate-300 font-sans mt-1">{d.description}</p>
                        <p className="text-[10px] text-slate-400 mt-1 font-mono">
                          Target Project: <b>{d.projectName}</b> · SLA: <b>{d.targetDays} days</b> · Assigned To: <b>{d.assignedTo}</b>
                        </p>
                      </div>

                      <div className="flex gap-2 shrink-0 items-center">
                        {d.status === "OPEN" && (
                          <button
                            onClick={() => handleUpdateDirectiveStatus(d.id, "IN_PROGRESS")}
                            className="bg-sky-600 hover:bg-sky-500 text-white px-3 py-1.5 rounded-lg text-xs font-bold transition"
                          >
                            Mark In Progress
                          </button>
                        )}
                        {d.status !== "RESOLVED" && (
                          <button
                            onClick={() => setResolvingDirective(d)}
                            className="bg-emerald-600 hover:bg-emerald-500 text-white px-3 py-1.5 rounded-lg text-xs font-bold transition shadow-md shadow-emerald-600/25"
                          >
                            ✓ Execute &amp; Resolve
                          </button>
                        )}
                        {d.status === "RESOLVED" && (
                          <span className="text-emerald-400 font-bold flex items-center gap-1 text-xs">
                            ✓ Resolved by LAO
                          </span>
                        )}
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Assigned Projects Header */}
          <div className="flex justify-between items-center">
            <h2 className="text-lg font-bold text-white font-mono">
              {district} Projects &amp; Verification Queue ({projects.length})
            </h2>
            <button
              onClick={() => load()}
              className="text-xs text-indigo-400 bg-indigo-950/40 border border-indigo-800/60 px-3 py-1.5 rounded-lg hover:bg-indigo-900/50 font-mono transition"
            >
              ↻ Refresh List
            </button>
          </div>

          {loading ? (
            <div className="flex flex-col items-center justify-center py-20 bg-slate-900 rounded-2xl border border-slate-800">
              <div className="w-10 h-10 border-4 border-indigo-500 border-t-transparent rounded-full animate-spin" />
              <p className="text-xs text-slate-400 mt-4 font-mono">Fetching {district} projects and audit queues...</p>
            </div>
          ) : projects.length === 0 ? (
            <div className="text-center py-16 bg-slate-900 rounded-2xl border border-slate-800 p-8 space-y-3">
              <div className="text-4xl">📭</div>
              <p className="font-semibold text-slate-300">No projects found in {district}</p>
            </div>
          ) : (
            <div className="space-y-6">
              {projects.map(({ project, pendingCount, totalCount }) => (
                <div
                  key={project.id}
                  className="bg-slate-900 rounded-2xl border border-slate-800 p-6 shadow-xl space-y-4"
                >
                  <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-slate-800 pb-4">
                    <div>
                      <div className="flex items-center gap-2 mb-1 font-mono text-[10px]">
                        <span className="font-bold px-2 py-0.5 rounded-full bg-slate-800 text-slate-300 uppercase">
                          {project.project_type}
                        </span>
                        <span className="font-bold px-2 py-0.5 rounded-full bg-indigo-500/20 text-indigo-300 border border-indigo-500/30">
                          District: {project.district}
                        </span>
                      </div>
                      <h3 className="font-black text-white text-lg leading-tight">{project.project_name}</h3>
                      <p className="text-xs text-slate-400 mt-1">
                        Villages: {project.villages_affected} · Land Required: {project.total_land_area_hectares} Ha
                      </p>
                    </div>

                    <div className="flex items-center gap-4">
                      <div className="text-right font-mono">
                        <p className="text-[10px] text-slate-400 uppercase tracking-wider font-bold">Verification Audit</p>
                        <div className="flex items-center gap-1.5 justify-end mt-0.5">
                          {pendingCount > 0 ? (
                            <>
                              <span className="w-2.5 h-2.5 rounded-full bg-amber-400 animate-pulse" />
                              <span className="text-sm font-black text-amber-400">
                                {pendingCount} Pending
                              </span>
                            </>
                          ) : (
                            <span className="text-sm font-black text-emerald-400">
                              ✓ All Clear
                            </span>
                          )}
                          <span className="text-xs text-slate-400">
                            / {totalCount} families
                          </span>
                        </div>
                      </div>

                      <div className="flex gap-2">
                        <button
                          onClick={() => setExpandedTimelineId(expandedTimelineId === project.id ? null : project.id)}
                          className="bg-slate-800 hover:bg-slate-700 text-slate-300 text-xs px-3 py-2 rounded-xl font-bold transition"
                        >
                          {expandedTimelineId === project.id ? "Hide Timeline" : "📜 SLA Timeline"}
                        </button>
                        <Link
                          href={`/projects/${project.id}/verify`}
                          className={`rounded-xl px-4 py-2 text-xs font-bold shadow-lg transition ${
                            pendingCount > 0
                              ? "bg-indigo-600 hover:bg-indigo-500 text-white shadow-indigo-600/25"
                              : "bg-slate-800 hover:bg-slate-700 text-slate-300"
                          }`}
                        >
                          {pendingCount > 0 ? "Verify Queue →" : "Review Records"}
                        </Link>
                      </div>
                    </div>
                  </div>

                  {/* Expandable Statutory Milestone Clock */}
                  {expandedTimelineId === project.id && (
                    <div className="animate-fade-in pt-2">
                      <StatutoryTimeline projectType={project.project_type} />
                    </div>
                  )}
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Resolve Directive Modal */}
        {resolvingDirective && (
          <ResolveDirectiveModal
            directive={resolvingDirective}
            officerRole="lao"
            onClose={() => setResolvingDirective(null)}
            onResolved={handleDirectiveResolved}
          />
        )}
        </main>
      </DashboardLayout>
    </RoleGuard>
  );
}
