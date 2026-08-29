import { createClient } from "@supabase/supabase-js";

const supabaseUrl =
  process.env.NEXT_PUBLIC_SUPABASE_URL || "https://sppndjaqnayuuoqyjcxm.supabase.co";
const supabaseAnonKey =
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY ||
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNwcG5kamFxbmF5dXVvcXlqY3htIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc4NzY1MzQwNywiZXhwIjoyMTAzMjI5NDA3fQ._ubKEH2mGAZ1FnkWyrnBZpbJykzkHD1CDdjUTvkIHoQ";

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
