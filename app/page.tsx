"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { supabase } from "@/lib/supabaseClient";

export default function RootPage() {
  const router = useRouter();

  useEffect(() => {
    async function checkAuthAndRoute() {
      try {
        const getUserPromise = supabase.auth.getUser();
        const timeoutPromise = new Promise<any>((resolve) =>
          setTimeout(() => resolve({ data: { user: null } }), 2000)
        );
        const { data: { user } } = await Promise.race([getUserPromise, timeoutPromise]);
        
        if (!user) {
          router.replace("/login");
          return;
        }

        const { data: profile } = await supabase
          .from("profiles")
          .select("role")
          .eq("id", user.id)
          .single();

        if (profile?.role === "patwari") {
          router.replace("/dashboard/patwari");
        } else if (profile?.role === "lao") {
          router.replace("/dashboard/lao");
        } else {
          router.replace("/dashboard");
        }
      } catch (err) {
        router.replace("/login");
      }
    }

    checkAuthAndRoute();
  }, [router]);

  return (
    <main className="min-h-screen bg-slate-950 flex flex-col items-center justify-center text-slate-300 font-mono text-xs tracking-widest">
      <div className="w-10 h-10 border-4 border-indigo-500 border-t-transparent rounded-full animate-spin mb-4" />
      <span>INITIALIZING LANDGUARD SECURE SESSION...</span>
    </main>
  );
}
