// Seeds the NH-44 demo project (from the reference guide) as real Supabase data.
// Updated for the new schema: adds court_case_filed_date and verification_status to families.
// Also seeds a second project (Bhopal Ring Road) to give the dashboard more to show.
//
// Usage:
//   SUPABASE_URL=https://your-project.supabase.co \
//   SUPABASE_SERVICE_ROLE_KEY=your-service-role-key \
//   npm run seed

import { createClient } from "@supabase/supabase-js";

const SUPABASE_URL = process.env.SUPABASE_URL;
const SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!SUPABASE_URL || !SERVICE_ROLE_KEY) {
  console.error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY env vars.");
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY);

// Helper: subtract N months from today and return ISO date string
function monthsAgo(n) {
  const d = new Date();
  d.setMonth(d.getMonth() - n);
  return d.toISOString().split("T")[0];
}

async function main() {
  // ── 1. Find profiles ────────────────────────────────────────────────────────
  const { data: collector, error: collErr } = await supabase
    .from("profiles").select("id, district").eq("role", "collector").limit(1).maybeSingle();
  if (collErr || !collector) {
    console.error("No collector profile found. Create one first (see README).");
    process.exit(1);
  }

  const { data: patwari } = await supabase
    .from("profiles").select("id").eq("role", "patwari").limit(1).maybeSingle();

  // Use patwari ID if found, else fall back to collector
  const fieldEnteredBy = patwari?.id ?? collector.id;
  const district = collector.district;
  console.log(`Seeding into district: ${district}`);

  // ── 2. Project 1: NH-44 (CRITICAL risk demo) ────────────────────────────────
  const { data: proj1 } = await supabase.from("projects").insert({
    project_name:           "NH-44 Greenfield Highway Expansion",
    project_type:           "Highway",
    district,
    villages_affected:      "Rampur, Sonegaon, Hingna",
    total_land_area_hectares: 1250,
    est_families_affected:  847,
    st_families:            120,
    start_date:             "2025-01-15",
    target_handover_date:   "2027-12-31",
    forest_clearance:       "Yes",
    forest_clearance_applied: false,
    avg_dept_response_days: 18,
    status:                 "ONGOING",
    created_by:             collector.id,
  }).select().single();

  if (!proj1) { console.error("Failed to create Project 1"); process.exit(1); }
  console.log(`✓ Created project: ${proj1.project_name} (${proj1.id})`);

  // 50 families — mix of paid/pending/refusing/active cases with realistic filing dates
  const families1 = [];
  for (let i = 1; i <= 50; i++) {
    const paid       = i <= 18;
    const activeCase = i > 18 && i <= 41;
    const refusing   = i > 33 && i <= 48;

    // Older cases filed 4–12 months ago; recent ones 1–3 months ago (velocity signal)
    const filedDate = activeCase
      ? (i <= 32 ? monthsAgo(Math.floor(Math.random() * 8) + 4)   // 4–12 months ago
                 : monthsAgo(Math.floor(Math.random() * 2) + 1))   // 1–3 months ago
      : null;

    families1.push({
      project_id:             proj1.id,
      family_name:            `Family ${i} (NH-44)`,
      land_area_owned:        Math.round((1250 / 847) * 10) / 10,
      compensation_amount:    500000 + i * 1000,
      payment_status:         paid ? "Paid" : i <= 33 ? "Pending" : "Not Calculated",
      court_case_status:      activeCase ? "Active" : "None",
      court_case_filed_date:  filedDate,
      objection_status:       activeCase ? "Filed" : "None",
      possession_status:      refusing ? "Refusing" : paid ? "Vacated" : "Occupied",
      // First 20 entries pre-verified (collector already approved these); rest are pending
      verification_status:    i <= 20 ? "Verified" : "Pending",
      entered_by:             fieldEnteredBy,
    });
  }

  const { error: fErr1 } = await supabase.from("families").insert(families1);
  if (fErr1) console.error("Family seed error (proj1):", fErr1.message);
  else console.log(`✓ Seeded ${families1.length} family records for NH-44`);

  await supabase.from("rehabilitation_status").insert({
    project_id: proj1.id, colonies_planned: 5, colonies_built: 2, families_shifted: 89,
  });
  console.log("✓ Seeded R&R status for NH-44 (2/5 colonies built)");

  // ── 3. Project 2: Bhopal Ring Road (MODERATE risk demo) ─────────────────────
  const { data: proj2 } = await supabase.from("projects").insert({
    project_name:           "Bhopal Outer Ring Road Phase II",
    project_type:           "Highway",
    district,
    villages_affected:      "Mandideep, Obaidullaganj, Barkhera",
    total_land_area_hectares: 340,
    est_families_affected:  212,
    st_families:            18,
    start_date:             "2025-06-01",
    target_handover_date:   "2027-06-30",
    forest_clearance:       "No",
    forest_clearance_applied: true,
    avg_dept_response_days: 9,
    status:                 "ONGOING",
    created_by:             collector.id,
  }).select().single();

  if (!proj2) { console.warn("Failed to create Project 2 (skipping)"); }
  else {
    console.log(`✓ Created project: ${proj2.project_name} (${proj2.id})`);

    const families2 = [];
    for (let i = 1; i <= 30; i++) {
      const paid    = i <= 18;  // 60% paid → MODERATE range
      const hasCase = i > 24;   // 6 active cases
      families2.push({
        project_id:             proj2.id,
        family_name:            `Family ${i} (Ring Road)`,
        land_area_owned:        Math.round((340 / 212) * 10) / 10,
        compensation_amount:    350000 + i * 800,
        payment_status:         paid ? "Paid" : "Pending",
        court_case_status:      hasCase ? "Active" : "None",
        court_case_filed_date:  hasCase ? monthsAgo(Math.floor(Math.random() * 3) + 1) : null,
        objection_status:       hasCase ? "Filed" : "None",
        possession_status:      paid ? "Vacated" : "Occupied",
        verification_status:    i <= 25 ? "Verified" : "Pending",
        entered_by:             fieldEnteredBy,
      });
    }

    const { error: fErr2 } = await supabase.from("families").insert(families2);
    if (fErr2) console.error("Family seed error (proj2):", fErr2.message);
    else console.log(`✓ Seeded ${families2.length} family records for Ring Road`);

    await supabase.from("rehabilitation_status").insert({
      project_id: proj2.id, colonies_planned: 3, colonies_built: 2, families_shifted: 55,
    });
    console.log("✓ Seeded R&R status for Ring Road (2/3 colonies built)");
  }

  console.log("\n✅ Done. Log in as the Collector to see both projects with risk scores.");
  console.log("   Log in as the LAO to see pending verification queues.");
}

main().catch(console.error);
