"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { supabase } from "@/lib/supabaseClient";

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const DEMO_OFFICERS = [
    {
      role: "District Collector / DM",
      email: "collector@test.com",
      roleCode: "collector",
      badge: "bg-indigo-500/20 text-indigo-300 border-indigo-500/30",
    },
    {
      role: "LAO / SDO / Tehsildar",
      email: "lao@test.com",
      roleCode: "lao",
      badge: "bg-blue-500/20 text-blue-300 border-blue-500/30",
    },
    {
      role: "Field Patwari (Talathi)",
      email: "patwari@test.com",
      roleCode: "patwari",
      badge: "bg-emerald-500/20 text-emerald-300 border-emerald-500/30",
    },
  ];

  function fillDemo(officerEmail: string) {
    setEmail(officerEmail);
    setPassword("abc");
    setError(null);
  }

  async function handleLogin(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    setError(null);

    try {
      // 1. Attempt Supabase Auth with timeout protection
      const authPromise = supabase.auth.signInWithPassword({
        email: email.trim(),
        password,
      });

      const timeoutPromise = new Promise<{ data: any; error: any }>((resolve) =>
        setTimeout(() => resolve({ data: { user: null }, error: { message: "Network timeout connecting to authentication server." } }), 4000)
      );

      const { data, error: signInError } = await Promise.race([authPromise, timeoutPromise]);

      if (data?.user) {
        // Query existing linked profile from Supabase
        const { data: profile, error: profError } = await supabase
          .from("profiles")
          .select("role, full_name, district")
          .eq("id", data.user.id)
          .maybeSingle();

        if (profError || !profile || !profile.role) {
          setError("Officer profile record not found in district registry. Please contact the District Administrator.");
          setLoading(false);
          return;
        }

        const role = profile.role.toLowerCase() as "collector" | "lao" | "patwari";

        sessionStorage.setItem("active_officer_role", role);
        sessionStorage.setItem("active_officer_name", profile.full_name || email.split("@")[0]);

        if (role === "patwari") {
          router.push("/dashboard/patwari");
        } else if (role === "lao") {
          router.push("/dashboard/lao");
        } else if (role === "collector") {
          router.push("/dashboard");
        } else {
          setError(`Unauthorized role: '${profile.role}'. Access restricted to registered district officers.`);
          setLoading(false);
        }
      } else {
        setError(signInError?.message || "Invalid officer email or passphrase. Please verify your credentials.");
        setLoading(false);
      }
    } catch (err: any) {
      setError(err?.message || "Authentication service error. Please try again.");
      setLoading(false);
    }
  }

  const ROLES_INFO = [
    {
      role: "District Collector / DM",
      color: "bg-indigo-500",
      desc: "Full corridor portfolio risk heatmap, multi-model survival curves, executive directives, and escrow re-routing.",
    },
    {
      role: "LAO / SDO / Tehsildar",
      color: "bg-blue-500",
      desc: "Verify Patwari ground entries, Section 3A/3D/11/19 SLA statutory timelines, and directive resolutions.",
    },
    {
      role: "Field Patwari (Talathi)",
      color: "bg-emerald-500",
      desc: "Enter family survey records, crop/structural valuations, court dispute logs, and possession status.",
    },
  ];

  return (
    <main className="min-h-screen bg-gradient-to-br from-slate-900 via-indigo-950 to-slate-900 flex items-center justify-center px-6 py-12">
      <div className="w-full max-w-4xl grid grid-cols-1 md:grid-cols-2 gap-10 items-center">

        {/* Left — Branding & Hierarchy Overview */}
        <div className="text-white space-y-6">
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full border border-indigo-500/30 bg-indigo-500/10 text-indigo-300 text-xs font-semibold mb-4">
              <span className="w-1.5 h-1.5 rounded-full bg-indigo-400 animate-pulse" />
              SIH 2026 · PS 26017
            </div>
            <h1 className="text-3xl lg:text-4xl font-black leading-tight">
              LandGuard AI
              <span className="block text-transparent bg-clip-text bg-gradient-to-r from-indigo-400 to-cyan-400 text-xl lg:text-2xl font-bold mt-1">
                Predictive Land Acquisition Analytics
              </span>
            </h1>
            <p className="mt-3 text-slate-400 text-xs leading-relaxed max-w-sm">
              Early warning system for infrastructure project delays. Powered by Multi-Model Survival Ensemble ML, PostGIS geofencing spatial analysis, and live government data integrations.
            </p>
          </div>

          <div className="space-y-3 pt-2">
            <p className="text-[10px] font-mono font-bold text-slate-500 uppercase tracking-wider">
              Role-Based Access Hierarchy
            </p>
            <div className="space-y-2.5">
              {ROLES_INFO.map((r) => (
                <div key={r.role} className="flex items-start gap-3 bg-white/5 border border-white/5 p-2.5 rounded-xl">
                  <span className={`mt-1 w-2 h-2 rounded-full ${r.color} shrink-0`} />
                  <div>
                    <p className="text-xs font-bold text-slate-200">{r.role}</p>
                    <p className="text-[10px] text-slate-400 leading-tight mt-0.5">{r.desc}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Right — Clean Official Sign In Form */}
        <form
          id="login-form"
          onSubmit={handleLogin}
          className="bg-white/5 backdrop-blur border border-white/10 rounded-2xl p-6 lg:p-8 space-y-4 shadow-2xl"
        >
          <div>
            <h2 className="text-xl font-bold text-white">Sign In to Portal</h2>
            <p className="text-slate-400 text-xs mt-1">Enter your registered government officer credentials.</p>
          </div>

          {/* Quick Officer Auto-Fill Pills */}
          <div className="space-y-1.5 pt-1">
            <p className="text-[10px] font-mono text-slate-400 uppercase tracking-wider">
              ⚡ Quick Auto-Fill Demo Accounts:
            </p>
            <div className="grid grid-cols-3 gap-2">
              {DEMO_OFFICERS.map((o) => (
                <button
                  type="button"
                  key={o.roleCode}
                  onClick={() => fillDemo(o.email)}
                  className={`text-[10px] font-bold py-1.5 px-2 rounded-lg border text-center transition hover:brightness-125 ${o.badge}`}
                >
                  {o.roleCode.toUpperCase()}
                </button>
              ))}
            </div>
          </div>

          <div className="space-y-3.5 pt-1">
            <div>
              <label className="block text-xs font-semibold text-slate-400 mb-1">Email Address</label>
              <input
                id="login-email"
                type="email"
                required
                autoComplete="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="w-full rounded-xl border border-white/10 bg-white/5 px-3.5 py-2.5 text-xs text-white placeholder:text-slate-600 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition"
                placeholder="collector@nagpur.gov.in"
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-400 mb-1">Password</label>
              <input
                id="login-password"
                type="password"
                required
                autoComplete="current-password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full rounded-xl border border-white/10 bg-white/5 px-3.5 py-2.5 text-xs text-white placeholder:text-slate-600 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition"
                placeholder="••••••••"
              />
            </div>
          </div>

          {error && (
            <div className="p-3 rounded-xl bg-red-500/10 border border-red-500/20 text-red-400 text-xs leading-relaxed">
              {error}
            </div>
          )}

          <button
            id="login-submit"
            type="submit"
            disabled={loading}
            className="w-full rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white py-3 text-xs font-bold shadow-lg shadow-indigo-500/25 transition-all active:scale-95 disabled:opacity-50"
          >
            {loading ? "Authenticating Digital Token..." : "Sign in to Dashboard →"}
          </button>

          <div className="pt-2 text-[10px] text-slate-500 font-mono leading-relaxed border-t border-white/5">
            Role is automatically retrieved from <code className="text-indigo-400">profiles.role</code> upon authentication.
          </div>
        </form>
      </div>
    </main>
  );
}
