"use client";

import { useEffect, useState, useRef } from "react";
import Link from "next/link";
import { supabase } from "@/lib/supabaseClient";
import { fetchProjectMetrics, ProjectRecord } from "@/lib/projectMetrics";
import { RiskResult, ProjectMetrics, calculateRisk } from "@/lib/riskScore";
import RiskCard from "@/components/RiskCard";
import WhatIfSimulator from "@/components/WhatIfSimulator";
import SurvivalAnalysisCard from "@/components/SurvivalAnalysisCard";
import DirectivesModal, { DirectiveItem } from "@/components/DirectivesModal";
import DashboardLayout from "@/components/DashboardLayout";
import { NAGPUR_GEOJSON_FEATURES } from "@/lib/nagpurGeoData";

interface ProjectWithRisk {
  project: ProjectRecord;
  metrics: ProjectMetrics;
  result: RiskResult;
  source: "ml" | "rule-based";
  pendingFamiliesCount: number;
}

async function predictRisk(
  metrics: ProjectMetrics,
  totalLandAreaHectares: number,
  estFamiliesAffected: number
): Promise<{ result: RiskResult; source: "ml" | "rule-based" }> {
  try {
    const res = await fetch("/api/predict-risk", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ metrics, totalLandAreaHectares, estFamiliesAffected }),
      signal: AbortSignal.timeout(2500),
    });
    if (!res.ok) throw new Error("predict-risk returned non-200");
    const data = await res.json();
    const { source, ...result } = data;
    return { result, source: source || "ml" };
  } catch {
    return { result: calculateRisk(metrics), source: "rule-based" };
  }
}

