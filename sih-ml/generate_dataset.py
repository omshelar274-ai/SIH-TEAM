"""
Generates a synthetic dataset of ~1150 'past completed' land acquisition
projects for training the risk model.

DATA GROUNDING — weights used to generate ground truth below, and why. All
sources independently verified (fetched the actual paper/portal, not just
trusted a summary):

  - Compensation/land acquisition as the TOP driver, weight 35%: doubly
    grounded — (1) PRAGATI review, Jan 2026: of 7,156 resolved central
    infra-project issues, 35% were land acquisition, the single largest
    category (source: Cabinet Secretary T.V. Somanathan, PTI/ThePrint/
    BusinessToday, Jan 2026); (2) Devi & Sindhu (2025), peer-reviewed,
    J. Inst. Eng. India Ser. A, DOI 10.1007/s40030-025-00899-5: land
    acquisition has RII=0.68 for ROAD projects specifically — higher than
    every other delay category the paper measured (material 0.562, site
    0.555, contractor 0.506).
  - Approvals/clearances: 22% — PRAGATI: forest/wildlife/environment
    clearance was 20% of resolved issues; rounded up slightly to also
    cover generic pending-approval delays. Also groups under Devi &
    Sindhu's "Government & External Factors" PCA dimension alongside land
    acquisition.
  - Right-of-way / possession: 18% — PRAGATI's third category (18%).
  - Litigation: 15% — not isolated as its own category in either primary
    source above (Devi & Sindhu's 25 factors are general construction
    delay causes, not land-acquisition sub-causes); kept as a substantial
    but more heuristic weight.
  - R&R progress: 7% — not independently quantified by any source found.
  - Admin/coordination/other: 3% — PRAGATI's remaining categories (law and
    order, construction, power utility, financial).
  - Random Forest as the model family: independently validated, not just
    assumed — Andrić et al. (2025, KSCE J. Civil Eng., DOI
    10.1016/j.kscej.2025.100209) and Andrić et al. (2024, Sustainability,
    DOI 10.3390/su162411159) both found Random Forest outperforms
    linear/quadratic regression for South Asian infrastructure delay/cost
    prediction, using a 138-project database (83 India, from ADB
    completion reports + MoSPI).

This is a heuristic synthesis of real, verified, cited sources — NOT a
statistical fit to real outcome data (no public dataset links project-level
features to actual delay durations for India specifically). Say so plainly
if asked. See README.md for full citations and verification notes.

Usage:
    pip install pandas numpy --break-system-packages
    python generate_dataset.py
Outputs: synthetic_projects.csv
"""

import numpy as np
import pandas as pd

np.random.seed(42)
N = 4500

WEIGHTS = {
    "compensation": 0.35,
    "approvals": 0.22,
    "right_of_way": 0.18,
    "legal": 0.15,
    "rr": 0.07,
    "admin": 0.03,
}


def score_row(
    compensation_paid_pct,
    court_cases_active,
    court_cases_recent_90d,
    court_case_avg_age_days,
    rr_progress_pct,
    possession_refusing_pct,
    forest_clearance_applied,
    days_since_forest_clearance_needed,
    months_elapsed,
    months_total,
    dept_response_days,
    st_families,
    noise_std,
):
    compensation_risk = 100 - compensation_paid_pct
    approvals_risk = (
        20
        if forest_clearance_applied
        else min(100, (days_since_forest_clearance_needed / 120) * 100)
    )
    right_of_way_risk = possession_refusing_pct

    # Litigation delay risk is weighted by case age and recent velocity/trend
    legal_risk = min(
        100,
        (court_cases_active / 15) * 60
        + (court_cases_recent_90d / 5) * 20
        + (min(365, court_case_avg_age_days) / 365) * 20
    )

    rr_risk = 100 - rr_progress_pct
    time_elapsed_pct = (months_elapsed / months_total) * 100
    schedule_risk = max(0, 70 - (100 - time_elapsed_pct))
    admin_risk = min(100, (dept_response_days / 7) * 40)

    base_score = (
        compensation_risk * WEIGHTS["compensation"]
        + approvals_risk * WEIGHTS["approvals"]
        + right_of_way_risk * WEIGHTS["right_of_way"]
        + legal_risk * WEIGHTS["legal"]
        + rr_risk * WEIGHTS["rr"]
        + ((schedule_risk + admin_risk) / 2) * WEIGHTS["admin"]
    )
    if st_families > 0:
        base_score = min(100, base_score + 5)

    noisy_score = np.clip(base_score + np.random.normal(0, noise_std), 0, 100)
    risk_score = round(noisy_score)

    if risk_score >= 85:
        risk_level = "CRITICAL"
        actual_delay_months = np.random.randint(10, 18)
    elif risk_score >= 60:
        risk_level = "HIGH"
        actual_delay_months = np.random.randint(4, 10)
    elif risk_score >= 40:
        risk_level = "MODERATE"
        actual_delay_months = np.random.randint(1, 5)
    else:
        risk_level = "LOW"
        actual_delay_months = np.random.randint(0, 3)

    return risk_score, risk_level, actual_delay_months


