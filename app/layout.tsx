import "./globals.css";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "LandGuard — Predictive Land Acquisition Analytics | SIH 2026",
  description:
    "AI-powered early warning system that predicts which land acquisition projects will face delays, and tells officials exactly what to fix first.",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="bg-slate-50 text-slate-900 min-h-screen">
        {children}
      </body>
    </html>
  );
}
