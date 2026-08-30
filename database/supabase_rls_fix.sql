-- =============================================================================
-- COMPLETE SUPABASE RLS & RECURSION FIX (CANONICAL SCRIPT)
-- =============================================================================
-- Purpose: Resolves PostgreSQL error 42P17 ("infinite recursion detected in
--          policy for relation 'profiles'") and establishes strict, role-based
--          access control across all administrative tables.
--
-- Instructions:
--   Copy and run this entire script in your Supabase SQL Editor.
-- =============================================================================

BEGIN;

-- ── 1. Fix Recursive Policy on public.profiles ──────────────────────────────
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "read own profile" ON public.profiles;
DROP POLICY IF EXISTS "users read own profile" ON public.profiles;
DROP POLICY IF EXISTS "profiles_select_policy" ON public.profiles;
DROP POLICY IF EXISTS "profiles_read_all" ON public.profiles;
DROP POLICY IF EXISTS "allow all reads on profiles" ON public.profiles;
DROP POLICY IF EXISTS "profiles_user_read" ON public.profiles;

-- Direct, non-recursive RLS policy: users read only their own row
CREATE POLICY "read own profile" ON public.profiles
  FOR SELECT USING (auth.uid() = id);

-- ── 2. Create Security-Definer Profile Helper Function ──────────────────────
-- SECURITY DEFINER ensures this function runs with table owner permissions,
-- bypassing RLS on profiles when called inside policies of other tables.
CREATE OR REPLACE FUNCTION public.current_user_profile()
RETURNS TABLE (role text, district text)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
STABLE
AS $$
  SELECT p.role, p.district
  FROM public.profiles p
  WHERE p.id = auth.uid()
  LIMIT 1;
$$;

REVOKE ALL ON FUNCTION public.current_user_profile() FROM public;
GRANT EXECUTE ON FUNCTION public.current_user_profile() TO authenticated;

-- ── 3. Clean and Recreate Policies on public.projects ───────────────────────
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "collector reads own district projects" ON public.projects;
DROP POLICY IF EXISTS "collector creates projects" ON public.projects;
DROP POLICY IF EXISTS "collector updates own district projects" ON public.projects;
DROP POLICY IF EXISTS "patwari reads own district projects" ON public.projects;
DROP POLICY IF EXISTS "lao reads own district projects" ON public.projects;
DROP POLICY IF EXISTS "read projects for own district" ON public.projects;

CREATE POLICY "collector reads own district projects" ON public.projects
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.current_user_profile() p
      WHERE p.role = 'collector' AND p.district = projects.district)
  );

CREATE POLICY "collector creates projects" ON public.projects
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM public.current_user_profile() p
      WHERE p.role = 'collector' AND p.district = projects.district)
  );

CREATE POLICY "collector updates own district projects" ON public.projects
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM public.current_user_profile() p
      WHERE p.role = 'collector' AND p.district = projects.district)
  );

CREATE POLICY "patwari reads own district projects" ON public.projects
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.current_user_profile() p
      WHERE p.role = 'patwari' AND p.district = projects.district)
  );

CREATE POLICY "lao reads own district projects" ON public.projects
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.current_user_profile() p
      WHERE p.role = 'lao' AND p.district = projects.district)
  );

-- ── 4. Clean and Recreate Policies on public.families ───────────────────────
ALTER TABLE public.families ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "patwari manages families" ON public.families;
DROP POLICY IF EXISTS "collector reads families" ON public.families;
DROP POLICY IF EXISTS "lao manages families" ON public.families;

CREATE POLICY "patwari manages families" ON public.families
  FOR ALL USING (
    EXISTS (SELECT 1 FROM public.current_user_profile() p
      JOIN public.projects pr ON pr.district = p.district
      WHERE p.role = 'patwari' AND pr.id = families.project_id)
  );

CREATE POLICY "collector reads families" ON public.families
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.current_user_profile() p
      JOIN public.projects pr ON pr.district = p.district
      WHERE p.role = 'collector' AND pr.id = families.project_id)
  );

CREATE POLICY "lao manages families" ON public.families
  FOR ALL USING (
    EXISTS (SELECT 1 FROM public.current_user_profile() p
      JOIN public.projects pr ON pr.district = p.district
      WHERE p.role = 'lao' AND pr.id = families.project_id)
  );

-- ── 5. Clean and Recreate Policies on public.rehabilitation_status ──────────
ALTER TABLE public.rehabilitation_status ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "patwari manages rehabilitation status" ON public.rehabilitation_status;
DROP POLICY IF EXISTS "collector reads rehabilitation status" ON public.rehabilitation_status;
DROP POLICY IF EXISTS "lao reads rehabilitation status" ON public.rehabilitation_status;

CREATE POLICY "patwari manages rehabilitation status" ON public.rehabilitation_status
  FOR ALL USING (
    EXISTS (SELECT 1 FROM public.current_user_profile() p
      JOIN public.projects pr ON pr.district = p.district
      WHERE p.role = 'patwari' AND pr.id = rehabilitation_status.project_id)
  );

CREATE POLICY "collector reads rehabilitation status" ON public.rehabilitation_status
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.current_user_profile() p
      JOIN public.projects pr ON pr.district = p.district
      WHERE p.role = 'collector' AND pr.id = rehabilitation_status.project_id)
  );

CREATE POLICY "lao reads rehabilitation status" ON public.rehabilitation_status
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.current_user_profile() p
      JOIN public.projects pr ON pr.district = p.district
      WHERE p.role = 'lao' AND pr.id = rehabilitation_status.project_id)
  );

-- ── 6. Clean and Recreate Policies on public.directives ─────────────────────
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'directives') THEN
    ALTER TABLE public.directives ENABLE ROW LEVEL SECURITY;
    DROP POLICY IF EXISTS "directives_access_policy" ON public.directives;
    DROP POLICY IF EXISTS "directives_all_authenticated" ON public.directives;
    
    CREATE POLICY "directives_access_policy" ON public.directives
      FOR ALL USING (auth.role() = 'authenticated');
  END IF;
END $$;

-- ── 7. Clean and Recreate Policies on public.risk_snapshots ─────────────────
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'risk_snapshots') THEN
    ALTER TABLE public.risk_snapshots ENABLE ROW LEVEL SECURITY;
    DROP POLICY IF EXISTS "read risk snapshots for own district" ON public.risk_snapshots;

    CREATE POLICY "read risk snapshots for own district" ON public.risk_snapshots
      FOR SELECT USING (
        EXISTS (SELECT 1 FROM public.current_user_profile() p
          JOIN public.projects pr ON pr.district = p.district
          WHERE pr.id = risk_snapshots.project_id)
      );
  END IF;
END $$;

COMMIT;
