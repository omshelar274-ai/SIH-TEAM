"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { supabase } from "@/lib/supabaseClient";

interface UserProfile {
  full_name: string;
  role: "collector" | "lao" | "patwari" | string;
  district: string;
}

export default function Sidebar() {
  const pathname = usePathname();
  const router = useRouter();
  const [profile, setProfile] = useState<UserProfile | null>(null);
  const [activeRole, setActiveRole] = useState<"collector" | "lao" | "patwari">("collector");
  const [loading, setLoading] = useState(true);
  const [pendingDirectivesCount, setPendingDirectivesCount] = useState(0);
  const [isMobileOpen, setIsMobileOpen] = useState(false);

  useEffect(() => {
    // Determine active role from pathname first
    if (pathname.includes("/dashboard/patwari") || pathname.includes("/families")) {
      setActiveRole("patwari");
    } else if (pathname.includes("/dashboard/lao") || pathname.includes("/verify")) {
      setActiveRole("lao");
    } else if (pathname.includes("/dashboard") || pathname.includes("/projects/new")) {
      setActiveRole("collector");
    }

    async function loadUser() {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) {
        setLoading(false);
        return;
      }

      const { data } = await supabase
        .from("profiles")
        .select("full_name, role, district")
        .eq("id", user.id)
        .single();

      if (data) {
        setProfile(data);
        if (data.role && (data.role === "patwari" || data.role === "lao" || data.role === "collector")) {
          // If on root dashboard without sub-path, adopt user's role
          if (pathname === "/dashboard") {
            setActiveRole(data.role as any);
          }
        }
      }
      setLoading(false);
    }
    loadUser();

    async function loadDirectivesCount() {
      try {
        const { data: dbDirs } = await supabase
          .from("directives")
          .select("id, status")
          .neq("status", "RESOLVED");

        if (dbDirs) {
          setPendingDirectivesCount(dbDirs.length);
        }
      } catch {}
    }
    loadDirectivesCount();
  }, [pathname]);

  async function handleLogout() {
    await supabase.auth.signOut();
    router.push("/login");
  }

  function handleRoleSwitch(newRole: "collector" | "lao" | "patwari") {
    setActiveRole(newRole);
    if (newRole === "collector") router.push("/dashboard");
    else if (newRole === "lao") router.push("/dashboard/lao");
    else if (newRole === "patwari") router.push("/dashboard/patwari");
  }

  if (pathname === "/login" || pathname === "/") {
    return null;
  }

  const roleLabels: Record<string, { label: string; badge: string; color: string }> = {
    collector: { label: "District Collector", badge: "bg-indigo-500/20 text-indigo-300 border-indigo-500/30", color: "text-indigo-400" },
    lao: { label: "LAO / Tehsildar", badge: "bg-blue-500/20 text-blue-300 border-blue-500/30", color: "text-blue-400" },
    patwari: { label: "Field Patwari (Talathi)", badge: "bg-emerald-500/20 text-emerald-300 border-emerald-500/30", color: "text-emerald-400" },
  };

  const roleInfo = roleLabels[activeRole] || roleLabels.collector;

  // STRICT Role-specific navigation items
  const roleNavMap: Record<string, Array<{ name: string; href: string; icon: string }>> = {
    collector: [
      { name: "Collector Command Center", href: "/dashboard", icon: "⚡" },
      { name: "+ Register New Project", href: "/projects/new", icon: "➕" },
      { name: "Guided Walkthrough", href: "/demo", icon: "🧭" },
      { name: "CAG Benchmarks", href: "/cag-benchmarks", icon: "🏛️" },
    ],
    lao: [
      { name: "LAO Verification Portal", href: "/dashboard/lao", icon: "⚖️" },
      { name: "Guided Walkthrough", href: "/demo", icon: "🧭" },
      { name: "CAG Benchmarks", href: "/cag-benchmarks", icon: "🏛️" },
    ],
    patwari: [
      { name: "Patwari Ground Entry Portal", href: "/dashboard/patwari", icon: "📋" },
      { name: "Guided Walkthrough", href: "/demo", icon: "🧭" },
      { name: "CAG Benchmarks", href: "/cag-benchmarks", icon: "🏛️" },
    ],
  };

  const navItems = roleNavMap[activeRole] || roleNavMap.collector;

  return (
    <>
      {/* Mobile Hamburger Button */}
      <button
        onClick={() => setIsMobileOpen(!isMobileOpen)}
        className="md:hidden fixed top-3 left-3 z-50 bg-slate-900 border border-slate-800 text-slate-200 p-2 rounded-xl shadow-lg"
      >
        <span className="text-lg">{isMobileOpen ? "✕" : "☰"}</span>
      </button>

      {/* Sidebar Container */}
      <aside
        className={`fixed top-0 left-0 h-screen w-64 bg-slate-900 border-r border-slate-800 flex flex-col justify-between p-4 z-40 transition-transform duration-300 ${
          isMobileOpen ? "translate-x-0" : "-translate-x-full md:translate-x-0"
        }`}
      >
        {/* Top Branding & Profile */}
        <div className="space-y-5">
          <div className="flex items-center gap-3 px-2 pt-1">
            <div className="w-9 h-9 rounded-xl bg-gradient-to-tr from-indigo-600 to-cyan-500 flex items-center justify-center font-black text-white text-lg shadow-lg shadow-indigo-600/30">
              LG
            </div>
            <div>
              <h1 className="text-sm font-black text-white tracking-wide">LandGuard</h1>
              <p className="text-[10px] font-mono text-indigo-400">SIH 2026 · PS 26017</p>
            </div>
          </div>

          {/* Quick Role Switcher Bar */}
          <div className="space-y-1.5 bg-slate-950/90 border border-slate-800 p-2.5 rounded-xl">
            <p className="text-[9px] font-mono font-bold text-slate-400 uppercase tracking-wider px-1">
              Active Hierarchy Role:
            </p>
            <div className="grid grid-cols-3 gap-1">
              <button
                onClick={() => handleRoleSwitch("collector")}
                className={`text-[10px] font-bold py-1.5 rounded-lg transition ${
                  activeRole === "collector"
                    ? "bg-indigo-600 text-white shadow-sm"
                    : "text-slate-400 hover:text-slate-200 hover:bg-slate-900"
                }`}
              >
                Collector
              </button>
              <button
                onClick={() => handleRoleSwitch("lao")}
                className={`text-[10px] font-bold py-1.5 rounded-lg transition ${
                  activeRole === "lao"
                    ? "bg-blue-600 text-white shadow-sm"
                    : "text-slate-400 hover:text-slate-200 hover:bg-slate-900"
                }`}
              >
                LAO
              </button>
              <button
                onClick={() => handleRoleSwitch("patwari")}
                className={`text-[10px] font-bold py-1.5 rounded-lg transition ${
                  activeRole === "patwari"
                    ? "bg-emerald-600 text-white shadow-sm"
                    : "text-slate-400 hover:text-slate-200 hover:bg-slate-900"
                }`}
              >
                Patwari
              </button>
            </div>
          </div>

          {/* User Profile Card */}
          <div className="bg-slate-950/60 border border-slate-800/80 rounded-xl p-3 space-y-1">
            <div className="flex items-center justify-between">
              <span className={`text-[9px] font-mono font-bold px-2 py-0.5 rounded-full border ${roleInfo.badge}`}>
                {roleInfo.label}
              </span>
              <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse" />
            </div>
            <p className="text-xs font-bold text-white truncate">
              {profile?.full_name || (activeRole === "collector" ? "District Collector" : activeRole === "lao" ? "LAO / Tehsildar" : "Field Patwari")}
            </p>
            <p className="text-[10px] font-mono text-slate-400">
              District: <span className="text-slate-200 font-semibold">{profile?.district || "Nagpur"}</span>
            </p>
          </div>

          {/* Navigation Links for Active Role */}
          <nav className="space-y-1">
            <p className="text-[10px] font-mono font-bold text-slate-500 uppercase tracking-wider px-2 mb-2">
              {activeRole.toUpperCase()} Workspace
            </p>
            {navItems.map((item) => {
              const isActive = pathname === item.href;
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  onClick={() => setIsMobileOpen(false)}
                  className={`flex items-center gap-2.5 px-3 py-2 rounded-xl text-xs font-semibold transition ${
                    isActive
                      ? activeRole === "patwari" ? "bg-emerald-600 text-white shadow-md" : activeRole === "lao" ? "bg-blue-600 text-white shadow-md" : "bg-indigo-600 text-white shadow-md"
                      : "text-slate-300 hover:bg-slate-800/60 hover:text-white"
                  }`}
                >
                  <span>{item.icon}</span>
                  <span>{item.name}</span>
                </Link>
              );
            })}
          </nav>

          {/* Directives Indicator */}
          {pendingDirectivesCount > 0 && (
            <div className="bg-amber-950/30 border border-amber-800/50 rounded-xl p-3 space-y-1">
              <div className="flex items-center justify-between">
                <span className="text-[10px] font-mono font-bold text-amber-300 flex items-center gap-1.5">
                  <span className="w-1.5 h-1.5 rounded-full bg-amber-400 animate-ping" />
                  Active Directives
                </span>
                <span className="text-[10px] font-bold bg-amber-500/20 text-amber-300 px-1.5 py-0.2 rounded-full">
                  {pendingDirectivesCount}
                </span>
              </div>
              <p className="text-[10px] text-slate-400">
                Action orders pending field resolution.
              </p>
            </div>
          )}
        </div>

        {/* Bottom Actions: Logout Button */}
        <div className="space-y-3 pt-4 border-t border-slate-800">
          <button
            onClick={handleLogout}
            className="w-full flex items-center justify-center gap-2 bg-red-950/40 hover:bg-red-900/60 text-red-300 border border-red-800/50 text-xs font-bold py-2.5 px-4 rounded-xl transition active:scale-95 shadow-sm"
          >
            <span>🚪</span>
            <span>Sign Out / Logout</span>
          </button>
          <div className="text-center">
            <span className="text-[9px] font-mono text-slate-500">
              LandGuard Engine v2.4 · {profile?.district || "Nagpur"}
            </span>
          </div>
        </div>
      </aside>
    </>
  );
}
