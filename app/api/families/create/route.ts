import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

export const dynamic = "force-dynamic";

function getAdminClient() {
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const serviceRoleKey =
    process.env.SUPABASE_SERVICE_ROLE_KEY ||
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

  if (!supabaseUrl || !serviceRoleKey) {
    throw new Error("Server misconfigured: missing Supabase credentials");
  }

  return createClient(supabaseUrl, serviceRoleKey, {
    auth: { persistSession: false },
  });
}

export async function POST(req: NextRequest) {
  try {
    const payload = await req.json();

    if (!payload.project_id || !payload.family_name) {
      return NextResponse.json(
        { error: "Missing required fields: project_id and family_name" },
        { status: 400 }
      );
    }

    const supabaseAdmin = getAdminClient();

    const { data, error } = await supabaseAdmin
      .from("families")
      .insert({
        project_id: payload.project_id,
        family_name: payload.family_name,
        land_area_owned: payload.land_area_owned != null ? Number(payload.land_area_owned) : null,
        compensation_amount: payload.compensation_amount != null ? Number(payload.compensation_amount) : null,
        payment_status: payload.payment_status || "Pending",
        objection_status: payload.objection_status || "None",
        court_case_status: payload.court_case_status || "None",
        court_case_filed_date:
          payload.court_case_status === "Active" && payload.court_case_filed_date
            ? payload.court_case_filed_date
            : null,
        possession_status: payload.possession_status || "Occupied",
        verification_status: "Pending",
        entered_by: payload.entered_by || null,
      })
      .select()
      .single();

    if (error) {
      console.error("[API Create Family] Database error:", error);
      return NextResponse.json({ error: error.message }, { status: 500 });
    }

    return NextResponse.json({ success: true, family: data });
  } catch (err: any) {
    console.error("[API Create Family] Server error:", err);
    return NextResponse.json(
      { error: err?.message || "Internal server error" },
      { status: 500 }
    );
  }
}
