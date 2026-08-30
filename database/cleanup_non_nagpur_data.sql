-- =============================================================================
-- ONE-TIME DATABASE CLEANUP SCRIPT: NON-NAGPUR DATA PURGE
-- =============================================================================
-- Purpose: Safely deletes all project corridors and associated child records
--          (families, rehabilitation_status, directives, alerts, escrow_forecasts)
--          where the district is not 'Nagpur'.
--
-- Tables Affected (in topological foreign-key order):
--   1. public.families (via project_id CASCADE or explicit DELETE)
--   2. public.rehabilitation_status (via project_id)
--   3. public.directives (via project_id)
--   4. public.administrative_alerts (via project_id)
--   5. public.escrow_forecasts (via project_id)
--   6. public.projects (where district != 'Nagpur' or district IS NULL)
--
-- Instructions:
--   1. Review the dry-run SELECT counts below in Supabase SQL Editor.
--   2. Execute the TRANSACTION block to safely delete non-Nagpur rows.
-- =============================================================================

BEGIN;

-- Dry-Run / Audit Preview: Check what would be affected
-- SELECT id, project_name, district FROM public.projects WHERE district IS DISTINCT FROM 'Nagpur';

-- 1. Delete dependent family records for non-Nagpur projects
DELETE FROM public.families
WHERE project_id IN (
  SELECT id FROM public.projects WHERE district IS DISTINCT FROM 'Nagpur'
);

-- 2. Delete dependent rehabilitation status records for non-Nagpur projects
DELETE FROM public.rehabilitation_status
WHERE project_id IN (
  SELECT id FROM public.projects WHERE district IS DISTINCT FROM 'Nagpur'
);

-- 3. Delete dependent administrative directives for non-Nagpur projects
DELETE FROM public.directives
WHERE project_id IN (
  SELECT id FROM public.projects WHERE district IS DISTINCT FROM 'Nagpur'
);

-- 4. Delete dependent administrative alerts if table exists
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'administrative_alerts') THEN
    DELETE FROM public.administrative_alerts
    WHERE project_id IN (
      SELECT id FROM public.projects WHERE district IS DISTINCT FROM 'Nagpur'
    );
  END IF;
END $$;

-- 5. Delete dependent escrow forecasts if table exists
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'escrow_forecasts') THEN
    DELETE FROM public.escrow_forecasts
    WHERE project_id IN (
      SELECT id FROM public.projects WHERE district IS DISTINCT FROM 'Nagpur'
    );
  END IF;
END $$;

-- 6. Delete the non-Nagpur project records
DELETE FROM public.projects
WHERE district IS DISTINCT FROM 'Nagpur';

COMMIT;
