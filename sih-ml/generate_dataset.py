"""
SIH 2026: High-Variance Continuous Balanced Synthetic Dataset Generator
Injects continuous stochastic noise across 4 realistic personas ensuring
an even distribution across all 4 risk strata (LOW, MODERATE, HIGH, CRITICAL).
"""

import numpy as np
import pandas as pd

np.random.seed(42)
N_TOTAL = 6000

WEIGHTS = {
    "compensation": 0.28,
    "approvals_forest": 0.18,
    "right_of_way": 0.16,
    "litigation": 0.16,
    "lao_backlog": 0.12,
    "rr_progress": 0.10,
}

def score_row(
    compensation_paid_pct, court_cases_active, court_cases_recent_90d,
    court_case_avg_age_days, rr_progress_pct, possession_refusing_pct,
    forest_clearance_applied, days_since_forest_clearance_needed,
    months_elapsed, months_total, dept_response_days, st_families,
    lao_backlog_ratio, political_cycle_proximity, document_rejection_rate,
    is_schedule_v_tribal, is_forest_land, is_urban_commercial,
    persona,
):
    comp_risk = (100.0 - compensation_paid_pct)

    if forest_clearance_applied:
        forest_risk = 15.0 if is_forest_land else 0.0
    else:
        forest_risk = min(100.0, max(20.0, (days_since_forest_clearance_needed / 180.0) * 100.0))
    if is_forest_land and not forest_clearance_applied:
        forest_risk = min(100.0, forest_risk * 1.25)

    row_risk = min(100.0, possession_refusing_pct * 2.0)
    if is_schedule_v_tribal:
        row_risk = min(100.0, row_risk * 1.3 + (st_families / 10.0))

    legal_risk = min(
        100.0,
        (court_cases_active * 8.0)
        + (court_cases_recent_90d * 12.0)
        + (min(365.0, court_case_avg_age_days) / 365.0) * 15.0
    )

    backlog_risk = min(100.0, max(0.0, (lao_backlog_ratio - 1.0) * 20.0))
    rr_risk = max(0.0, 100.0 - rr_progress_pct)

    raw_score = (
        WEIGHTS["compensation"] * comp_risk
        + WEIGHTS["approvals_forest"] * forest_risk
        + WEIGHTS["right_of_way"] * row_risk
        + WEIGHTS["litigation"] * legal_risk
        + WEIGHTS["lao_backlog"] * backlog_risk
        + WEIGHTS["rr_progress"] * rr_risk
    )

    if is_schedule_v_tribal or st_families > 0:
        raw_score = min(100.0, raw_score + 4.0)

    # Dynamic noise injection for continuous distribution
    noise = np.random.normal(0, 2.0)
    final_score = float(np.clip(raw_score + noise, 12.0, 94.0))

    if final_score < 24.0:
        risk_level = "LOW"
    elif final_score < 44.0:
        risk_level = "MODERATE"
    elif final_score < 68.0:
        risk_level = "HIGH"
    else:
        risk_level = "CRITICAL"

    # Monotonically relatable actual delay months
    base_delay_months = (final_score / 100.0) * 28.0
    if risk_level == "LOW":
        base_delay_months = np.random.uniform(0.0, 2.5)
    elif risk_level == "MODERATE":
        base_delay_months = np.random.uniform(3.0, 7.5)
    elif risk_level == "HIGH":
        base_delay_months = np.random.uniform(8.0, 15.0)
    else:
        base_delay_months = np.random.uniform(16.0, 32.0)

    actual_delay_months = round(float(np.clip(base_delay_months, 0.0, 48.0)), 1)
    actual_delay_days = int(round(actual_delay_months * 30.4))

    return final_score, risk_level, actual_delay_months, actual_delay_days


def sample_persona_LOW():
    """Persona LOW: Streamlined Highway / Metro Corridor."""
    total_land = round(float(np.random.uniform(20.0, 250.0)), 1)
    est_families = int(np.random.poisson(max(5, total_land * np.random.uniform(0.08, 0.15))))

    return dict(
        total_land_area_hectares=total_land,
        est_families_affected=est_families,
        is_schedule_v_tribal=0,
        is_forest_land=0,
        is_urban_commercial=int(np.random.choice([0, 1], p=[0.4, 0.6])),
        st_families=0,
        months_total=int(np.random.choice([18, 24, 30])),
        months_elapsed=int(np.random.uniform(4, 18)),
        compensation_paid_pct=round(float(np.random.uniform(75.0, 96.0)), 1),
        possession_refusing_pct=round(float(np.random.uniform(0.0, 8.0)), 1),
        rr_progress_pct=round(float(np.random.uniform(75.0, 98.0)), 1),
        court_cases_active=int(np.random.choice([0, 1, 2], p=[0.6, 0.3, 0.1])),
        court_cases_recent_90d=0,
        court_case_avg_age_days=float(np.random.uniform(10.0, 60.0)),
        forest_clearance_applied=True,
        days_since_forest_clearance_needed=0,
        dept_response_days=round(float(np.random.uniform(4.0, 9.0)), 1),
        lao_backlog_ratio=round(float(np.random.uniform(0.2, 0.9)), 2),
        political_cycle_proximity=int(np.random.uniform(12, 48)),
        document_rejection_rate=round(float(np.random.uniform(0.01, 0.08)), 3),
        stage_completed=int(np.random.choice([1, 0], p=[0.85, 0.15])),
        persona="LOW_streamlined",
    )


