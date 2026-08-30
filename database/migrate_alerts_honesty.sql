-- =============================================================================
-- ONE-TIME DATABASE MIGRATION: ADMINISTRATIVE ALERTS HONESTY UPDATE
-- =============================================================================
-- Purpose: 1. Updates table check constraint to allow HIGH_UNCERTAINTY_SURVIVAL_ESTIMATE
--          2. Updates existing active row from HIGH_UNCERTAINTY_ENSEMBLE
--
-- Instructions:
--   Copy and run this entire block in your Supabase SQL Editor.
-- =============================================================================

BEGIN;

-- 1. Drop the old constraint that only allowed HIGH_UNCERTAINTY_ENSEMBLE
ALTER TABLE public.administrative_alerts 
  DROP CONSTRAINT IF EXISTS check_alert_type;

ALTER TABLE public.administrative_alerts 
  DROP CONSTRAINT IF EXISTS administrative_alerts_alert_type_check;

-- 2. Update the row first
UPDATE public.administrative_alerts
SET 
  alert_type = 'HIGH_UNCERTAINTY_SURVIVAL_ESTIMATE',
  source_department = 'Survival Analysis Engine',
  description = 'Elevated variance in 90-day clearance probability estimation for Waddhamna segment due to complex litigation age dispersion.',
  metadata_json = '{"hazard_ratio": 2.41, "confidence_interval_width": 0.22, "statutory_uncertainty": "HIGH"}'::jsonb
WHERE alert_type = 'HIGH_UNCERTAINTY_ENSEMBLE';

-- 3. Re-add the clean CHECK constraint
ALTER TABLE public.administrative_alerts 
  ADD CONSTRAINT check_alert_type CHECK (
    alert_type IN (
      'DEPENDENCY_BOTTLENECK',
      'SLA_BREACH_CASCADE',
      'PARALYZED_ESCROW_ALERT',
      'PROXY_LAWYER_POOLING',
      'TEMPLATED_LITIGATION_CARTEL',
      'SCHEDULE_V_OBJECTION',
      'HIGH_UNCERTAINTY_SURVIVAL_ESTIMATE',
      'STATUTORY_SLA_OVERDUE'
    )
  );

COMMIT;
