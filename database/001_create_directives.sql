-- Directives Table with Scoped Role-Based Row Level Security
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
drop policy if exists "Scoped directive select policy" on public.directives;
drop policy if exists "Scoped directive insert policy" on public.directives;
drop policy if exists "Scoped directive update policy" on public.directives;

-- 1. Scoped Read: Collectors see all; LAO/Patwari see directives assigned to their role
create policy "Scoped directive select policy"
  on public.directives for select
  to authenticated
  using (
    exists (
      select 1 from public.profiles
      where profiles.id = auth.uid()
      and (
        profiles.role = 'collector'
        or (profiles.role = 'lao' and directives.assigned_to in ('LAO / Tehsildar', 'lao'))
        or (profiles.role = 'patwari' and directives.assigned_to in ('Patwari', 'patwari'))
      )
    )
  );

-- 2. Insert: Only District Collectors can dispatch executive directives
create policy "Scoped directive insert policy"
  on public.directives for insert
  to authenticated
  with check (
    exists (
      select 1 from public.profiles
      where profiles.id = auth.uid()
      and profiles.role = 'collector'
    )
  );

-- 3. Update: Collector can update any; Assignees can only update directives assigned to them
create policy "Scoped directive update policy"
  on public.directives for update
  to authenticated
  using (
    exists (
      select 1 from public.profiles
      where profiles.id = auth.uid()
      and (
        profiles.role = 'collector'
        or (profiles.role = 'lao' and directives.assigned_to in ('LAO / Tehsildar', 'lao'))
        or (profiles.role = 'patwari' and directives.assigned_to in ('Patwari', 'patwari'))
      )
    )
  )
  with check (
    exists (
      select 1 from public.profiles
      where profiles.id = auth.uid()
      and (
        profiles.role = 'collector'
        or (profiles.role = 'lao' and directives.assigned_to in ('LAO / Tehsildar', 'lao'))
        or (profiles.role = 'patwari' and directives.assigned_to in ('Patwari', 'patwari'))
      )
    )
  );
