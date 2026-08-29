import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

export const dynamic = "force-dynamic";

function getAdminClient() {
  const supabaseUrl =
    process.env.NEXT_PUBLIC_SUPABASE_URL || "https://sppndjaqnayuuoqyjcxm.supabase.co";
  const serviceRoleKey =
    process.env.SUPABASE_SERVICE_ROLE_KEY ||
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY ||
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNwcG5kamFxbmF5dXVvcXlqY3htIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc4NzY1MzQwNywiZXhwIjoyMTAzMjI5NDA3fQ._ubKEH2mGAZ1FnkWyrnBZpbJykzkHD1CDdjUTvkIHoQ";

  return createClient(supabaseUrl, serviceRoleKey, {
    auth: { persistSession: false },
  });
}

export async function GET(req: NextRequest) {
  const { searchParams } = new URL(req.url);
  const userId = searchParams.get("userId");

  if (!userId) {
    return NextResponse.json({ error: "Missing userId parameter" }, { status: 400 });
  }

  try {
    const supabaseAdmin = getAdminClient();
    const { data: profile, error } = await supabaseAdmin
      .from("profiles")
      .select("id, full_name, role, district")
      .eq("id", userId)
      .maybeSingle();

    if (error || !profile) {
      return NextResponse.json({ error: "Profile not found in registry" }, { status: 404 });
    }

    return NextResponse.json({ profile });
  } catch (err: any) {
    return NextResponse.json({ error: err?.message || "Internal server error" }, { status: 500 });
  }
}
