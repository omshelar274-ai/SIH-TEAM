import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

export const dynamic = "force-dynamic";

function getAdminClient() {
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const serviceRoleKey =
    process.env.SUPABASE_SERVICE_ROLE_KEY ||
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

  if (!supabaseUrl || !serviceRoleKey) {
    throw new Error(
      "Server misconfigured: missing Supabase credentials (NEXT_PUBLIC_SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY / NEXT_PUBLIC_SUPABASE_ANON_KEY)"
    );
  }

  return createClient(supabaseUrl, serviceRoleKey, {
    auth: { persistSession: false },
  });
}

export async function GET(req: NextRequest) {
  try {
    const { searchParams } = new URL(req.url);
    const district = searchParams.get("district");

    const supabaseAdmin = getAdminClient();

    let projQuery = supabaseAdmin
      .from("projects")
      .select("*")
      .order("created_at", { ascending: false });

    if (district) {
      projQuery = projQuery.eq("district", district);
    }

    const { data: projects, error: projErr } = await projQuery;

    if (projErr) throw projErr;

    const projectIds = (projects || []).map((p: any) => p.id);

    let famQuery = supabaseAdmin.from("families").select("*");
    if (district && projectIds.length > 0) {
      famQuery = famQuery.in("project_id", projectIds);
    } else if (district && projectIds.length === 0) {
      famQuery = famQuery.eq("project_id", "00000000-0000-0000-0000-000000000000"); // Empty result set
    }

    const { data: families, error: famErr } = await famQuery;

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
