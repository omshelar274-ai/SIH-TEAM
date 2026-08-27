-- 1. Extend Supabase's built-in auth.users with a role + district
create extension if not exists postgis;

-- Safe cleanup of existing tables to avoid duplicate relation errors
drop table if exists public.reference_forests cascade;
drop table if exists public.reference_villages cascade;
drop table if exists public.risk_snapshots cascade;
drop table if exists public.rehabilitation_status cascade;
drop table if exists public.families cascade;
drop table if exists public.projects cascade;
drop table if exists public.profiles cascade;

create table public.profiles (
  id uuid references auth.users on delete cascade primary key,
  full_name text,
  role text not null check (role in ('collector', 'lao', 'patwari')),
  district text not null,
  created_at timestamptz default now()
);

-- Trigger to automatically create a profiles row when a new user signs up in Auth
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, full_name, role, district)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', 'Demo User'),
    coalesce(new.raw_user_meta_data->>'role', 'patwari'), -- default role
    coalesce(new.raw_user_meta_data->>'district', 'Nagpur') -- default district
  );
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- 2. Projects (the 10-field simplified creation form + geom)
create table public.projects (
  id uuid primary key default gen_random_uuid(),
  project_name text not null,
  project_type text not null check (
    project_type in ('Highway', 'Railway', 'Dam', 'Metro', 'Airport', 'Industrial Corridor', 'Smart City')
  ),
  district text not null,
  villages_affected text not null,
  total_land_area_hectares numeric not null,
  est_families_affected int not null,
  st_families int default 0,
  start_date date not null,
  target_handover_date date not null,
  forest_clearance text not null check (forest_clearance in ('Yes', 'No')),
  forest_clearance_applied boolean not null default false,
  avg_dept_response_days int not null default 10,
  status text not null default 'ONGOING' check (
    status in ('ONGOING', 'NOT_STARTED', 'COMPLETED', 'ON_HOLD')
  ),
  geom geography(Polygon, 4326),
  created_by uuid references public.profiles(id),
  created_at timestamptz default now()
);

-- 3. Family-wise ground data (entered by patwari)
create table public.families (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references public.projects(id) on delete cascade,
  family_name text not null,
  land_area_owned numeric,
  compensation_amount numeric,
  payment_status text default 'Not Calculated' check (
    payment_status in ('Paid', 'Pending', 'Not Calculated')
  ),
  objection_status text default 'None' check (
    objection_status in ('None', 'Filed', 'Resolved')
  ),
  court_case_status text default 'None' check (
    court_case_status in ('None', 'Active', 'Resolved')
  ),
  possession_status text default 'Occupied' check (
    possession_status in ('Vacated', 'Occupied', 'Refusing')
  ),
  court_case_filed_date date,
  verification_status text default 'Pending' check (
    verification_status in ('Pending', 'Verified', 'Rejected')
  ),
  entered_by uuid references public.profiles(id),
  created_at timestamptz default now()
);

-- 4. R&R progress (rehabilitation, keep minimal for MVP)
create table public.rehabilitation_status (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references public.projects(id) on delete cascade,
  colonies_planned int default 0,
  colonies_built int default 0,
  families_shifted int default 0,
  updated_at timestamptz default now()
);

-- 5. Snapshot of each risk calculation (so the dashboard can show trend over time)
create table public.risk_snapshots (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references public.projects(id) on delete cascade,
  risk_score int not null,
  delay_probability numeric not null,
  predicted_delay_months_min int,
  predicted_delay_months_max int,
  top_drivers jsonb, -- e.g. [{"driver": "Compensation Pending", "impact_pct": 32}, ...]
  recommendations jsonb, -- e.g. [{"action": "Hold compensation camp", "urgency": "URGENT", "days": 7}, ...]
  calculated_at timestamptz default now()
);

-- === Row Level Security ===
alter table public.projects enable row level security;
alter table public.families enable row level security;
alter table public.rehabilitation_status enable row level security;
alter table public.risk_snapshots enable row level security;
alter table public.profiles enable row level security;

-- Read the current user's profile without recursively evaluating profiles RLS.
create or replace function public.current_user_profile()
returns table (role text, district text)
language sql
security definer
set search_path = public
stable
as $$
  select p.role, p.district
  from public.profiles p
  where p.id = auth.uid()
  limit 1;
$$;

revoke all on function public.current_user_profile() from public;
grant execute on function public.current_user_profile() to authenticated;

-- Profiles: users can read their own profile
create policy "read own profile" on public.profiles
  for select using (auth.uid() = id);

-- Collector: sees all projects in their own district
create policy "collector reads own district projects" on public.projects
  for select using (
    exists (select 1 from public.current_user_profile() p
      where p.role = 'collector' and p.district = projects.district)
  );

-- Collector: can create projects in their own district
create policy "collector creates projects" on public.projects
  for insert with check (
    exists (select 1 from public.current_user_profile() p
      where p.role = 'collector' and p.district = projects.district)
  );

