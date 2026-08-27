"use client";

import Sidebar from "@/components/Sidebar";

export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 flex">
      <Sidebar />
      <div className="flex-1 md:ml-64 min-w-0 transition-all duration-300">
        {children}
      </div>
    </div>
  );
}
