"""
SIH 2026: Survival Analysis & Multi-Model Agreement Engine
Ported and enhanced from SIH-26 into sih-app/sih-ml
"""

import math
from typing import Dict, Any, List

def compute_cph_survival(features: Dict[str, Any]) -> Dict[str, Any]:
    """
    Computes Cox Proportional Hazards hazard ratio, survival curve,
    and multi-horizon delay probabilities.
    """
    x1 = 1.0 if features.get("court_cases_active", 0) > 10 or features.get("court_cases_recent_90d", 0) > 3 else 0.0
    x2 = 1.0 if features.get("compensation_paid_pct", 100.0) < 50.0 else 0.0
    x3 = 1.0 if not features.get("forest_clearance_applied", True) and features.get("days_since_forest_clearance_needed", 0) > 120 else 0.0
    x4 = 1.0 if features.get("possession_refusing_pct", 0.0) > 20.0 else 0.0

    beta_1 = 0.88  # Active court disputes / stay orders
    beta_2 = 0.61  # Compensation payout lag
    beta_3 = 0.52  # Forest clearance delay
    beta_4 = 0.26  # Possession refusal / Right of Way

    hazard_ratio = round(math.exp(beta_1 * x1 + beta_2 * x2 + beta_3 * x3 + beta_4 * x4), 2)

    # Baseline completion rates from Devi & Sindhu (2025) and PRAGATI empirical distributions
    baseline_rates = [
        {"day": 30, "s0": 0.95},
        {"day": 60, "s0": 0.90},
        {"day": 90, "s0": 0.85},
        {"day": 120, "s0": 0.75},
        {"day": 180, "s0": 0.65},
        {"day": 270, "s0": 0.45},
        {"day": 360, "s0": 0.20},
    ]

    survival_curve = [
        {"day": pt["day"], "survival_rate": round(math.pow(pt["s0"], hazard_ratio), 3)}
        for pt in baseline_rates
    ]

    delay_prob_30d = round(1.0 - math.pow(0.95, hazard_ratio), 3)
    delay_prob_60d = round(1.0 - math.pow(0.90, hazard_ratio), 3)
    delay_prob_90d = round(1.0 - math.pow(0.85, hazard_ratio), 3)
    delay_prob_180d = round(1.0 - math.pow(0.65, hazard_ratio), 3)

    return {
        "hazard_ratio": hazard_ratio,
        "survival_curve": survival_curve,
        "delay_prob_30d": min(0.99, max(0.05, delay_prob_30d)),
        "delay_prob_60d": min(0.99, max(0.08, delay_prob_60d)),
        "delay_prob_90d": min(0.99, max(0.12, delay_prob_90d)),
        "delay_prob_180d": min(0.99, max(0.20, delay_prob_180d)),
    }
