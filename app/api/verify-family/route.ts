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
    const { familyId, status } = await req.json();

    if (!familyId || !status) {
      return NextResponse.json(
        { error: "Missing familyId or status parameter" },
        { status: 400 }
      );
    }

    if (!["Pending", "Verified", "Rejected"].includes(status)) {
      return NextResponse.json(
        { error: "Invalid verification status value" },
        { status: 400 }
      );
    }

    const supabaseAdmin = getAdminClient();

    const { data, error } = await supabaseAdmin
      .from("families")
      .update({ verification_status: status })
      .eq("id", familyId)
      .select()
      .single();

    if (error) {
      console.error("[API Verify Family] Error updating status:", error);
      return NextResponse.json({ error: error.message }, { status: 500 });
    }

    return NextResponse.json({ success: true, family: data });
  } catch (err: any) {
    console.error("[API Verify Family] Server error:", err);
    return NextResponse.json(
      { error: err?.message || "Internal server error" },
      { status: 500 }
    );
  }
}
