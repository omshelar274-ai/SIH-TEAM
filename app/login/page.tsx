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

  async function handleLogin(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    setError(null);

    const { data, error: signInError } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (signInError) {
      setError(signInError.message);
      setLoading(false);
      return;
    }

    const { data: profile } = await supabase
      .from("profiles")
      .select("role")
      .eq("id", data.user?.id)
      .single();

    setLoading(false);

    if (profile?.role === "patwari") {
      router.push("/dashboard/patwari");
    } else if (profile?.role === "lao") {
      router.push("/dashboard/lao");
    } else {
      router.push("/dashboard");
    }
  }

  const DEMO_ROLES = [
    { role: "Collector / DM", color: "bg-indigo-500", desc: "View risk scores, manage projects, sync gov portals" },
    { role: "LAO / Tehsildar", color: "bg-blue-500", desc: "Verify Patwari field entries before they affect ML scores" },
    { role: "Patwari", color: "bg-emerald-500", desc: "Enter family data, court cases, possession status" },
  ];

  return (
    <main className="min-h-screen bg-gradient-to-br from-slate-900 via-indigo-950 to-slate-900 flex items-center justify-center px-6 py-16">
      <div className="w-full max-w-4xl grid grid-cols-1 md:grid-cols-2 gap-8 items-start">

        {/* Left — branding */}
        <div className="text-white animate-slide-up">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full border border-indigo-500/30 bg-indigo-500/10 text-indigo-300 text-xs font-semibold mb-6">
            <span className="w-1.5 h-1.5 rounded-full bg-indigo-400 animate-pulse" />
            SIH 2026 · PS 26017
          </div>
          <h1 className="text-4xl font-black leading-tight">
            LandGuard
            <span className="block text-transparent bg-clip-text bg-gradient-to-r from-indigo-400 to-cyan-400 text-2xl font-bold mt-1">
              Predictive Land Acquisition Analytics
            </span>
          </h1>
          <p className="mt-4 text-slate-400 text-sm leading-relaxed max-w-sm">
            Early warning system for infrastructure project delays. Powered by Random Forest ML, PostGIS spatial analysis, and live government data integrations.
          </p>

          <div className="mt-8 space-y-3">
            <p className="text-xs font-semibold text-slate-500 uppercase tracking-wider">Role-Based Access</p>
            {DEMO_ROLES.map((r) => (
              <div key={r.role} className="flex items-start gap-3">
                <span className={`mt-0.5 w-2 h-2 rounded-full ${r.color} shrink-0`} />
                <div>
                  <p className="text-sm font-semibold text-slate-300">{r.role}</p>
                  <p className="text-xs text-slate-500">{r.desc}</p>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Right — login form */}
        <form
          id="login-form"
          onSubmit={handleLogin}
          className="bg-white/5 backdrop-blur border border-white/10 rounded-2xl p-8 animate-fade-in"
        >
          <h2 className="text-xl font-bold text-white mb-1">Sign in</h2>
          <p className="text-slate-400 text-sm mb-6">Enter your credentials to access the portal.</p>

          <div className="space-y-4">
            <div>
              <label className="block text-xs font-semibold text-slate-400 mb-1.5">Email address</label>
              <input
                id="login-email"
                type="email"
                required
                autoComplete="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="w-full rounded-lg border border-white/10 bg-white/5 px-3 py-2.5 text-sm text-white placeholder:text-slate-600
                           focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition"
                placeholder="collector@example.gov.in"
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-400 mb-1.5">Password</label>
              <input
                id="login-password"
                type="password"
                required
                autoComplete="current-password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full rounded-lg border border-white/10 bg-white/5 px-3 py-2.5 text-sm text-white placeholder:text-slate-600
                           focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition"
                placeholder="••••••••"
              />
            </div>
          </div>

          {error && (
            <div className="mt-4 p-3 rounded-lg bg-red-500/10 border border-red-500/20 text-red-400 text-sm">
              {error}
            </div>
          )}

          <button
            id="login-submit"
            type="submit"
            disabled={loading}
            className="mt-6 w-full rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white py-3 text-sm font-semibold
                       shadow-lg shadow-indigo-500/25 transition-all active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {loading ? (
              <span className="flex items-center justify-center gap-2">
                <span className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                Authenticating...
              </span>
            ) : (
              "Sign in to Portal →"
            )}
          </button>

          <p className="text-xs text-slate-600 mt-5 leading-relaxed">
            Create users in Supabase Auth, then add their <code className="text-slate-500">profiles</code> row with role = <code className="text-slate-500">collector</code>, <code className="text-slate-500">lao</code>, or <code className="text-slate-500">patwari</code> and the same <code className="text-slate-500">district</code> to enable data sharing.
          </p>
        </form>
      </div>
    </main>
  );
}
