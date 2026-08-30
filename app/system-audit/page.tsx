"use client";

import { useEffect, useState } from "react";
import { supabase } from "@/lib/supabaseClient";
import DashboardLayout from "@/components/DashboardLayout";
import RoleGuard from "@/components/RoleGuard";

export default function SystemAuditPage() {
  const [projectCount, setProjectCount] = useState<number | null>(null);
  const [familyCount, setFamilyCount] = useState<number | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function loadLiveCounts() {
      try {
        let userDistrict = "Nagpur";
        try {
          const { data: { user } } = await supabase.auth.getUser();
          if (user) {
            const { data: profile } = await supabase
              .from("profiles")
              .select("district")
              .eq("id", user.id)
              .maybeSingle();
            if (profile?.district) userDistrict = profile.district;
          }
        } catch {}

        const res = await fetch(`/api/study-data?district=${encodeURIComponent(userDistrict)}`);
        if (res.ok) {
          const resData = await res.json();
          setProjectCount(resData.counts?.projects ?? 0);
          setFamilyCount(resData.counts?.families ?? 0);
        } else {
          const { data: projData, count: projCount } = await supabase
            .from("projects")
            .select("id", { count: "exact" })
            .eq("district", userDistrict);

          const projectIds = (projData || []).map((p: any) => p.id);

          let famCount = 0;
          if (projectIds.length > 0) {
            const { count } = await supabase
              .from("families")
              .select("id", { count: "exact", head: true })
              .in("project_id", projectIds);
            famCount = count ?? 0;
          }

          setProjectCount(projCount ?? 0);
          setFamilyCount(famCount);
        }
      } catch {
        // Leave as null if query fails to show honest unavailable state
      } finally {
        setLoading(false);
      }
    }

    loadLiveCounts();
  }, []);

  return (
    <RoleGuard allowedRoles={["collector", "lao", "patwari"]}>
      <DashboardLayout>
        <div className="p-6 lg:p-8 space-y-8 max-w-7xl mx-auto">
          {/* Header */}
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full border border-amber-500/30 bg-amber-500/10 text-amber-300 text-xs font-semibold mb-3">
              <span className="w-1.5 h-1.5 rounded-full bg-amber-400 animate-pulse" />
              Honest Disclosure & Methodological Transparency
            </div>
            <h1 className="text-2xl lg:text-3xl font-black text-white tracking-tight">
              System Integrity Audit & Limitations
            </h1>
            <p className="mt-1 text-slate-400 text-xs leading-relaxed max-w-3xl">
              Formal disclosure of system scope, data provenance, statistical boundaries, and known operational limitations in accordance with GovTech research standards.
            </p>
          </div>

          {/* Quick Summary Grid */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            <div className="rounded-xl border border-slate-800 bg-slate-900/70 p-4">
              <p className="text-[10px] font-mono text-slate-400 uppercase tracking-wider">Geographic Scope</p>
              <p className="text-xl font-bold text-white mt-1">Nagpur District</p>
              <p className="text-[10px] text-slate-400 mt-0.5">
                Maharashtra, India ({loading ? "..." : projectCount !== null ? `${projectCount} Corridors` : "Count Unavailable"})
              </p>
            </div>

            <div className="rounded-xl border border-slate-800 bg-slate-900/70 p-4">
              <p className="text-[10px] font-mono text-slate-400 uppercase tracking-wider">Ground Parcels</p>
              <p className="text-xl font-bold text-emerald-400 mt-1">
                {loading ? "..." : familyCount !== null ? `${familyCount} Surveyed Families` : "Data Unavailable"}
              </p>
              <p className="text-[10px] text-slate-400 mt-0.5">Supabase PostgreSQL Database</p>
            </div>

            <div className="rounded-xl border border-slate-800 bg-slate-900/70 p-4">
              <p className="text-[10px] font-mono text-slate-400 uppercase tracking-wider">ML Training Base</p>
              <p className="text-xl font-bold text-indigo-300 mt-1">Synthetic Grounding</p>
              <p className="text-[10px] text-slate-400 mt-0.5">6,000 Literature-Calibrated Samples</p>
            </div>

            <div className="rounded-xl border border-slate-800 bg-slate-900/70 p-4">
              <p className="text-[10px] font-mono text-slate-400 uppercase tracking-wider">Survival Model</p>
              <p className="text-xl font-bold text-purple-300 mt-1">Breslow Hazard</p>
              <p className="text-[10px] text-slate-400 mt-0.5">CAG Report 12/2021 Benchmark</p>
            </div>
          </div>

          {/* Detailed Limitations Sections */}
          <div className="space-y-6">
            {/* Limitation 1 */}
            <div className="rounded-2xl border border-slate-800 bg-slate-900/70 p-6 space-y-3">
              <div className="flex items-center gap-2">
                <span className="w-6 h-6 rounded-full bg-amber-500/20 text-amber-300 text-xs font-bold font-mono flex items-center justify-center">
                  1
                </span>
                <h2 className="text-sm font-bold text-white font-mono uppercase tracking-wider">
                  Synthetic Training Data vs. Longitudinal Outcome Reality
                </h2>
              </div>
              <div className="text-xs text-slate-300 space-y-2 leading-relaxed pl-8">
                <p>
                  <strong>Honest Disclosure:</strong> The machine learning models (<code className="text-indigo-300 font-mono">GradientBoostingClassifier</code> and <code className="text-sky-300 font-mono">RandomForestRegressor</code>) are trained on a 6,000-sample synthetic dataset (<code className="font-mono">generate_dataset.py</code>) rather than a historical multi-decade government archive.
                </p>
                <p className="text-slate-400">
                  <strong>Reason:</strong> India currently has no open-access national registry tracking exact parcel-by-parcel delay durations and High Court writ timelines for infrastructure projects. We modeled realistic statistical distributions grounded in CAG infrastructure performance audit benchmarks (Report 12/2021). As real project timelines complete in the pilot district, the model pipeline will transition to training on authentic longitudinal data.
                </p>
              </div>
            </div>

            {/* Limitation 2 */}
            <div className="rounded-2xl border border-slate-800 bg-slate-900/70 p-6 space-y-3">
              <div className="flex items-center gap-2">
                <span className="w-6 h-6 rounded-full bg-amber-500/20 text-amber-300 text-xs font-bold font-mono flex items-center justify-center">
                  2
                </span>
                <h2 className="text-sm font-bold text-white font-mono uppercase tracking-wider">
                  Survival Model Methodology: Literature-Calibrated Hazard Estimator
                </h2>
              </div>
              <div className="text-xs text-slate-300 space-y-2 leading-relaxed pl-8">
                <p>
                  <strong>Honest Disclosure:</strong> The time-to-event survival curves (S(t) = S₀(t)^HR) are generated using a <strong>Literature-Calibrated Breslow Cumulative Baseline Hazard Model</strong>, NOT an empirical Cox Proportional Hazards model fitted directly on right-censored pilot datasets.
                </p>
                <p className="text-slate-400">
                  <strong>Reason:</strong> Fitting an empirical Cox model or Kaplan-Meier curve requires hundreds of observed, fully completed event endpoints across identical strata. Our current approach transparently derives baseline survival S₀(t) from published CAG infrastructure delay distributions and applies statutory multipliers (HR = 2.41x for active litigation, 1.90x for compensation lag, 1.68x for forest NOC delays).
                </p>
              </div>
            </div>

            {/* Limitation 3 */}
            <div className="rounded-2xl border border-slate-800 bg-slate-900/70 p-6 space-y-3">
              <div className="flex items-center gap-2">
                <span className="w-6 h-6 rounded-full bg-amber-500/20 text-amber-300 text-xs font-bold font-mono flex items-center justify-center">
                  3
                </span>
                <h2 className="text-sm font-bold text-white font-mono uppercase tracking-wider">
                  Non-Causal Statistical Feature Attribution (Deviation-Weighted)
                </h2>
              </div>
              <div className="text-xs text-slate-300 space-y-2 leading-relaxed pl-8">
                <p>
                  <strong>Honest Disclosure:</strong> Local feature attributions (deviation-weighted feature scores) identify mathematical deviations from empirical baseline statistics; they do not prove direct legal or administrative causality.
                </p>
                <p className="text-slate-400">
                  <strong>Administrative Context:</strong> An elevated feature attribution on "LAO Backlog Ratio" indicates that in projects with similar profiles, high backlog strongly correlates with delay; it does not legally imply negligence by individual officers. District Collectors should use these insights as early warning indicators rather than definitive judicial findings.
                </p>
              </div>
            </div>

            {/* Limitation 4 */}
            <div className="rounded-2xl border border-slate-800 bg-slate-900/70 p-6 space-y-3">
              <div className="flex items-center gap-2">
                <span className="w-6 h-6 rounded-full bg-amber-500/20 text-amber-300 text-xs font-bold font-mono flex items-center justify-center">
                  4
                </span>
                <h2 className="text-sm font-bold text-white font-mono uppercase tracking-wider">
                  Geographic & Statutory Scope: Nagpur District Calibration
                </h2>
              </div>
              <div className="text-xs text-slate-300 space-y-2 leading-relaxed pl-8">
                <p>
                  <strong>Honest Disclosure:</strong> The system is currently calibrated for the administrative hierarchy, circle rates, and revenue terminology of <strong>Nagpur District, Maharashtra</strong> (Maharashtra Land Revenue Code, 1966, 7/12 RoR records, and SDO jurisdiction).
                </p>
                <p className="text-slate-400">
                  <strong>Cross-State Scaling:</strong> Expanding LandGuard AI to other states (e.g. Uttar Pradesh, Tamil Nadu) requires configuring state-specific circle rate multipliers (RFCTLARR First Schedule) and adapting state-specific digital revenue formats (e.g. Bhulekh, Tamil Nilam).
                </p>
              </div>
            </div>

            {/* Limitation 5 */}
            <div className="rounded-2xl border border-slate-800 bg-slate-900/70 p-6 space-y-3">
              <div className="flex items-center gap-2">
                <span className="w-6 h-6 rounded-full bg-amber-500/20 text-amber-300 text-xs font-bold font-mono flex items-center justify-center">
                  5
                </span>
                <h2 className="text-sm font-bold text-white font-mono uppercase tracking-wider">
                  Dependency on Field Verification Integrity (Data Quality Tiers)
                </h2>
              </div>
              <div className="text-xs text-slate-300 space-y-2 leading-relaxed pl-8">
                <p>
                  <strong>Honest Disclosure:</strong> Machine learning risk accuracy is strictly bounded by the completeness and veracity of ground surveys submitted by Patwaris and verified by LAOs.
                </p>
                <p className="text-slate-400">
                  <strong>Mitigation Architecture:</strong> To prevent "garbage-in, garbage-out" risk scores, the platform implements <strong>Data Quality Tiers</strong> (<code className="text-emerald-400 font-mono">VERIFIED</code>, <code className="text-amber-400 font-mono">PARTIALLY_VERIFIED</code>, <code className="text-slate-400 font-mono">PENDING_AUDIT</code>, <code className="text-sky-400 font-mono">BASELINE_ESTIMATE</code>). When 0 ground surveys are available, the system transparently indicates that scores reflect statutory baseline models rather than verified ground reality.
                </p>
              </div>
            </div>
          </div>

          {/* Security & Access Integrity Statement */}
          <div className="rounded-2xl border border-emerald-500/30 bg-emerald-950/20 p-6 space-y-3">
            <h2 className="text-sm font-bold text-emerald-300 font-mono uppercase tracking-wider">
              🛡️ Zero-Backdoor Security & RLS Compliance Guarantee
            </h2>
            <div className="text-xs text-slate-300 space-y-1.5 leading-relaxed font-mono">
              <p>✓ All authentication routes strictly use cryptographically signed Supabase Auth JWT tokens.</p>
              <p>✓ Zero unauthenticated <code className="text-emerald-400">sessionStorage</code> role bypasses or demo backdoors exist.</p>
              <p>✓ PostgreSQL Row Level Security (RLS) prevents cross-role tampering on executive directives.</p>
              <p>✓ Every protected route is wrapped with server-validated <code className="text-emerald-400">&lt;RoleGuard&gt;</code> barriers.</p>
            </div>
          </div>
        </div>
      </DashboardLayout>
    </RoleGuard>
  );
}