def sample_persona_MODERATE():
    """Persona MODERATE: Standard Urban / Semi-Urban Expansion."""
    total_land = round(float(np.random.uniform(50.0, 450.0)), 1)
    est_families = int(np.random.poisson(max(15, total_land * np.random.uniform(0.12, 0.22))))

    return dict(
        total_land_area_hectares=total_land,
        est_families_affected=est_families,
        is_schedule_v_tribal=0,
        is_forest_land=int(np.random.choice([0, 1], p=[0.8, 0.2])),
        is_urban_commercial=int(np.random.choice([0, 1], p=[0.5, 0.5])),
        st_families=int(est_families * np.random.uniform(0.0, 0.05)),
        months_total=int(np.random.choice([24, 36])),
        months_elapsed=int(np.random.uniform(8, 24)),
        compensation_paid_pct=round(float(np.random.uniform(58.0, 74.0)), 1),
        possession_refusing_pct=round(float(np.random.uniform(8.0, 18.0)), 1),
        rr_progress_pct=round(float(np.random.uniform(50.0, 72.0)), 1),
        court_cases_active=int(np.random.choice([2, 3, 4, 5], p=[0.3, 0.4, 0.2, 0.1])),
        court_cases_recent_90d=int(np.random.choice([0, 1], p=[0.7, 0.3])),
        court_case_avg_age_days=float(np.random.uniform(60.0, 180.0)),
        forest_clearance_applied=True,
        days_since_forest_clearance_needed=0,
        dept_response_days=round(float(np.random.uniform(9.0, 16.0)), 1),
        lao_backlog_ratio=round(float(np.random.uniform(1.1, 2.0)), 2),
        political_cycle_proximity=int(np.random.uniform(6, 40)),
        document_rejection_rate=round(float(np.random.uniform(0.08, 0.22)), 3),
        stage_completed=int(np.random.choice([1, 0], p=[0.65, 0.35])),
        persona="MODERATE_standard",
    )


def sample_persona_HIGH():
    """Persona HIGH: Aging Disputes & Administrative Backlog."""
    total_land = round(float(np.random.uniform(100.0, 800.0)), 1)
    est_families = int(np.random.poisson(max(30, total_land * np.random.uniform(0.18, 0.30))))

    return dict(
        total_land_area_hectares=total_land,
        est_families_affected=est_families,
        is_schedule_v_tribal=int(np.random.choice([0, 1], p=[0.7, 0.3])),
        is_forest_land=int(np.random.choice([0, 1], p=[0.6, 0.4])),
        is_urban_commercial=0,
        st_families=int(est_families * np.random.uniform(0.05, 0.25)),
        months_total=int(np.random.choice([36, 48])),
        months_elapsed=int(np.random.uniform(18, 38)),
        compensation_paid_pct=round(float(np.random.uniform(38.0, 56.0)), 1),
        possession_refusing_pct=round(float(np.random.uniform(20.0, 36.0)), 1),
        rr_progress_pct=round(float(np.random.uniform(25.0, 48.0)), 1),
        court_cases_active=int(np.random.choice([6, 7, 8, 9], p=[0.3, 0.3, 0.2, 0.2])),
        court_cases_recent_90d=int(np.random.choice([1, 2, 3], p=[0.5, 0.3, 0.2])),
        court_case_avg_age_days=float(np.random.uniform(180.0, 320.0)),
        forest_clearance_applied=bool(np.random.choice([True, False], p=[0.5, 0.5])),
        days_since_forest_clearance_needed=int(np.random.uniform(40, 120)) if np.random.rand() > 0.5 else 0,
        dept_response_days=round(float(np.random.uniform(16.0, 24.0)), 1),
        lao_backlog_ratio=round(float(np.random.uniform(2.2, 3.6)), 2),
        political_cycle_proximity=int(np.random.uniform(4, 30)),
        document_rejection_rate=round(float(np.random.uniform(0.25, 0.50)), 3),
        stage_completed=int(np.random.choice([1, 0], p=[0.50, 0.50])),
        persona="HIGH_backlog",
    )


