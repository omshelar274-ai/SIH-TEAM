import Link from "next/link";

export default function Home() {
  return (
    <main className="min-h-screen bg-gradient-to-br from-slate-900 via-indigo-950 to-slate-900 flex flex-col items-center justify-center px-6 text-center relative overflow-hidden">
      {/* Background decorative orbs */}
      <div className="absolute top-20 left-1/4 w-96 h-96 bg-indigo-500/10 rounded-full blur-3xl pointer-events-none" />
      <div className="absolute bottom-20 right-1/4 w-80 h-80 bg-blue-500/10 rounded-full blur-3xl pointer-events-none" />

      {/* Badge */}
      <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full border border-indigo-500/30 bg-indigo-500/10 text-indigo-300 text-xs font-semibold mb-8 animate-fade-in">
        <span className="w-1.5 h-1.5 rounded-full bg-indigo-400 animate-pulse" />
        SIH 2026 — Problem Statement 26017
      </div>

      {/* Headline */}
      <h1 className="text-5xl md:text-6xl font-black text-white max-w-3xl leading-tight tracking-tight animate-slide-up">
        Predict Land Acquisition Delays.{" "}
        <span className="text-transparent bg-clip-text bg-gradient-to-r from-indigo-400 to-cyan-400">
          Before They Happen.
        </span>
      </h1>

      <p className="mt-6 text-slate-400 max-w-xl text-base md:text-lg leading-relaxed animate-slide-up">
        AI-powered early warning system grounded in peer-reviewed research and real
        ADB project data. Predicts which infrastructure projects will face delays
        — and tells officials exactly what to fix, and when.
      </p>

      {/* Feature pills */}
      <div className="flex flex-wrap justify-center gap-3 mt-8 animate-fade-in">
        {[
          "🤖 Random Forest ML Model",
          "🗺️ PostGIS Risk Maps",
          "⚖️ Litigation Velocity Tracking",
          "✅ 3-Role Workflow Verification",
          "🏛️ e-Courts + Bhoomi Rashi Sync",
        ].map((f) => (
          <span
            key={f}
            className="px-3 py-1.5 bg-white/5 border border-white/10 text-slate-300 text-xs font-medium rounded-full"
          >
            {f}
          </span>
        ))}
      </div>

      {/* CTA */}
      <div className="mt-10 flex gap-4 flex-wrap justify-center animate-slide-up">
        <Link
          href="/login"
          className="rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white px-8 py-3.5 font-semibold text-sm shadow-lg shadow-indigo-500/25 hover:shadow-indigo-500/40 transition-all active:scale-95"
        >
          Sign In to Dashboard →
        </Link>
        <a
          href="https://paimana-proj.mospi.gov.in/"
          target="_blank"
          rel="noreferrer"
          className="rounded-xl border border-white/20 bg-white/5 hover:bg-white/10 text-white px-8 py-3.5 font-semibold text-sm transition-all active:scale-95"
        >
          MoSPI PAIMANA Portal ↗
        </a>
      </div>

      {/* Stats row */}
      <div className="mt-16 grid grid-cols-3 gap-8 max-w-lg w-full animate-fade-in">
        <div className="text-center">
          <p className="text-3xl font-black text-white">5,000</p>
          <p className="text-xs text-slate-400 mt-1">Training Records</p>
        </div>
        <div className="text-center border-x border-white/10">
          <p className="text-3xl font-black text-white">70%</p>
          <p className="text-xs text-slate-400 mt-1">Model Accuracy</p>
        </div>
        <div className="text-center">
          <p className="text-3xl font-black text-white">3</p>
          <p className="text-xs text-slate-400 mt-1">Gov Roles Supported</p>
        </div>
      </div>

      <p className="mt-10 text-xs text-slate-600">
        Grounded in Devi &amp; Sindhu (2025) · Andrić et al. (2024, 2025) · PRAGATI Cabinet Review Jan 2026
      </p>
    </main>
  );
}