def generate_severe_row():
    """
    Deliberately stacks multiple bad factors together — natural random
    distributions rarely produce a project that's bad on every axis at once,
    but real CRITICAL projects usually are.
    """
    compensation_paid_pct = np.random.uniform(5, 35)
    court_cases_active = np.random.randint(18, 35)
    court_cases_recent_90d = np.random.randint(6, court_cases_active + 1)
    court_case_avg_age_days = np.random.uniform(180, 900)
    rr_progress_pct = np.random.uniform(5, 35)
    possession_refusing_pct = np.random.uniform(35, 70)
    st_families = np.random.choice([0, np.random.randint(50, 200)], p=[0.25, 0.75])
    forest_clearance_applied = np.random.choice([True, False], p=[0.1, 0.9])
    days_since_forest_clearance_needed = (
        np.random.randint(130, 280) if not forest_clearance_applied else 0
    )
    months_total = np.random.choice([24, 30, 36, 48])
    months_elapsed = int(months_total * np.random.uniform(0.55, 0.8))
    dept_response_days = np.random.uniform(16, 32)
    total_land_area_hectares = np.random.uniform(200, 2500)
    est_families_affected = np.random.randint(200, 1500)

    risk_score, risk_level, actual_delay_months = score_row(
        compensation_paid_pct,
        court_cases_active,
        court_cases_recent_90d,
        court_case_avg_age_days,
        rr_progress_pct,
        possession_refusing_pct,
        forest_clearance_applied,
        days_since_forest_clearance_needed,
        months_elapsed,
        months_total,
        dept_response_days,
        st_families,
        noise_std=3,
    )

    return {
        "compensation_paid_pct": round(compensation_paid_pct, 1),
        "court_cases_active": court_cases_active,
        "court_cases_recent_90d": court_cases_recent_90d,
        "court_case_avg_age_days": round(court_case_avg_age_days, 1),
        "rr_progress_pct": round(rr_progress_pct, 1),
        "possession_refusing_pct": round(possession_refusing_pct, 1),
        "st_families": st_families,
        "forest_clearance_applied": forest_clearance_applied,
        "days_since_forest_clearance_needed": days_since_forest_clearance_needed,
        "months_elapsed": months_elapsed,
        "months_total": months_total,
        "dept_response_days": round(dept_response_days, 1),
        "total_land_area_hectares": round(total_land_area_hectares, 1),
        "est_families_affected": est_families_affected,
        "risk_score": risk_score,
        "risk_level": risk_level,
        "actual_delay_months": actual_delay_months,
    }


def generate_row():
    # Skewed toward more realistic "projects being monitored"
    compensation_paid_pct = np.clip(np.random.beta(1.6, 2.2) * 100, 0, 100)
    court_cases_active = np.clip(np.random.poisson(9), 0, 40)
    if court_cases_active > 0:
        court_cases_recent_90d = np.random.binomial(court_cases_active, 0.3)
        court_case_avg_age_days = np.random.uniform(30, 730)
    else:
        court_cases_recent_90d = 0
        court_case_avg_age_days = 0.0

    rr_progress_pct = np.clip(np.random.beta(1.6, 2.4) * 100, 0, 100)
    possession_refusing_pct = np.clip(np.random.beta(1.5, 3) * 100, 0, 100)
    st_families = np.random.choice(
        [0, 0, 0, np.random.randint(10, 200)], p=[0.4, 0.2, 0.2, 0.2]
    )
    forest_clearance_required = np.random.choice([True, False], p=[0.6, 0.4])
    forest_clearance_applied = (
        np.random.choice([True, False], p=[0.35, 0.65])
        if forest_clearance_required
        else True
    )
    days_since_forest_clearance_needed = (
        int(np.random.exponential(110))
        if (forest_clearance_required and not forest_clearance_applied)
        else 0
    )
    months_total = np.random.choice([18, 24, 30, 36, 48, 60])
    months_elapsed = np.random.randint(1, months_total + 6)
    dept_response_days = np.clip(np.random.gamma(4, 4), 2, 45)
    total_land_area_hectares = np.random.uniform(50, 3000)
    est_families_affected = np.random.randint(20, 2000)

    risk_score, risk_level, actual_delay_months = score_row(
        compensation_paid_pct,
        court_cases_active,
        court_cases_recent_90d,
        court_case_avg_age_days,
        rr_progress_pct,
        possession_refusing_pct,
        forest_clearance_applied,
        days_since_forest_clearance_needed,
        months_elapsed,
        months_total,
        dept_response_days,
        st_families,
        noise_std=6,
    )

    return {
        "compensation_paid_pct": round(compensation_paid_pct, 1),
        "court_cases_active": court_cases_active,
        "court_cases_recent_90d": court_cases_recent_90d,
        "court_case_avg_age_days": round(court_case_avg_age_days, 1),
        "rr_progress_pct": round(rr_progress_pct, 1),
        "possession_refusing_pct": round(possession_refusing_pct, 1),
        "st_families": st_families,
        "forest_clearance_applied": forest_clearance_applied,
        "days_since_forest_clearance_needed": days_since_forest_clearance_needed,
        "months_elapsed": months_elapsed,
        "months_total": months_total,
        "dept_response_days": round(dept_response_days, 1),
        "total_land_area_hectares": round(total_land_area_hectares, 1),
        "est_families_affected": est_families_affected,
        "risk_score": risk_score,
        "risk_level": risk_level,
        "actual_delay_months": actual_delay_months,
    }


if __name__ == "__main__":
    rows = [generate_row() for _ in range(N)]
    rows += [generate_severe_row() for _ in range(500)]
    df = pd.DataFrame(rows).sample(frac=1, random_state=42).reset_index(drop=True)
    df.to_csv("synthetic_projects.csv", index=False)
    print(f"Generated {len(df)} synthetic projects -> synthetic_projects.csv")
    print(df["risk_level"].value_counts())
