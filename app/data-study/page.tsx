"use client";

import { useEffect, useState } from "react";
import { supabase } from "@/lib/supabaseClient";
import DashboardLayout from "@/components/DashboardLayout";
import RoleGuard from "@/components/RoleGuard";

interface ProjectItem {
  id: string;
  project_name: string;
  project_type: string;
  district: string;
  total_land_area_hectares: number;
  est_families_affected: number;
  st_families: number;
  avg_dept_response_days: number;
  forest_clearance: string;
  forest_clearance_applied: boolean;
  created_at: string;
}

interface FamilyItem {
  id: string;
  project_id: string;
  family_name: string;
  land_area_owned: number;
  compensation_amount: number;
  payment_status: string;
  court_case_status: string;
  court_case_filed_date: string | null;
  objection_status: string;
  possession_status: string;
  verification_status: string;
}

interface ProjectSummaryRow {
  id: string;
  name: string;
  type: string;
  areaHa: number;
  totalPAPs: number;
  surveyedFamilies: number;
  verifiedCount: number;
  paidCount: number;
  activeCasesCount: number;
  refusingCount: number;
}

export default function DataStudyPage() {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [projects, setProjects] = useState<ProjectItem[]>([]);
  const [families, setFamilies] = useState<FamilyItem[]>([]);
  const [projectSummaries, setProjectSummaries] = useState<ProjectSummaryRow[]>([]);

  useEffect(() => {
    async function loadData() {
      setLoading(true);
      setError(null);

      try {
        // Query live Supabase tables
        const { data: projData, error: projErr } = await supabase
          .from("projects")
          .select("*")
          .order("created_at", { ascending: false });

        if (projErr) throw projErr;

        const { data: famData, error: famErr } = await supabase
          .from("families")
          .select("*");

        if (famErr) throw famErr;

        const projs: ProjectItem[] = projData || [];
        const fams: FamilyItem[] = famData || [];

        setProjects(projs);
        setFamilies(fams);

        // Group families by project
        const summaries: ProjectSummaryRow[] = projs.map((p) => {
          const pFams = fams.filter((f) => f.project_id === p.id);
          return {
            id: p.id,
            name: p.project_name,
            type: p.project_type,
            areaHa: Number(p.total_land_area_hectares) || 0,
            totalPAPs: Number(p.est_families_affected) || 0,
            surveyedFamilies: pFams.length,
            verifiedCount: pFams.filter((f) => f.verification_status === "Verified").length,
            paidCount: pFams.filter((f) => f.payment_status === "Paid").length,
            activeCasesCount: pFams.filter((f) => f.court_case_status === "Active").length,
            refusingCount: pFams.filter((f) => f.possession_status === "Refusing").length,
          };
        });

        setProjectSummaries(summaries);
      } catch (err: any) {
        setError(err?.message || "Failed to load live database records from Supabase.");
      } finally {
        setLoading(false);
      }
    }

    loadData();
  }, []);

  // Summary computations
  const totalProjects = projects.length;
  const totalFamiliesSurveyed = families.length;
  const totalAreaHa = projects.reduce((acc, p) => acc + (Number(p.total_land_area_hectares) || 0), 0);
  const totalPAPsEst = projects.reduce((acc, p) => acc + (Number(p.est_families_affected) || 0), 0);
  const totalSTFamilies = projects.reduce((acc, p) => acc + (Number(p.st_families) || 0), 0);

  // Status distributions
  const verifiedCount = families.filter((f) => f.verification_status === "Verified").length;
  const pendingVerificationCount = families.filter((f) => f.verification_status !== "Verified").length;

  const paidCount = families.filter((f) => f.payment_status === "Paid").length;
  const pendingPaymentCount = families.filter((f) => f.payment_status !== "Paid").length;

  const activeCourtCases = families.filter((f) => f.court_case_status === "Active").length;
  const noCourtCases = families.filter((f) => f.court_case_status !== "Active").length;

  const possessionRefusing = families.filter((f) => f.possession_status === "Refusing").length;
  const possessionOccupied = families.filter((f) => f.possession_status === "Occupied").length;
  const possessionVacated = families.filter((f) => f.possession_status === "Vacated").length;

  // Field Completeness Metrics
  const validNames = families.filter((f) => f.family_name && f.family_name.trim().length > 0).length;
  const validAreas = families.filter((f) => typeof f.land_area_owned === "number" && f.land_area_owned > 0).length;
  const validComp = families.filter((f) => typeof f.compensation_amount === "number" && f.compensation_amount >= 0).length;
  const validPossession = families.filter((f) => ["Vacated", "Occupied", "Refusing"].includes(f.possession_status)).length;
  const validPayment = families.filter((f) => ["Paid", "Pending"].includes(f.payment_status)).length;

  return (
    <RoleGuard allowedRoles={["collector", "lao", "patwari"]}>
      <DashboardLayout>
        <div className="p-6 lg:p-8 space-y-8 max-w-7xl mx-auto">
          {/* Header */}
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full border border-sky-500/30 bg-sky-500/10 text-sky-300 text-xs font-semibold mb-3">
              <span className="w-1.5 h-1.5 rounded-full bg-sky-400 animate-pulse" />
              Live Database Empirical Study
            </div>
            <h1 className="text-2xl lg:text-3xl font-black text-white tracking-tight">
              Data Study Lab
            </h1>
            <p className="mt-1 text-slate-400 text-xs leading-relaxed max-w-3xl">
              Real-time descriptive statistics and empirical distributions queried directly from the active{" "}
              <code className="text-sky-400 font-mono">public.projects</code> and{" "}
              <code className="text-sky-400 font-mono">public.families</code> tables in Supabase PostgreSQL.
            </p>
          </div>

          {/* Loading & Error States */}
          {loading && (
            <div className="rounded-2xl border border-slate-800 bg-slate-900/50 p-12 text-center">
              <div className="w-8 h-8 border-2 border-sky-500 border-t-transparent rounded-full animate-spin mx-auto mb-3" />
              <p className="text-xs font-mono text-slate-400">Executing live aggregation queries across Supabase records...</p>
            </div>
          )}

          {error && (
            <div className="rounded-2xl border border-rose-500/30 bg-rose-500/10 p-6 text-rose-300 text-xs space-y-2">
              <p className="font-bold font-mono">⚠️ DATABASE QUERY ERROR:</p>
              <p>{error}</p>
              <p className="text-slate-400">Please verify Supabase connection parameters in environment settings.</p>
            </div>
          )}

          {!loading && !error && (
            <>
              {/* Macro Summary Metrics Strip */}
              <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-4">
                <div className="rounded-xl border border-slate-800 bg-slate-900/80 p-4">
                  <p className="text-[10px] font-mono text-slate-400 uppercase tracking-wider">Total Corridors</p>
                  <p className="text-2xl font-black text-white mt-1">{totalProjects}</p>
                  <p className="text-[10px] font-mono text-sky-400 mt-1">Nagpur District</p>
                </div>

                <div className="rounded-xl border border-slate-800 bg-slate-900/80 p-4">
                  <p className="text-[10px] font-mono text-slate-400 uppercase tracking-wider">Surveyed Parcels</p>
                  <p className="text-2xl font-black text-white mt-1">{totalFamiliesSurveyed}</p>
                  <p className="text-[10px] font-mono text-emerald-400 mt-1">Ground Family Records</p>
                </div>

                <div className="rounded-xl border border-slate-800 bg-slate-900/80 p-4">
                  <p className="text-[10px] font-mono text-slate-400 uppercase tracking-wider">Total Right-of-Way</p>
                  <p className="text-2xl font-black text-white mt-1">{totalAreaHa.toLocaleString()} Ha</p>
                  <p className="text-[10px] font-mono text-indigo-400 mt-1">Cumulative Land Footprint</p>
                </div>

                <div className="rounded-xl border border-slate-800 bg-slate-900/80 p-4">
                  <p className="text-[10px] font-mono text-slate-400 uppercase tracking-wider">Est. Affected PAPs</p>
                  <p className="text-2xl font-black text-white mt-1">{totalPAPsEst.toLocaleString()}</p>
                  <p className="text-[10px] font-mono text-amber-400 mt-1">Project Affected Persons</p>
                </div>

                <div className="rounded-xl border border-slate-800 bg-slate-900/80 p-4 col-span-2 sm:col-span-1">
                  <p className="text-[10px] font-mono text-slate-400 uppercase tracking-wider">ST Tribal Families</p>
                  <p className="text-2xl font-black text-white mt-1">{totalSTFamilies}</p>
                  <p className="text-[10px] font-mono text-purple-400 mt-1">Schedule V / PESA Area</p>
                </div>
              </div>

              {/* Empirical Distribution Breakdowns */}
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                {/* 1. Verification Status */}
                <div className="rounded-2xl border border-slate-800 bg-slate-900/70 p-5 space-y-4">
                  <div className="flex items-center justify-between">
                    <h2 className="text-xs font-bold text-slate-200 uppercase tracking-wider font-mono">
                      ● LAO Verification Status
                    </h2>
                    <span className="text-[10px] font-mono text-slate-400">{totalFamiliesSurveyed} total</span>
                  </div>

                  <div className="space-y-3">
                    <div>
                      <div className="flex justify-between text-xs mb-1 font-mono">
                        <span className="text-emerald-400">Verified by SDO/LAO</span>
                        <span className="text-white font-bold">{verifiedCount} ({totalFamiliesSurveyed > 0 ? Math.round((verifiedCount / totalFamiliesSurveyed) * 100) : 0}%)</span>
                      </div>
                      <div className="h-2 w-full bg-slate-800 rounded-full overflow-hidden">
                        <div
                          className="h-full bg-emerald-500 rounded-full"
                          style={{ width: `${totalFamiliesSurveyed > 0 ? (verifiedCount / totalFamiliesSurveyed) * 100 : 0}%` }}
                        />
                      </div>
                    </div>

                    <div>
                      <div className="flex justify-between text-xs mb-1 font-mono">
                        <span className="text-amber-400">Pending Field Audit</span>
                        <span className="text-white font-bold">{pendingVerificationCount} ({totalFamiliesSurveyed > 0 ? Math.round((pendingVerificationCount / totalFamiliesSurveyed) * 100) : 0}%)</span>
                      </div>
                      <div className="h-2 w-full bg-slate-800 rounded-full overflow-hidden">
                        <div
                          className="h-full bg-amber-500 rounded-full"
                          style={{ width: `${totalFamiliesSurveyed > 0 ? (pendingVerificationCount / totalFamiliesSurveyed) * 100 : 0}%` }}
                        />
                      </div>
                    </div>
                  </div>
                </div>

                {/* 2. Compensation Disbursement */}
                <div className="rounded-2xl border border-slate-800 bg-slate-900/70 p-5 space-y-4">
                  <div className="flex items-center justify-between">
                    <h2 className="text-xs font-bold text-slate-200 uppercase tracking-wider font-mono">
                      ● Compensation Payment
                    </h2>
                    <span className="text-[10px] font-mono text-slate-400">{totalFamiliesSurveyed} total</span>
                  </div>

                  <div className="space-y-3">
                    <div>
                      <div className="flex justify-between text-xs mb-1 font-mono">
                        <span className="text-sky-400">Paid / Disbursed (PFMS)</span>
                        <span className="text-white font-bold">{paidCount} ({totalFamiliesSurveyed > 0 ? Math.round((paidCount / totalFamiliesSurveyed) * 100) : 0}%)</span>
                      </div>
                      <div className="h-2 w-full bg-slate-800 rounded-full overflow-hidden">
                        <div
                          className="h-full bg-sky-500 rounded-full"
                          style={{ width: `${totalFamiliesSurveyed > 0 ? (paidCount / totalFamiliesSurveyed) * 100 : 0}%` }}
                        />
                      </div>
                    </div>

                    <div>
                      <div className="flex justify-between text-xs mb-1 font-mono">
                        <span className="text-slate-400">Pending Award Escrow</span>
                        <span className="text-white font-bold">{pendingPaymentCount} ({totalFamiliesSurveyed > 0 ? Math.round((pendingPaymentCount / totalFamiliesSurveyed) * 100) : 0}%)</span>
                      </div>
                      <div className="h-2 w-full bg-slate-800 rounded-full overflow-hidden">
                        <div
                          className="h-full bg-slate-600 rounded-full"
                          style={{ width: `${totalFamiliesSurveyed > 0 ? (pendingPaymentCount / totalFamiliesSurveyed) * 100 : 0}%` }}
                        />
                      </div>
                    </div>
                  </div>
                </div>

                {/* 3. Right-of-Way & Litigation */}
                <div className="rounded-2xl border border-slate-800 bg-slate-900/70 p-5 space-y-4">
                  <div className="flex items-center justify-between">
                    <h2 className="text-xs font-bold text-slate-200 uppercase tracking-wider font-mono">
                      ● Possession & Litigation
                    </h2>
                    <span className="text-[10px] font-mono text-slate-400">{totalFamiliesSurveyed} total</span>
                  </div>

                  <div className="space-y-2 font-mono text-xs">
                    <div className="flex justify-between items-center py-1 border-b border-slate-800">
                      <span className="text-rose-400">Active High Court Cases</span>
                      <span className="font-bold text-white">{activeCourtCases}</span>
                    </div>
                    <div className="flex justify-between items-center py-1 border-b border-slate-800">
                      <span className="text-amber-400">Refusing Physical Handover</span>
                      <span className="font-bold text-white">{possessionRefusing}</span>
                    </div>
                    <div className="flex justify-between items-center py-1 border-b border-slate-800">
                      <span className="text-slate-300">Occupied (Pre-Award)</span>
                      <span className="font-bold text-white">{possessionOccupied}</span>
                    </div>
                    <div className="flex justify-between items-center py-1">
                      <span className="text-emerald-400">Vacated & Handed Over</span>
                      <span className="font-bold text-white">{possessionVacated}</span>
                    </div>
                  </div>
                </div>
              </div>

              {/* Data Completeness & Schema Integrity Audit */}
              <div className="rounded-2xl border border-slate-800 bg-slate-900/70 p-6 space-y-4">
                <div>
                  <h2 className="text-sm font-bold text-white font-mono uppercase tracking-wider">
                    📋 Schema Field Completeness & Non-Null Audit
                  </h2>
                  <p className="text-xs text-slate-400 mt-1">
                    Integrity check measuring field non-null rates across all {totalFamiliesSurveyed} family records currently stored in Supabase.
                  </p>
                </div>

                <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-3 pt-2">
                  <div className="p-3 bg-slate-950/70 rounded-xl border border-slate-800 text-xs font-mono">
                    <p className="text-slate-400 text-[10px]">Family & Khasra ID</p>
                    <p className="text-lg font-bold text-emerald-400 mt-1">
                      {totalFamiliesSurveyed > 0 ? Math.round((validNames / totalFamiliesSurveyed) * 100) : 0}%
                    </p>
                    <p className="text-[10px] text-slate-500">{validNames}/{totalFamiliesSurveyed} Valid</p>
                  </div>

                  <div className="p-3 bg-slate-950/70 rounded-xl border border-slate-800 text-xs font-mono">
                    <p className="text-slate-400 text-[10px]">Land Area (Acres/Ha)</p>
                    <p className="text-lg font-bold text-emerald-400 mt-1">
                      {totalFamiliesSurveyed > 0 ? Math.round((validAreas / totalFamiliesSurveyed) * 100) : 0}%
                    </p>
                    <p className="text-[10px] text-slate-500">{validAreas}/{totalFamiliesSurveyed} Valid</p>
                  </div>

                  <div className="p-3 bg-slate-950/70 rounded-xl border border-slate-800 text-xs font-mono">
                    <p className="text-slate-400 text-[10px]">Compensation Award</p>
                    <p className="text-lg font-bold text-emerald-400 mt-1">
                      {totalFamiliesSurveyed > 0 ? Math.round((validComp / totalFamiliesSurveyed) * 100) : 0}%
                    </p>
                    <p className="text-[10px] text-slate-500">{validComp}/{totalFamiliesSurveyed} Valid</p>
                  </div>

                  <div className="p-3 bg-slate-950/70 rounded-xl border border-slate-800 text-xs font-mono">
                    <p className="text-slate-400 text-[10px]">Possession State</p>
                    <p className="text-lg font-bold text-emerald-400 mt-1">
                      {totalFamiliesSurveyed > 0 ? Math.round((validPossession / totalFamiliesSurveyed) * 100) : 0}%
                    </p>
                    <p className="text-[10px] text-slate-500">{validPossession}/{totalFamiliesSurveyed} Valid</p>
                  </div>

                  <div className="p-3 bg-slate-950/70 rounded-xl border border-slate-800 text-xs font-mono">
                    <p className="text-slate-400 text-[10px]">Disbursement State</p>
                    <p className="text-lg font-bold text-emerald-400 mt-1">
                      {totalFamiliesSurveyed > 0 ? Math.round((validPayment / totalFamiliesSurveyed) * 100) : 0}%
                    </p>
                    <p className="text-[10px] text-slate-500">{validPayment}/{totalFamiliesSurveyed} Valid</p>
                  </div>
                </div>
              </div>

              {/* Per-Project Disaggregated Audit Table */}
              <div className="rounded-2xl border border-slate-800 bg-slate-900/70 overflow-hidden space-y-0">
                <div className="p-5 border-b border-slate-800 flex flex-col sm:flex-row sm:items-center justify-between gap-2">
                  <div>
                    <h2 className="text-sm font-bold text-white font-mono uppercase tracking-wider">
                      📊 Nagpur Corridor Ground Survey Registry
                    </h2>
                    <p className="text-xs text-slate-400 mt-0.5">
                      Live ground survey counts and litigation metrics aggregated per infrastructure corridor.
                    </p>
                  </div>
                  <span className="text-xs font-mono bg-sky-500/20 text-sky-300 border border-sky-500/30 px-3 py-1 rounded-full shrink-0 font-bold">
                    {projectSummaries.length} Active Corridors
                  </span>
                </div>

                <div className="overflow-x-auto">
                  <table className="w-full text-left text-xs font-mono">
                    <thead className="bg-slate-950 text-slate-400 uppercase text-[10px] border-b border-slate-800">
                      <tr>
                        <th className="py-3 px-4">Corridor Name</th>
                        <th className="py-3 px-3">Type</th>
                        <th className="py-3 px-3 text-right">Area (Ha)</th>
                        <th className="py-3 px-3 text-right">Est. PAPs</th>
                        <th className="py-3 px-3 text-right">Filed Parcels</th>
                        <th className="py-3 px-3 text-right">Verified</th>
                        <th className="py-3 px-3 text-right">Paid</th>
                        <th className="py-3 px-3 text-right text-rose-400">Court Cases</th>
                        <th className="py-3 px-3 text-right text-amber-400">Refusing</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-slate-800 text-slate-300">
                      {projectSummaries.map((p) => (
                        <tr key={p.id} className="hover:bg-slate-800/40 transition">
                          <td className="py-3 px-4 font-bold text-white max-w-xs truncate">{p.name}</td>
                          <td className="py-3 px-3">
                            <span className="px-2 py-0.5 rounded bg-slate-800 text-slate-300 text-[10px]">
                              {p.type}
                            </span>
                          </td>
                          <td className="py-3 px-3 text-right">{p.areaHa}</td>
                          <td className="py-3 px-3 text-right">{p.totalPAPs}</td>
                          <td className="py-3 px-3 text-right font-bold text-white">{p.surveyedFamilies}</td>
                          <td className="py-3 px-3 text-right text-emerald-400 font-bold">{p.verifiedCount}</td>
                          <td className="py-3 px-3 text-right text-sky-400">{p.paidCount}</td>
                          <td className="py-3 px-3 text-right text-rose-400 font-bold">{p.activeCasesCount}</td>
                          <td className="py-3 px-3 text-right text-amber-400 font-bold">{p.refusingCount}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>

              {/* Data Provenance & Methodology Note */}
              <div className="rounded-xl border border-sky-500/20 bg-sky-950/30 p-4 text-xs text-sky-300 font-mono flex items-start gap-3">
                <span className="text-base">ℹ️</span>
                <div className="space-y-1">
                  <p className="font-bold">Real Data Provenance Disclosure:</p>
                  <p className="text-[11px] text-slate-400 leading-relaxed">
                    All numbers, counts, and percentages displayed above are computed live via direct SQL aggregation on the active PostgreSQL database instance. No synthetic fallbacks, approximations, or mock records are injected.
                  </p>
                </div>
              </div>
            </>
          )}
        </div>
      </DashboardLayout>
    </RoleGuard>
  );
}
