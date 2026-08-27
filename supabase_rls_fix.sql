-- Run this in Supabase SQL Editor for an existing database.
-- It fixes: infinite recursion detected in policy for relation "profiles".

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

drop policy if exists "collector reads own district projects" on public.projects;
drop policy if exists "collector creates projects" on public.projects;
drop policy if exists "collector updates own district projects" on public.projects;
drop policy if exists "patwari reads own district projects" on public.projects;
drop policy if exists "lao reads own district projects" on public.projects;
drop policy if exists "patwari manages families" on public.families;
drop policy if exists "collector reads families" on public.families;
drop policy if exists "lao manages families" on public.families;
drop policy if exists "patwari manages rehabilitation status" on public.rehabilitation_status;
drop policy if exists "collector reads rehabilitation status" on public.rehabilitation_status;
drop policy if exists "lao reads rehabilitation status" on public.rehabilitation_status;
drop policy if exists "read risk snapshots for own district" on public.risk_snapshots;

create policy "collector reads own district projects" on public.projects for select using (
  exists (select 1 from public.current_user_profile() p
    where p.role = 'collector' and p.district = projects.district)
);
create policy "collector creates projects" on public.projects for insert with check (
  exists (select 1 from public.current_user_profile() p
    where p.role = 'collector' and p.district = projects.district)
);
create policy "collector updates own district projects" on public.projects for update using (
  exists (select 1 from public.current_user_profile() p
    where p.role = 'collector' and p.district = projects.district)
);
create policy "patwari reads own district projects" on public.projects for select using (
  exists (select 1 from public.current_user_profile() p
    where p.role = 'patwari' and p.district = projects.district)
);
create policy "lao reads own district projects" on public.projects for select using (
  exists (select 1 from public.current_user_profile() p
    where p.role = 'lao' and p.district = projects.district)
);

create policy "patwari manages families" on public.families for all using (
  exists (select 1 from public.current_user_profile() p
    join public.projects pr on pr.district = p.district
    where p.role = 'patwari' and pr.id = families.project_id)
);
create policy "collector reads families" on public.families for select using (
  exists (select 1 from public.current_user_profile() p
    join public.projects pr on pr.district = p.district
    where p.role = 'collector' and pr.id = families.project_id)
);
create policy "lao manages families" on public.families for all using (
  exists (select 1 from public.current_user_profile() p
    join public.projects pr on pr.district = p.district
    where p.role = 'lao' and pr.id = families.project_id)
);

create policy "patwari manages rehabilitation status" on public.rehabilitation_status for all using (
  exists (select 1 from public.current_user_profile() p
    join public.projects pr on pr.district = p.district
    where p.role = 'patwari' and pr.id = rehabilitation_status.project_id)
);
create policy "collector reads rehabilitation status" on public.rehabilitation_status for select using (
  exists (select 1 from public.current_user_profile() p
    join public.projects pr on pr.district = p.district
    where p.role = 'collector' and pr.id = rehabilitation_status.project_id)
);
create policy "lao reads rehabilitation status" on public.rehabilitation_status for select using (
  exists (select 1 from public.current_user_profile() p
    join public.projects pr on pr.district = p.district
    where p.role = 'lao' and pr.id = rehabilitation_status.project_id)
);

create policy "read risk snapshots for own district" on public.risk_snapshots for select using (
  exists (select 1 from public.current_user_profile() p
    join public.projects pr on pr.district = p.district
    where pr.id = risk_snapshots.project_id)
);
