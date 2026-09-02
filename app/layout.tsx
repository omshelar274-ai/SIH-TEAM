import "./globals.css";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Bhu Nirikshan — Predictive Land Acquisition Analytics | SIH 2026",
  description:
    "AI-powered early warning system that predicts which land acquisition projects will face delays, and tells officials exactly what to fix first.",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className="dark">
      <body className="bg-slate-950 text-slate-100 min-h-screen selection:bg-indigo-600 selection:text-white antialiased">
        {children}
      </body>
    </html>
  );
}
