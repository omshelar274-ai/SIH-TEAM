import { createClient } from "@supabase/supabase-js";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL as string;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY as string;

if (!supabaseUrl || !supabaseAnonKey) {
  // Fails loudly in dev if .env.local isn't set up yet — saves a confusing debug session later.
  console.warn(
    "Supabase env vars missing. Copy .env.local.example to .env.local and fill in your project values."
  );
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