-- Collector: can update projects in their own district (e.g. forest clearance status)
create policy "collector updates own district projects" on public.projects
  for update using (
    exists (select 1 from public.current_user_profile() p
      where p.role = 'collector' and p.district = projects.district)
  );

-- Patwari: sees only projects in their district (read-only at project level)
create policy "patwari reads own district projects" on public.projects
  for select using (
    exists (select 1 from public.current_user_profile() p
      where p.role = 'patwari' and p.district = projects.district)
  );

-- Patwari: can insert/update family records for projects in their district
create policy "patwari manages families" on public.families
  for all using (
    exists (select 1 from public.current_user_profile() p
      join public.projects pr on pr.district = p.district
      where p.role = 'patwari' and pr.id = families.project_id)
  );

-- Collector: can read families for projects in their district (for dashboard)
create policy "collector reads families" on public.families
  for select using (
    exists (select 1 from public.current_user_profile() p
      join public.projects pr on pr.district = p.district
      where p.role = 'collector' and pr.id = families.project_id)
  );

-- Patwari: manages rehabilitation status for projects in their district
create policy "patwari manages rehabilitation status" on public.rehabilitation_status
  for all using (
    exists (select 1 from public.current_user_profile() p
      join public.projects pr on pr.district = p.district
      where p.role = 'patwari' and pr.id = rehabilitation_status.project_id)
  );

-- Collector: can read rehabilitation status for projects in their district
create policy "collector reads rehabilitation status" on public.rehabilitation_status
  for select using (
    exists (select 1 from public.current_user_profile() p
      join public.projects pr on pr.district = p.district
      where p.role = 'collector' and pr.id = rehabilitation_status.project_id)
  );

-- risk_snapshots: readable by anyone who can read the parent project
create policy "read risk snapshots for own district" on public.risk_snapshots
  for select using (
    exists (select 1 from public.current_user_profile() p
      join public.projects pr on pr.district = p.district
      where pr.id = risk_snapshots.project_id)
  );

-- === Reference Layers for PostGIS simulation ===
create table public.reference_villages (
  id serial primary key,
  village_name text not null,
  district text not null,
  geom geography(Polygon, 4326) not null
);

create table public.reference_forests (
  id serial primary key,
  forest_name text not null,
  geom geography(Polygon, 4326) not null
);

alter table public.reference_villages enable row level security;
alter table public.reference_forests enable row level security;

create policy "anyone reads reference_villages" on public.reference_villages
  for select using (true);

create policy "anyone reads reference_forests" on public.reference_forests
  for select using (true);

-- === Row Level Security policies for lao ===
-- LAO reads own district projects
create policy "lao reads own district projects" on public.projects
  for select using (
    exists (select 1 from public.current_user_profile() p
      where p.role = 'lao' and p.district = projects.district)
  );

-- LAO manages families (reads, updates verification)
create policy "lao manages families" on public.families
  for all using (
    exists (select 1 from public.current_user_profile() p
      join public.projects pr on pr.district = p.district
      where p.role = 'lao' and pr.id = families.project_id)
  );

-- LAO reads rehabilitation status
create policy "lao reads rehabilitation status" on public.rehabilitation_status
  for select using (
    exists (select 1 from public.current_user_profile() p
      join public.projects pr on pr.district = p.district
      where p.role = 'lao' and pr.id = rehabilitation_status.project_id)
  );

-- === Seed data ===
-- See scripts/seed.mjs for a full seed script (creates users, project, families,
-- and rehabilitation status matching the NH-44 demo example from the reference guide).
-- The manual insert below is kept only as a minimal reference.
-- insert into public.projects (project_name, project_type, district, villages_affected,
--   total_land_area_hectares, est_families_affected, st_families, start_date, target_handover_date,
--   forest_clearance, forest_clearance_applied, avg_dept_response_days, status, created_by)
-- values ('NH-44 Greenfield Highway Expansion', 'Highway', 'Nagpur', 'Rampur to Sonegaon',
--   1250, 847, 120, '2025-01-15', '2027-12-31', 'Yes', false, 18, 'ONGOING', '<collector-uuid>');

-- === Spatial Intersection Function ===
create or replace function public.spatial_check_project(project_geom geography)
returns table (
  calculated_area numeric,
  intersected_villages text,
  forest_intersects boolean
) language plpgsql security definer as $$
declare
  area_ha numeric;
  villages text;
  forest_needed boolean;
begin
  -- Calculate area in hectares (1 Ha = 10,000 sq meters)
  area_ha := round((ST_Area(project_geom) / 10000.0)::numeric, 2);

  -- Get names of intersecting villages
  select coalesce(string_agg(village_name, ', '), 'None')
  into villages
  from public.reference_villages
  where ST_Intersects(geom, project_geom);

  -- Check forest intersection
  select exists (
    select 1 from public.reference_forests
    where ST_Intersects(geom, project_geom)
  ) into forest_needed;

  return query select
    coalesce(area_ha, 0.0) as calculated_area,
    coalesce(villages, 'None') as intersected_villages,
    coalesce(forest_needed, false) as forest_intersects;
end;
$$;
