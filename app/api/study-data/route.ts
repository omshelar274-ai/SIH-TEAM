import { NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || "";
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || "";

const supabaseAdmin = createClient(supabaseUrl, serviceRoleKey, {
  auth: { persistSession: false },
});

export async function GET() {
  try {
    const { data: projects, error: projErr } = await supabaseAdmin
      .from("projects")
      .select("*")
      .order("created_at", { ascending: false });

    if (projErr) throw projErr;

    const { data: families, error: famErr } = await supabaseAdmin
      .from("families")
      .select("*");

    if (famErr) throw famErr;

    return NextResponse.json({
      success: true,
      projects: projects || [],
      families: families || [],
      counts: {
        projects: (projects || []).length,
        families: (families || []).length,
      },
    });
  } catch (err: any) {
    return NextResponse.json(
      { error: err?.message || "Failed to query database records" },
      { status: 500 }
    );
  }
}