export default function DashboardPage() {
  const [projects, setProjects] = useState<ProjectWithRisk[]>([]);
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState<"cards" | "map">("cards");
  const [selectedRisk, setSelectedRisk] = useState<string>("ALL");
  const [searchTerm, setSearchTerm] = useState("");
  const [district, setDistrict] = useState("Nagpur");
  const [syncingId, setSyncingId] = useState<string | null>(null);
  const [syncLogs, setSyncLogs] = useState<string[]>([]);
  const [syncComplete, setSyncComplete] = useState(false);
  const mapInitRef = useRef(false);

  // Modals
  const [simulatingProject, setSimulatingProject] = useState<{ project: ProjectRecord; metrics: ProjectMetrics } | null>(null);
  const [directingProject, setDirectingProject] = useState<ProjectRecord | null>(null);
  const [expandedSurvivalId, setExpandedSurvivalId] = useState<string | null>(null);
  const [issuedDirectives, setIssuedDirectives] = useState<DirectiveItem[]>([]);

  useEffect(() => {
    const saved = JSON.parse(localStorage.getItem("collector_directives") || "[]");
    setIssuedDirectives(saved);
  }, []);

  async function loadData() {
    setLoading(true);

    try {
      let userDistrict = "Nagpur";
      try {
        const { data: { user } } = await supabase.auth.getUser();
        if (user) {
          const { data: profile } = await supabase
            .from("profiles")
            .select("full_name, district, role")
            .eq("id", user.id)
            .single();
          if (profile?.district) userDistrict = profile.district;
        }
      } catch {}
      setDistrict(userDistrict);

      const { data, error } = await supabase
        .from("projects")
        .select("*")
        .eq("district", userDistrict)
        .order("created_at", { ascending: false });

      if (error || !data || data.length === 0) {
        setProjects([]);
        return;
      }

      const withRisk = await Promise.all(
        (data as ProjectRecord[]).map(async (project) => {
          try {
            const metrics = await fetchProjectMetrics(project);
            let pendingCount = 0;
            try {
              const { data: families } = await supabase
                .from("families")
                .select("verification_status")
                .eq("project_id", project.id);
              pendingCount = families?.filter((f) => f.verification_status === "Pending").length ?? 0;
            } catch {}

            const { result, source } = await predictRisk(metrics, project.total_land_area_hectares, project.est_families_affected);
            return { project, metrics, result, source, pendingFamiliesCount: pendingCount };
          } catch {
            const fallbackMetrics: ProjectMetrics = {
              compensationPaidPct: 70,
              courtCasesActive: 1,
              courtCasesRecent90d: 0,
              courtCaseAvgAgeDays: 30,
              rrProgressPct: 80,
              possessionRefusingPct: 5,
              stFamilies: project.st_families || 0,
              forestClearanceApplied: project.forest_clearance_applied ?? true,
              daysSinceForestClearanceNeeded: 0,
              monthsElapsed: 12,
              monthsTotal: 24,
              deptResponseDays: project.avg_dept_response_days || 10,
              laoBacklogRatio: 1.2,
            };
            return {
              project,
              metrics: fallbackMetrics,
              result: calculateRisk(fallbackMetrics),
              source: "rule-based" as const,
              pendingFamiliesCount: 0,
            };
          }
        })
      );

      setProjects(withRisk);
    } catch (err) {
      console.warn("loadData failed gracefully:", err);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => { loadData(); }, []);

  // Initialize interactive Leaflet Map with authentic GeoJSON corridors & acquisition requirements
  useEffect(() => {
    if (activeTab !== "map" || typeof window === "undefined") return;
    if (mapInitRef.current) return;

    const link = document.createElement("link");
    link.rel = "stylesheet";
    link.href = "https://unpkg.com/leaflet@1.9.4/dist/leaflet.css";
    document.head.appendChild(link);

    const script = document.createElement("script");
    script.src = "https://unpkg.com/leaflet@1.9.4/dist/leaflet.js";
    script.onload = () => {
      const L = (window as any).L;
      if (!L) return;
      const mapEl = document.getElementById("dashboard-map");
      if (!mapEl || (mapEl as any)._leaflet_id) return;

      const map = L.map("dashboard-map").setView([21.1550, 79.0882], 11);
      mapInitRef.current = true;

      // Dark theme OpenStreetMap tiles
      L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
        attribution: "© OpenStreetMap contributors",
      }).addTo(map);

      const colorMap: Record<string, string> = {
        CRITICAL: "#ef4444",
        HIGH: "#f97316",
        MODERATE: "#eab308",
        LOW: "#10b981",
      };

      // Draw all authentic Nagpur GeoJSON features
      NAGPUR_GEOJSON_FEATURES.forEach((feat) => {
        const strokeColor = colorMap[feat.riskLevel] || "#6366f1";

        const popupContent = `
          <div style="font-family:sans-serif;min-width:240px;color:#0f172a;">
            <div style="display:flex;align-items:center;justify-content:space-between;border-bottom:1px solid #e2e8f0;padding-bottom:4px;margin-bottom:6px;">
              <span style="font-size:10px;font-weight:bold;color:${strokeColor};text-transform:uppercase;">● ${feat.riskLevel} RISK CORRIDOR</span>
              <span style="font-size:11px;font-weight:bold;background:#f1f5f9;padding:2px 6px;border-radius:4px;">${feat.acquisitionAreaHa} Ha</span>
            </div>
            <h4 style="margin:0 0 4px;font-weight:900;font-size:13px;line-height:1.2;">${feat.name}</h4>
            <p style="margin:0 0 6px;font-size:11px;color:#475569;"><b>Villages:</b> ${feat.villagesCovered}</p>
            ${feat.rowWidthMeters ? `<p style="margin:0 0 4px;font-size:10px;color:#334155;"><b>Acquisition RoW Width:</b> ${feat.rowWidthMeters} meters corridor strip</p>` : ""}
            <div style="background:#f8fafc;padding:6px;border-radius:6px;margin-top:6px;border:1px solid #e2e8f0;">
              <div style="display:flex;justify-content:space-between;font-size:10px;margin-bottom:2px;">
                <span style="font-weight:bold;">Acquisition Status:</span>
                <span style="font-weight:bold;color:${feat.acquiredPct < 50 ? '#ef4444' : '#10b981'};">${feat.acquiredPct}% Acquired</span>
              </div>
              <div style="width:100%;height:6px;background:#e2e8f0;border-radius:3px;overflow:hidden;">
                <div style="width:${feat.acquiredPct}%;height:100%;background:${feat.acquiredPct < 50 ? '#ef4444' : '#10b981'};"></div>
              </div>
              <p style="margin:4px 0 0;font-size:9px;color:#dc2626;line-height:1.2;">⚠ <b>Dispute / Bottleneck:</b> ${feat.criticalDispute}</p>
            </div>
          </div>
        `;

        if (feat.geometry.type === "LineString") {
          // Convert [lng, lat] to [lat, lng] for Leaflet
          const latlngs = feat.geometry.coordinates.map((c: [number, number]) => [c[1], c[0]]);

          // Draw Right of Way acquisition buffer strip (wider glow polyline)
          L.polyline(latlngs, {
            color: strokeColor,
            weight: 14,
            opacity: 0.28,
          }).addTo(map);

          // Draw main center-line corridor
          const line = L.polyline(latlngs, {
            color: strokeColor,
            weight: 4,
            dashArray: feat.riskLevel === "CRITICAL" ? "8, 6" : undefined,
          }).addTo(map);

          line.bindPopup(popupContent);

          // Place midpoint icon marker
          const midIdx = Math.floor(latlngs.length / 2);
          L.circleMarker(latlngs[midIdx], {
            radius: 6,
            color: strokeColor,
            fillColor: "#ffffff",
            fillOpacity: 1,
            weight: 2,
          }).addTo(map).bindPopup(popupContent);

        } else if (feat.geometry.type === "Polygon") {
          const latlngs = feat.geometry.coordinates[0].map((c: [number, number]) => [c[1], c[0]]);
          const poly = L.polygon(latlngs, {
            color: strokeColor,
            fillColor: strokeColor,
            fillOpacity: 0.35,
            weight: 2,
          }).addTo(map);

          poly.bindPopup(popupContent);
        }
      });
    };

    document.body.appendChild(script);
    return () => {
      try { document.head.removeChild(link); } catch {}
      try { document.body.removeChild(script); } catch {}
    };
  }, [activeTab]);

  async function triggerSync(projectId: string) {
    setSyncingId(projectId);
    setSyncLogs(["[API Gateway] Handshaking with MoRTH Bhoomi Rashi Gazette & e-Courts NJDG gateway..."]);
    setSyncComplete(false);
    try {
      const res = await fetch("/api/external-sync", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ projectId, district }),
      });
      if (res.ok) {
        const data = await res.json();
        for (let i = 0; i < data.logs.length; i++) {
          await new Promise((r) => setTimeout(r, 380));
          setSyncLogs((prev) => [...prev, data.logs[i]]);
        }
        setSyncComplete(true);
        await loadData();
      } else {
        const errData = await res.json();
        setSyncLogs((prev) => [...prev, `[Error] ${errData.error || "Sync failed"}`]);
      }
    } catch (err: any) {
      setSyncLogs((prev) => [...prev, `[Error] Ingestion failed: ${err.message}`]);
    }
  }

  function handleDirectiveIssued(item: DirectiveItem) {
    setIssuedDirectives((prev) => [item, ...prev]);
  }

  const criticalCount = projects.filter((p) => p.result.riskLevel === "CRITICAL").length;
  const highCount = projects.filter((p) => p.result.riskLevel === "HIGH").length;
  const totalPending = projects.reduce((acc, p) => acc + p.pendingFamiliesCount, 0);

  return (
    <DashboardLayout>
      <main className="py-8 px-6 font-sans text-slate-100 min-h-screen">
        <div className="max-w-4xl mx-auto space-y-6">
          {/* Collector Header */}
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-slate-800 pb-4">
            <div>
              <p className="text-xs font-mono font-bold text-indigo-400 uppercase tracking-widest mb-1">
                District Collector Command · {district}
              </p>
              <h1 className="text-3xl font-black text-white tracking-tight">Collector Early Warning Command</h1>
              <p className="text-xs text-slate-400 mt-1">
                Multi-Horizon Predictive Analytics, Right-of-Way GIS Corridors &amp; Administrative Orders
              </p>
            </div>
            <div className="flex items-center gap-3">
              <div className="inline-flex rounded-xl bg-slate-900 p-1 border border-slate-800">
                <button onClick={() => setActiveTab("cards")} className={`rounded-lg px-3 py-1.5 text-xs font-semibold transition ${activeTab === "cards" ? "bg-indigo-600 text-white shadow-sm" : "text-slate-400 hover:text-slate-200"}`}>List View</button>
                <button onClick={() => setActiveTab("map")} className={`rounded-lg px-3 py-1.5 text-xs font-semibold transition ${activeTab === "map" ? "bg-indigo-600 text-white shadow-sm" : "text-slate-400 hover:text-slate-200"}`}>RoW GIS Alignment Map</button>
              </div>
              <Link href="/projects/new" className="bg-indigo-600 hover:bg-indigo-500 text-white text-xs px-4 py-2 rounded-xl font-bold transition shadow-lg shadow-indigo-600/25">+ New Project</Link>
            </div>
          </div>

          {/* Metric Strips */}
          {projects.length > 0 && (
            <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
              <div className="bg-slate-900 p-4 rounded-xl border border-slate-800">
                <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider font-mono">Total Corridors</p>
                <p className="text-2xl font-black text-white mt-1">{projects.length}</p>
                <p className="text-[10px] text-slate-400">Active in {district}</p>
              </div>
              <div className={`p-4 rounded-xl border ${criticalCount > 0 ? "bg-red-950/40 border-red-800/60" : "bg-slate-900 border-slate-800"}`}>
                <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider font-mono">Critical Risk</p>
                <p className={`text-2xl font-black mt-1 ${criticalCount > 0 ? "text-red-400" : "text-white"}`}>{criticalCount}</p>
                <p className="text-[10px] text-slate-400">Immediate order needed</p>
              </div>
              <div className={`p-4 rounded-xl border ${highCount > 0 ? "bg-amber-950/40 border-amber-800/60" : "bg-slate-900 border-slate-800"}`}>
                <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider font-mono">High Risk</p>
                <p className={`text-2xl font-black mt-1 ${highCount > 0 ? "text-amber-400" : "text-white"}`}>{highCount}</p>
                <p className="text-[10px] text-slate-400">Attention in 30 days</p>
              </div>
              <div className={`p-4 rounded-xl border ${totalPending > 0 ? "bg-indigo-950/40 border-indigo-800/60" : "bg-slate-900 border-slate-800"}`}>
                <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider font-mono">Pending LAO Audit</p>
                <p className={`text-2xl font-black mt-1 ${totalPending > 0 ? "text-indigo-400" : "text-white"}`}>{totalPending}</p>
                <p className="text-[10px] text-slate-400">Family entries unverified</p>
              </div>
            </div>
          )}

          {/* Active Directives Hub with Resolution Details */}
          {issuedDirectives.length > 0 && (
            <div className="bg-slate-900 border border-slate-800 rounded-2xl p-5 shadow-xl space-y-3">
              <div className="flex justify-between items-center border-b border-slate-800 pb-2">
                <span className="text-xs font-mono font-bold text-amber-400 flex items-center gap-2">
                  <span>📢</span> Collector Directives &amp; Field Execution Log ({issuedDirectives.length})
                </span>
                <span className="text-[10px] text-slate-400 font-mono">Live tracking across LAO &amp; Patwari inboxes</span>
              </div>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-2 text-xs font-mono">
                {issuedDirectives.slice(0, 4).map((d: any) => (
                  <div key={d.id} className="bg-slate-950 p-3 rounded-xl border border-slate-800 flex flex-col justify-between">
                    <div>
                      <div className="flex items-center justify-between">
                        <p className="font-bold text-white leading-tight">{d.title}</p>
                        <span className={`text-[9px] px-2 py-0.5 rounded-full font-bold uppercase ${
                          d.status === "RESOLVED" ? "bg-emerald-500/20 text-emerald-400" : d.status === "IN_PROGRESS" ? "bg-sky-500/20 text-sky-400" : "bg-amber-500/20 text-amber-400"
                        }`}>
                          {d.status}
                        </span>
                      </div>
                      <p className="text-[10px] text-slate-400 mt-0.5">Project: {d.projectName} · To: {d.assignedTo}</p>
                      {d.resolutionNote && (
                        <div className="mt-2 p-2 bg-emerald-950/30 border border-emerald-800/40 rounded-lg text-[10px] text-emerald-300">
                          <span className="font-bold">✓ Resolution by {d.resolvedBy || "Field Team"}:</span> {d.resolutionNote}
                        </div>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {loading && (
            <div className="text-center py-20 bg-slate-900 rounded-2xl border border-slate-800">
              <div className="w-8 h-8 border-4 border-indigo-500 border-t-transparent rounded-full animate-spin mx-auto" />
              <p className="text-xs text-slate-400 mt-4 font-mono">Fetching {district} project telemetry &amp; survival distributions...</p>
            </div>
          )}

          {/* Sync Console */}
          {syncingId && (
            <div className="bg-slate-900 text-slate-100 p-5 rounded-2xl border border-slate-800 font-mono text-xs shadow-inner space-y-2">
              <div className="flex justify-between items-center border-b border-slate-800 pb-2">
                <span className="text-indigo-400 font-bold">● GOV_PORTALS_SYNC_STREAM — {district}</span>
                <button onClick={() => setSyncingId(null)} className="text-slate-400 hover:text-white font-semibold">Close</button>
              </div>
              <div className="space-y-1 max-h-[160px] overflow-y-auto">
                {syncLogs.map((log, idx) => (
                  <p key={idx} className={log.includes("[Error]") ? "text-red-400" : log.includes("Successfully") ? "text-emerald-400" : "text-slate-300"}>{log}</p>
                ))}
                {!syncComplete && <span className="inline-block w-2 h-4 bg-indigo-500 animate-pulse ml-0.5" />}
              </div>
            </div>
          )}

          {/* Projects Cards List */}
          {!loading && activeTab === "cards" && projects.length > 0 && (
            <div className="space-y-8">
              {projects.map(({ project, metrics, result, source, pendingFamiliesCount }) => (
                <div key={project.id} className="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl space-y-4">
                  {/* LAO Pending Alert */}
                  {pendingFamiliesCount > 0 && (
                    <div className="bg-amber-950/40 border border-amber-800/60 rounded-xl px-4 py-2 text-xs text-amber-200 flex justify-between items-center">
                      <span>⚠ <b>{pendingFamiliesCount} entries</b> awaiting LAO / Tehsildar verification.</span>
                      <span className="text-[10px] text-amber-400 font-mono">Assigned to LAO Queue</span>
                    </div>
                  )}

                  {/* Header Strip with Action Buttons */}
                  <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-slate-800 pb-4">
                    <div>
                      <span className={`inline-block text-[10px] font-mono font-bold px-2.5 py-0.5 rounded-full mb-1 ${source === "ml" ? "bg-indigo-500/20 text-indigo-300 border border-indigo-500/30" : "bg-slate-800 text-slate-400"}`}>
                        {source === "ml" ? "⚡ ML Model (Random Forest + CPH)" : "Rule-Based Engine"}
                      </span>
                      <h2 className="text-xl font-black text-white">{project.project_name}</h2>
                      <p className="text-xs text-slate-400 font-mono mt-0.5">{project.project_type} · {project.district} · {project.villages_affected}</p>
                    </div>

                    {/* Actions Toolbar */}
                    <div className="flex flex-wrap gap-2">
                      <button
                        onClick={() => setSimulatingProject({ project, metrics })}
                        className="bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-bold px-3 py-1.5 rounded-lg transition flex items-center gap-1 shadow-md shadow-indigo-600/20"
                      >
                        <span>⚡ What-If Simulator</span>
                      </button>
                      <button
                        onClick={() => setExpandedSurvivalId(expandedSurvivalId === project.id ? null : project.id)}
                        className="bg-sky-600/20 hover:bg-sky-600/30 text-sky-300 border border-sky-500/30 text-xs font-bold px-3 py-1.5 rounded-lg transition"
                      >
                        {expandedSurvivalId === project.id ? "Hide Survival Curve" : "📈 Survival Curve"}
                      </button>
                      <button
                        onClick={() => setDirectingProject(project)}
                        className="bg-amber-600/20 hover:bg-amber-600/30 text-amber-300 border border-amber-500/30 text-xs font-bold px-3 py-1.5 rounded-lg transition"
                      >
                        📜 Issue Directive
                      </button>
                      <button
                        onClick={() => triggerSync(project.id)}
                        disabled={syncingId !== null}
                        className="bg-slate-800 hover:bg-slate-700 text-slate-300 text-xs font-bold px-3 py-1.5 rounded-lg transition disabled:opacity-50"
                      >
                        Sync Portals
                      </button>
                    </div>
                  </div>

                  {/* Primary Risk Card */}
                  <RiskCard projectName={project.project_name} result={result} />

                  {/* Expandable Survival & Kaplan-Meier Card */}
                  {expandedSurvivalId === project.id && (
                    <div className="animate-fade-in pt-2">
                      <SurvivalAnalysisCard result={result} projectName={project.project_name} />
                    </div>
                  )}

                  {/* Executive Metadata */}
                  <div className="flex justify-between items-center pt-2 border-t border-slate-800 text-[11px] font-mono text-slate-400">
                    <span>Corridor: <b>{project.total_land_area_hectares} Ha</b></span>
                    <span>Target Handover: <b>{project.target_handover_date}</b></span>
                    <span>Clearance: <b className={project.forest_clearance === "Yes" ? "text-amber-400" : "text-emerald-400"}>{project.forest_clearance}</b></span>
                  </div>
                </div>
              ))}
            </div>
          )}

          {/* GIS Alignment Map View */}
          {!loading && activeTab === "map" && (
            <div className="bg-slate-900 rounded-2xl border border-slate-800 p-5 space-y-3 shadow-2xl">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 border-b border-slate-800 pb-3">
                <div>
                  <h3 className="text-sm font-black text-white font-mono uppercase tracking-wide">
                    {district} Right-of-Way (RoW) Land Acquisition Alignment Grid
                  </h3>
                  <p className="text-xs text-slate-400 mt-0.5">
                    Interactive corridor alignment buffer strips &amp; parcel polygons showing exact land requirements and dispute hotspots.
                  </p>
                </div>
                <div className="flex items-center gap-3 text-[10px] font-mono shrink-0">
                  <span className="flex items-center gap-1"><span className="w-2.5 h-2.5 rounded-full bg-red-500"></span> Critical (Stay/Objection)</span>
                  <span className="flex items-center gap-1"><span className="w-2.5 h-2.5 rounded-full bg-amber-500"></span> High Risk</span>
                  <span className="flex items-center gap-1"><span className="w-2.5 h-2.5 rounded-full bg-emerald-500"></span> Acquired / Low Risk</span>
                </div>
              </div>
              <div id="dashboard-map" className="w-full h-[520px] bg-slate-950 rounded-xl border border-slate-800 overflow-hidden shadow-inner" />
            </div>
          )}
        </div>

        {/* What-If Simulator Modal */}
        {simulatingProject && (
          <div className="fixed inset-0 bg-black/80 backdrop-blur-sm z-50 flex items-center justify-center p-4">
            <div className="max-w-2xl w-full">
              <WhatIfSimulator
                baseMetrics={simulatingProject.metrics}
                projectName={simulatingProject.project.project_name}
                onClose={() => setSimulatingProject(null)}
              />
            </div>
          </div>
        )}

        {/* Directives Modal */}
        {directingProject && (
          <DirectivesModal
            projectId={directingProject.id}
            projectName={directingProject.project_name}
            onClose={() => setDirectingProject(null)}
            onDirectiveIssued={handleDirectiveIssued}
          />
        )}
      </main>
    </DashboardLayout>
  );
}
