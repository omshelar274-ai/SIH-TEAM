-- ============================================================================
-- LandGuard v3.0: Production Supabase / PostgreSQL Schema
-- RFCTLARR Act 2013 ML Analytics Layer
-- Tables: administrative_alerts, escrow_forecasts
-- Indices: Optimized for sub-millisecond dashboard queries
-- ============================================================================

-- ── 1. administrative_alerts ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.administrative_alerts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID REFERENCES public.projects(id) ON DELETE CASCADE,
    alert_type TEXT NOT NULL CHECK (
        alert_type IN (
            'DEPENDENCY_BOTTLENECK',
            'SLA_BREACH_CASCADE',
            'PARALYZED_ESCROW_ALERT',
            'PROXY_LAWYER_POOLING',
            'TEMPLATED_LITIGATION_CARTEL',
            'SCHEDULE_V_OBJECTION',
            'HIGH_UNCERTAINTY_ENSEMBLE',
            'STATUTORY_SLA_OVERDUE'
        )
    ),
    risk_score INT NOT NULL CHECK (risk_score BETWEEN 0 AND 100),
    source_department TEXT NOT NULL,
    description TEXT NOT NULL,
    metadata_json JSONB DEFAULT '{}'::jsonb,
    status TEXT NOT NULL DEFAULT 'ACTIVE' CHECK (
        status IN ('ACTIVE', 'ACKNOWLEDGED', 'RESOLVED', 'DISMISSED')
    ),
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- ── 2. escrow_forecasts ─────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.escrow_forecasts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID REFERENCES public.projects(id) ON DELETE CASCADE,
    total_budget NUMERIC(15, 2) NOT NULL,
    litigated_amt_frozen NUMERIC(15, 2) NOT NULL,
    unlitigated_amt_active NUMERIC(15, 2) NOT NULL,
    paralyzed_capital_pct NUMERIC(5, 2) NOT NULL,
    recommended_diversion_amt NUMERIC(15, 2) NOT NULL,
    statutory_retained_escrow NUMERIC(15, 2) NOT NULL,
    target_alternative_project_id UUID REFERENCES public.projects(id) ON DELETE SET NULL,
    recommendation_summary TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'PROPOSED' CHECK (
        status IN ('PROPOSED', 'APPROVED_BY_COLLECTOR', 'DISBURSED', 'REJECTED')
    ),
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- ── 3. Performance Indices ──────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_admin_alerts_project   ON public.administrative_alerts(project_id);
CREATE INDEX IF NOT EXISTS idx_admin_alerts_type      ON public.administrative_alerts(alert_type);
CREATE INDEX IF NOT EXISTS idx_admin_alerts_score     ON public.administrative_alerts(risk_score DESC);
CREATE INDEX IF NOT EXISTS idx_admin_alerts_status    ON public.administrative_alerts(status, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_escrow_project         ON public.escrow_forecasts(project_id);
CREATE INDEX IF NOT EXISTS idx_escrow_created         ON public.escrow_forecasts(created_at DESC);

-- ── 4. Row Level Security ───────────────────────────────────────────────────
ALTER TABLE public.administrative_alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.escrow_forecasts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "auth_read_alerts" ON public.administrative_alerts;
CREATE POLICY "auth_read_alerts" ON public.administrative_alerts
    FOR ALL TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "auth_read_escrow" ON public.escrow_forecasts;
CREATE POLICY "auth_read_escrow" ON public.escrow_forecasts
    FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ── 5. Seed Mock Alert Records ──────────────────────────────────────────────
DO $$
DECLARE
    v_ring UUID; v_ibfc UUID; v_metro UUID; v_mihan UUID;
BEGIN
    SELECT id INTO v_ring FROM public.projects WHERE project_name ILIKE '%Ring Road%' LIMIT 1;
    SELECT id INTO v_ibfc FROM public.projects WHERE project_name ILIKE '%New Nagpur%' OR project_name ILIKE '%IBFC%' LIMIT 1;
    SELECT id INTO v_metro FROM public.projects WHERE project_name ILIKE '%Metro%' LIMIT 1;
    SELECT id INTO v_mihan FROM public.projects WHERE project_name ILIKE '%MIHAN%' LIMIT 1;

    IF v_ring IS NOT NULL THEN
        INSERT INTO public.administrative_alerts
            (project_id, alert_type, risk_score, source_department, description, metadata_json)
        VALUES
            (v_ring, 'TEMPLATED_LITIGATION_CARTEL', 92, 'Revenue Sub-Division Hingna',
             'Coordinated speculative litigation: 8 contiguous surveys in Waddhamna with identical boilerplate by proxy advocate.',
             '{"advocate":"Adv. S.K. Deshpande","surveys":["114/1A","114/2","115/1","118/3"]}'::jsonb),
            (v_ring, 'DEPENDENCY_BOTTLENECK', 86, 'Forest & Environment Dept',
             'Stage-1 Tree Felling NOC overdue 48 days past SLA. Cascading 76-day delay onto PWD earthworks.',
             '{"sla_days":45,"elapsed":93,"cascade_days":76,"cost_escalation_pct":4.2}'::jsonb),
            (v_ring, 'HIGH_UNCERTAINTY_ENSEMBLE', 71, 'ML Ensemble Engine',
             'RSF and CPH models disagree by 22% on 90-day clearance probability for Waddhamna segment.',
             '{"rsf_hr":3.45,"cph_hr":2.12,"disagreement_pct":22.1}'::jsonb);
    END IF;

    IF v_ibfc IS NOT NULL THEN
        INSERT INTO public.administrative_alerts
            (project_id, alert_type, risk_score, source_department, description, metadata_json)
        VALUES
            (v_ibfc, 'PARALYZED_ESCROW_ALERT', 88, 'NMRDA Finance Wing',
             '42.5% of Phase-1 acquisition outlay paralyzed in HC compensation enhancement disputes (Godhani/Ladgaon).',
             '{"frozen_inr":48500000,"affected_farmers":34}'::jsonb),
            (v_ibfc, 'SCHEDULE_V_OBJECTION', 78, 'Tribal Development Dept',
             'PESA/FRA 2006 Gram Sabha consent pending for 12 families in Mouza Godhani. Section 41 RFCTLARR triggered.',
             '{"gram_sabha_status":"PENDING","families":12,"section":"41"}'::jsonb);
    END IF;

    IF v_ring IS NOT NULL AND v_metro IS NOT NULL THEN
        INSERT INTO public.escrow_forecasts
            (project_id, total_budget, litigated_amt_frozen, unlitigated_amt_active,
             paralyzed_capital_pct, recommended_diversion_amt, statutory_retained_escrow,
             target_alternative_project_id, recommendation_summary)
        VALUES
            (v_ring, 184000000.00, 73600000.00, 110400000.00, 40.00,
             51520000.00, 22080000.00, v_metro,
             'Divert INR 5.15 Cr of frozen Waddhamna escrow to clear Section 3G vouchers on Nagpur Metro Kanhan extension.');
    END IF;

    RAISE NOTICE 'LandGuard v3.0 schema and seed records initialized.';
END $$;
