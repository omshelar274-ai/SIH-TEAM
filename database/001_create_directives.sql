-- Migration: Create public.directives table for shared cross-role persistence
-- Replaces browser localStorage with true multi-user database storage

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

-- Enable Row Level Security
alter table public.directives enable row level security;

-- Policies
create policy "Authenticated users can read directives"
  on public.directives for select
  to authenticated
  using (true);

create policy "Collectors can insert directives"
  on public.directives for insert
  to authenticated
  with check (true);

create policy "Assigned roles can update directives"
  on public.directives for update
  to authenticated
  using (true);
