# SIH 2025 — Land Acquisition Delay Predictor (Round 1 MVP)

## What's in here

- `app/login` — auth, routes collector vs patwari to different dashboards
- `app/dashboard` — **Collector view**: lists every project with a live risk card (score, drivers, recommendations) computed from real Supabase data
- `app/dashboard/patwari` — **Patwari view**: lists projects, links to data entry (no risk scores — that's the collector's job)
- `app/projects/new` — project creation form (10-field version)
- `app/projects/[id]/families` — family-wise data entry
- `app/projects/[id]/rehabilitation` — R&R (rehabilitation) progress entry
- `lib/riskScore.ts` — rule-based risk engine (Section 6 of the reference guide)
- `lib/projectMetrics.ts` — pulls a project's families + rehabilitation rows from Supabase and assembles them into the risk engine's input shape
- `lib/supabaseClient.ts` — Supabase client
- `schema.sql` — full schema + RLS policies
- `scripts/seed.mjs` — seeds the NH-44 demo project with realistic family/rehab data

## Setup

1. Create a free project at https://supabase.com
2. SQL Editor → paste in `schema.sql` → run it
3. Authentication → Users → create two test users:
   - a collector, e.g. `collector@test.com`
   - a patwari, e.g. `patwari@test.com`
4. Table Editor → `profiles` → add a row for each (matching their auth UID), setting `role` and `district` (use the **same district** for both so RLS lets them see the same projects)
5. Copy `.env.local.example` → `.env.local`, fill in your Supabase URL + anon key (Settings → API)
   Add `SUPABASE_SERVICE_ROLE_KEY` to `.env.local` for the government portal sync API.
6. `npm install`
7. `npm run dev` — app runs at http://localhost:3000

## Seeding demo data (optional but recommended for rehearsal)

The dashboard shows fallback demo numbers when Supabase has zero projects, but for
an actual demo you want real seeded data so live edits (e.g. updating R&R progress)
visibly move the risk score.

1. Get your **service role key** from Settings → API (never expose it in browser code;
   the server-only sync API uses it to bypass RLS)
2. Run:
   ```
   SUPABASE_URL=https://your-project.supabase.co \
   SUPABASE_SERVICE_ROLE_KEY=your-service-role-key \
   npm run seed
   ```
3. Log in as your collector — you'll see the NH-44 project with a real,
   Supabase-computed risk score (should land close to the guide's 87/100 CRITICAL example)

## What's built vs what's left

**Working:**
- Login with role-based routing
- Project creation, family data entry, R&R data entry — all writing to Supabase
- Dashboard risk cards computed live from real family + rehabilitation data (no more hardcoded demo numbers once a project exists)
- Seed script for realistic rehearsal data

**Still open (good next tasks):**
- A way for collectors to toggle `forest_clearance_applied` and edit `avg_dept_response_days` from the UI (currently only settable via SQL/seed — these two fields feed directly into the risk score)
- "Assign Task" button on the dashboard is currently just a visual element — no task-assignment table/flow behind it yet
- Objection trend tracking (the guide's Section 6 mentions "rising trend" as a signal — currently we only count active court cases, not the trend over time)
- Only 2 of the 8 roles exist (by design, for MVP scope — see the team plan)

## Deploying for the demo

Push to GitHub, import into Vercel, add the two `NEXT_PUBLIC_*` env vars from
`.env.local` in Vercel's project settings. **Do not** add the service role key to
Vercel — the seed script is meant to be run once, locally, not deployed.