def sample_persona_CRITICAL():
    """Persona CRITICAL: Severe Injunctions & Forest/Tribal Protected Land."""
    total_land = round(float(np.random.uniform(200.0, 1500.0)), 1)
    est_families = int(np.random.poisson(max(50, total_land * np.random.uniform(0.20, 0.35))))

    sched = np.random.choice(["schedule_v", "forest", "litigation"], p=[0.4, 0.3, 0.3])
    is_schedule_v = 1 if sched == "schedule_v" else 0
    is_forest = 1 if sched == "forest" else 0

    return dict(
        total_land_area_hectares=total_land,
        est_families_affected=est_families,
        is_schedule_v_tribal=is_schedule_v,
        is_forest_land=is_forest,
        is_urban_commercial=0,
        st_families=int(est_families * np.random.uniform(0.35, 0.75)) if is_schedule_v else int(est_families * 0.05),
        months_total=int(np.random.choice([36, 48, 60])),
        months_elapsed=int(np.random.uniform(24, 52)),
        compensation_paid_pct=round(float(np.random.uniform(12.0, 36.0)), 1),
        possession_refusing_pct=round(float(np.random.uniform(35.0, 65.0)), 1),
        rr_progress_pct=round(float(np.random.uniform(5.0, 24.0)), 1),
        court_cases_active=int(np.random.choice([10, 12, 14, 18], p=[0.3, 0.3, 0.2, 0.2])),
        court_cases_recent_90d=int(np.random.choice([2, 3, 4, 5], p=[0.3, 0.3, 0.2, 0.2])),
        court_case_avg_age_days=float(np.random.uniform(280.0, 550.0)),
        forest_clearance_applied=False if is_forest else bool(np.random.choice([True, False], p=[0.3, 0.7])),
        days_since_forest_clearance_needed=int(np.random.uniform(120, 360)),
        dept_response_days=round(float(np.random.uniform(20.0, 35.0)), 1),
        lao_backlog_ratio=round(float(np.random.uniform(3.5, 5.5)), 2),
        political_cycle_proximity=int(np.random.uniform(2, 24)),
        document_rejection_rate=round(float(np.random.uniform(0.45, 0.80)), 3),
        stage_completed=int(np.random.choice([1, 0], p=[0.40, 0.60])),
        persona="CRITICAL_injunction",
    )


PERSONAS = [
    sample_persona_LOW,
    sample_persona_MODERATE,
    sample_persona_HIGH,
    sample_persona_CRITICAL,
]


def generate():
    records = []
    # Perfectly balanced sampling across all 4 strata
    for _ in range(N_TOTAL):
        sampler = np.random.choice(PERSONAS)
        fields = sampler()
        fc = fields["forest_clearance_applied"]

        score, risk_level, delay_months, delay_days = score_row(
            compensation_paid_pct=fields["compensation_paid_pct"],
            court_cases_active=fields["court_cases_active"],
            court_cases_recent_90d=fields["court_cases_recent_90d"],
            court_case_avg_age_days=fields["court_case_avg_age_days"],
            rr_progress_pct=fields["rr_progress_pct"],
            possession_refusing_pct=fields["possession_refusing_pct"],
            forest_clearance_applied=fc,
            days_since_forest_clearance_needed=fields["days_since_forest_clearance_needed"],
            months_elapsed=fields["months_elapsed"],
            months_total=fields["months_total"],
            dept_response_days=fields["dept_response_days"],
            st_families=fields["st_families"],
            lao_backlog_ratio=fields["lao_backlog_ratio"],
            political_cycle_proximity=fields["political_cycle_proximity"],
            document_rejection_rate=fields["document_rejection_rate"],
            is_schedule_v_tribal=fields["is_schedule_v_tribal"],
            is_forest_land=fields["is_forest_land"],
            is_urban_commercial=fields["is_urban_commercial"],
            persona=fields["persona"],
        )

        records.append({
            "compensation_paid_pct": fields["compensation_paid_pct"],
            "court_cases_active": fields["court_cases_active"],
            "court_cases_recent_90d": fields["court_cases_recent_90d"],
            "court_case_avg_age_days": fields["court_case_avg_age_days"],
            "rr_progress_pct": fields["rr_progress_pct"],
            "possession_refusing_pct": fields["possession_refusing_pct"],
            "st_families": fields["st_families"],
            "forest_clearance_applied": int(fc),
            "days_since_forest_clearance_needed": fields["days_since_forest_clearance_needed"],
            "months_elapsed": fields["months_elapsed"],
            "months_total": fields["months_total"],
            "dept_response_days": fields["dept_response_days"],
            "total_land_area_hectares": fields["total_land_area_hectares"],
            "est_families_affected": fields["est_families_affected"],
            "lao_backlog_ratio": fields["lao_backlog_ratio"],
            "political_cycle_proximity": fields["political_cycle_proximity"],
            "document_rejection_rate": fields["document_rejection_rate"],
            "is_schedule_v_tribal": fields["is_schedule_v_tribal"],
            "is_forest_land": fields["is_forest_land"],
            "is_urban_commercial": fields["is_urban_commercial"],
            "stage_completed": fields["stage_completed"],
            "risk_score": round(score, 1),
            "risk_level": risk_level,
            "actual_delay_months": delay_months,
            "actual_delay_days": delay_days,
            "persona": fields["persona"],
        })

    df = pd.DataFrame(records)
    df.to_csv("synthetic_projects.csv", index=False)
    print(f"[DATASET GENERATOR] Generated {len(df)} balanced rows in synthetic_projects.csv")
    print("\nClass Distribution:")
    print(df["risk_level"].value_counts())
    return df


if __name__ == "__main__":
    generate()
