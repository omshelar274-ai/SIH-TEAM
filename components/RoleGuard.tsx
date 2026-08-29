"use client";

import React, { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { supabase } from "@/lib/supabaseClient";

interface RoleGuardProps {
  allowedRoles: ("collector" | "lao" | "patwari")[];
  children: React.ReactNode;
}

export default function RoleGuard({ allowedRoles, children }: RoleGuardProps) {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [authorized, setAuthorized] = useState(false);
  const [userRole, setUserRole] = useState<string | null>(null);
  const [userName, setUserName] = useState<string>("Officer");

  useEffect(() => {
    async function checkRole() {
      try {
        // 1. Check Supabase Auth User
        const { data: { user }, error: userError } = await supabase.auth.getUser();

        if (user) {
          const { data: profile } = await supabase
            .from("profiles")
            .select("full_name, role, district")
            .eq("id", user.id)
            .maybeSingle();

          if (profile?.role) {
            const role = profile.role.toLowerCase() as "collector" | "lao" | "patwari";
            setUserRole(role);
            if (profile.full_name) setUserName(profile.full_name);
            else if (user.email) setUserName(user.email.split("@")[0]);

            if (allowedRoles.includes(role)) {
              setAuthorized(true);
              sessionStorage.setItem("active_officer_role", role);
              sessionStorage.setItem("active_officer_name", profile.full_name || user.email || "Officer");
              setLoading(false);
              return;
            }
          }
        }

        // 2. Check Active Session Storage (supports Demo Pills & active sessions)
        const sessionRole = (sessionStorage.getItem("active_officer_role") || "").toLowerCase() as "collector" | "lao" | "patwari";
        const sessionName = sessionStorage.getItem("active_officer_name") || "Officer";

        if (sessionRole && allowedRoles.includes(sessionRole)) {
          setUserRole(sessionRole);
          setUserName(sessionName);
          setAuthorized(true);
          setLoading(false);
          return;
        }

        if (sessionRole && !allowedRoles.includes(sessionRole)) {
          setUserRole(sessionRole);
          setUserName(sessionName);
          setAuthorized(false);
          setLoading(false);
          return;
        }

        // If no user and no session, redirect to login
        router.replace("/login");
      } catch (err) {
        console.warn("Role check error:", err);
        setAuthorized(false);
      } finally {
        setLoading(false);
      }
    }

    checkRole();
  }, [allowedRoles, router]);

  if (loading) {
    return (
      <div className="min-h-screen bg-slate-950 flex flex-col items-center justify-center text-slate-400 font-mono text-xs">
        <div className="w-8 h-8 border-3 border-indigo-500 border-t-transparent rounded-full animate-spin mb-3" />
        <span>VERIFYING ROLE AUTHORIZATION CREDENTIALS...</span>
      </div>
    );
  }

  if (!authorized) {
    const roleDestinations: Record<string, string> = {
      collector: "/dashboard",
      lao: "/dashboard/lao",
      patwari: "/dashboard/patwari",
    };

    const targetUrl = userRole && roleDestinations[userRole] ? roleDestinations[userRole] : "/login";

    return (
      <div className="min-h-screen bg-slate-950 flex items-center justify-center p-6 text-slate-100 font-sans">
        <div className="bg-slate-900 border border-red-500/30 max-w-md w-full rounded-2xl p-6 shadow-2xl space-y-4 text-center animate-scale-in">
          <div className="w-12 h-12 bg-red-500/10 text-red-400 border border-red-500/20 rounded-full flex items-center justify-center mx-auto text-xl font-bold">
            🛡️
          </div>
          <div>
            <span className="text-[10px] font-mono font-bold text-red-400 uppercase tracking-widest block mb-1">
              403 — Unauthorized Workspace Access
            </span>
            <h2 className="text-xl font-black text-white">Access Denied</h2>
            <p className="text-xs text-slate-400 mt-2 leading-relaxed">
              Officer <b>{userName}</b> (authenticated as <code className="text-amber-300 font-mono font-bold">{userRole || "unknown"}</code>) is not authorized to access this workspace.
            </p>
          </div>

          <div className="bg-slate-950 p-3 rounded-xl border border-slate-800 text-[11px] font-mono text-slate-400 text-left space-y-1">
            <p>Required Roles: <b className="text-emerald-400">{allowedRoles.join(", ")}</b></p>
            <p>Your Current Role: <b className="text-amber-400">{userRole || "unassigned"}</b></p>
          </div>

          <div className="pt-2 flex flex-col gap-2">
            <Link
              href={targetUrl}
              className="inline-block w-full bg-indigo-600 hover:bg-indigo-500 text-white font-bold py-2.5 rounded-xl text-xs transition shadow-lg shadow-indigo-600/25"
            >
              ← Go to Authorized Workspace ({userRole || "Login"})
            </Link>
            <Link
              href="/login"
              onClick={() => {
                sessionStorage.clear();
                supabase.auth.signOut();
              }}
              className="inline-block w-full bg-slate-800 hover:bg-slate-700 text-slate-300 font-bold py-2 rounded-xl text-xs transition border border-slate-700"
            >
              Switch Account / Sign Out
            </Link>
          </div>
        </div>
      </div>
    );
  }

  return <>{children}</>;
}
