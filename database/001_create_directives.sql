-- Directives Table with Role-Based Row Level Security
create table if not exists public.directives (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references public.projects(id) on delete cascade,
  directive_type text not null check (directive_type in ('CAMP', 'LEGAL', 'SURVEY', 'FOREST', 'GENERAL')),
  title text not null,
  description text not null,
  target_days int not null default 7,
  assigned_to text not null check (assigned_to in ('LAO / Tehsildar', 'Patwari', 'lao', 'patwari')),
  status text not null default 'OPEN' check (status in ('OPEN', 'IN_PROGRESS', 'RESOLVED')),
  resolution_proof text,
  resolved_at timestamptz,
  resolved_by uuid references public.profiles(id),
  created_by uuid references public.profiles(id),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Enable RLS
alter table public.directives enable row level security;

-- Drop existing policies if any
drop policy if exists "Authenticated users can select directives" on public.directives;
drop policy if exists "Authenticated users can insert directives" on public.directives;
drop policy if exists "Authenticated users can update directives" on public.directives;
drop policy if exists "Allow all authenticated operations" on public.directives;

-- 1. Read: Any authenticated officer can view active directives
create policy "Authenticated users can select directives"
  on public.directives for select
  to authenticated
  using (true);

-- 2. Insert: District Collectors can dispatch directives
create policy "Authenticated users can insert directives"
  on public.directives for insert
  to authenticated
  with check (
    exists (
      select 1 from public.profiles
      where profiles.id = auth.uid()
      and profiles.role = 'collector'
    )
  );

-- 3. Update: Assigned officers (LAO, Patwari) or Collector can update status and resolution proof
create policy "Authenticated users can update directives"
  on public.directives for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles
      where profiles.id = auth.uid()
      and profiles.role in ('collector', 'lao', 'patwari')
    )
  )
  with check (
    exists (
      select 1 from public.profiles
      where profiles.id = auth.uid()
      and profiles.role in ('collector', 'lao', 'patwari')
    )
  );
