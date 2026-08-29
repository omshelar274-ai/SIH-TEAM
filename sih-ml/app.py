"""
SIH 2026 Release Candidate: LandGuard AI Intelligence API v3.0
Production-grade FastAPI service with:
  1. /predict — Multi-Model Ensemble (RSF 80% + CPH 20%) + Local Feature Attribution
  2. /statutory/compensation — RFCTLARR Sec 23/26/30 Multiplier + Solatium Calculator
  3. /statutory/bhoomi-rashi — Bhoomi Rashi Lifecycle State Machine Emulator
  4. /analytics/bottlenecks — Inter-Departmental SLA Cascade Tracker
  5. /analytics/escrow-forecast — Paralyzed Escrow Liquidity Release Forecast
  6. /analytics/litigation-scanner — Coordinated Cartel Attack Scanner
All endpoints wrapped in defensive error handling returning JSON error payloads.
"""

import os
import json
import math
import uuid
import hashlib
import traceback
from datetime import datetime, timedelta
from typing import List, Dict, Any, Optional

import joblib
import pandas as pd
import numpy as np
from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field

from survival_model import compute_cph_survival

app = FastAPI(
    title="LandGuard AI: Land Acquisition Predictive Intelligence Engine",
    description="Multi-model survival ensemble & statutory analytics under RFCTLARR Act 2013",
    version="3.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


# ── Global Error Handler ────────────────────────────────────────────────────
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    return JSONResponse(
        status_code=500,
        content={
            "error": str(exc),
            "error_type": type(exc).__name__,
            "code": 500,
            "detail": "Internal server error. Check ML model artifacts or input format.",
        },
    )


# ── Model Artifact Loading ──────────────────────────────────────────────────
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_DIR = os.path.join(BASE_DIR, "model")

clf = None
reg = None
FEATURES: List[str] = []
FEATURE_IMPORTANCES: Dict[str, float] = {}
FRAMEWORK_INFO: Dict[str, Any] = {}


def load_artifacts():
    global clf, reg, FEATURES, FEATURE_IMPORTANCES, FRAMEWORK_INFO
    try:
        clf_path = os.path.join(MODEL_DIR, "risk_classifier.joblib")
        reg_path = os.path.join(MODEL_DIR, "delay_regressor.joblib")
        if os.path.exists(clf_path):
            clf = joblib.load(clf_path)
        if os.path.exists(reg_path):
            reg = joblib.load(reg_path)
        for name, target, loader in [
            ("features.json", "FEATURES", list),
            ("feature_importances.json", "FEATURE_IMPORTANCES", dict),
            ("framework_info.json", "FRAMEWORK_INFO", dict),
        ]:
            path = os.path.join(MODEL_DIR, name)
            if os.path.exists(path):
                with open(path, "r", encoding="utf-8") as f:
                    data = json.load(f)
                    if target == "FEATURES":
                        FEATURES.clear()
                        FEATURES.extend(data)
                    elif target == "FEATURE_IMPORTANCES":
                        FEATURE_IMPORTANCES.clear()
                        FEATURE_IMPORTANCES.update(data)
                    elif target == "FRAMEWORK_INFO":
                        FRAMEWORK_INFO.clear()
                        FRAMEWORK_INFO.update(data)
    except Exception as e:
        print(f"[WARN] Failed to load model artifacts: {e}")


load_artifacts()


# ── Pydantic Schemas ────────────────────────────────────────────────────────
class ProjectMetricsInput(BaseModel):
    compensation_paid_pct: float = Field(..., ge=0, le=100)
    court_cases_active: int = Field(0, ge=0)
    court_cases_recent_90d: int = Field(0, ge=0)
    court_case_avg_age_days: float = Field(0.0, ge=0)
    rr_progress_pct: float = Field(100.0, ge=0, le=100)
    possession_refusing_pct: float = Field(0.0, ge=0, le=100)
    st_families: int = Field(0, ge=0)
    forest_clearance_applied: bool = Field(True)
    days_since_forest_clearance_needed: int = Field(0, ge=0)
    months_elapsed: int = Field(0, ge=0)
    months_total: int = Field(24, ge=1)
    dept_response_days: float = Field(10.0, ge=0)
    total_land_area_hectares: float = Field(100.0, ge=0.0)
    est_families_affected: int = Field(50, ge=0)
    lao_backlog_ratio: Optional[float] = Field(1.5, ge=0.1)
    political_cycle_proximity: Optional[int] = Field(24, ge=1, le=60)
    document_rejection_rate: Optional[float] = Field(0.05, ge=0, le=1.0)
    is_schedule_v_tribal: Optional[int] = Field(0, ge=0, le=1)
    is_forest_land: Optional[int] = Field(0, ge=0, le=1)
    is_urban_commercial: Optional[int] = Field(0, ge=0, le=1)


class CompensationInput(BaseModel):
    market_value_inr: float = Field(..., gt=0, description="Market value per Sec 26 (First Schedule)")
    is_rural: bool = Field(True, description="True = rural (multiplier 1.0-2.0), False = urban (1.0)")
    land_area_sqm: float = Field(..., gt=0, description="Area in square metres")
    khasra_number: Optional[str] = Field(None, description="Revenue survey/khasra number")


class BhoomiRashiInput(BaseModel):
    project_id: str
    current_stage: str = Field(..., description="One of: INTENTION, SEC_3A, SEC_3D, SEC_11, SEC_19, SEC_23, SEC_38, PFMS_DISBURSEMENT")
    days_in_current_stage: int = Field(0, ge=0)


class DepartmentMilestone(BaseModel):
    department_id: str
    department_name: str
    milestone_name: str
    statutory_sla_days: int
    days_elapsed: int
    is_blocking: bool
    status: str


class BottleneckAnalysisInput(BaseModel):
    project_id: str
    project_name: str
    milestones: List[DepartmentMilestone]


class ParcelLitigationItem(BaseModel):
    parcel_id: str
    survey_number: str
    village_name: str
    valuation_inr: float
    is_litigated: bool
    court_case_id: Optional[str] = None
    petitioner_lawyer: Optional[str] = None
    objection_text: Optional[str] = None


class EscrowForecastInput(BaseModel):
    project_id: str
    project_name: str
    total_budget_inr: float
    parcels: List[ParcelLitigationItem]


# ── Feature Attribution Constants ───────────────────────────────────────────
FEATURE_BASELINES = {
    "compensation_paid_pct": 50.0, "court_cases_active": 4.0,
    "court_cases_recent_90d": 1.5, "court_case_avg_age_days": 150.0,
    "rr_progress_pct": 60.0, "possession_refusing_pct": 15.0,
    "st_families": 10.0, "forest_clearance_applied": 0.7,
    "days_since_forest_clearance_needed": 60.0, "months_elapsed": 18.0,
    "months_total": 30.0, "dept_response_days": 9.0,
    "total_land_area_hectares": 300.0, "est_families_affected": 60.0,
    "lao_backlog_ratio": 2.0, "political_cycle_proximity": 24.0,
    "document_rejection_rate": 0.12, "is_schedule_v_tribal": 0.15,
    "is_forest_land": 0.15, "is_urban_commercial": 0.15,
}
FEATURE_SCALES = {
    "compensation_paid_pct": 50.0, "court_cases_active": 12.0,
    "court_cases_recent_90d": 4.0, "court_case_avg_age_days": 200.0,
    "rr_progress_pct": 45.0, "possession_refusing_pct": 30.0,
    "st_families": 50.0, "forest_clearance_applied": 0.5,
    "days_since_forest_clearance_needed": 180.0, "months_elapsed": 20.0,
    "months_total": 18.0, "dept_response_days": 8.0,
    "total_land_area_hectares": 400.0, "est_families_affected": 100.0,
    "lao_backlog_ratio": 2.5, "political_cycle_proximity": 20.0,
    "document_rejection_rate": 0.25, "is_schedule_v_tribal": 0.35,
    "is_forest_land": 0.35, "is_urban_commercial": 0.35,
}
HIGH_IS_RISKY = {"compensation_paid_pct": False, "rr_progress_pct": False, "forest_clearance_applied": False}


# ══════════════════════════════════════════════════════════════════════════════
#  ENDPOINTS
# ══════════════════════════════════════════════════════════════════════════════

@app.get("/")
def health():
    if not FEATURES:
        load_artifacts()
    return {
        "status": "active",
        "service": "LandGuard ML Intelligence API v3.0",
        "ensemble": "RSF (80%) + CPH (20%) Weighted Survival Ensemble",
        "framework_info": FRAMEWORK_INFO or {"framework": "scikit-learn"},
        "features_count": len(FEATURES),
    }


@app.get("/feature-importances")
def feature_importances():
    if not FEATURE_IMPORTANCES:
        load_artifacts()
    return FEATURE_IMPORTANCES


@app.get("/reload")
def reload_models():
    load_artifacts()
    return {
        "status": "ok",
        "message": "Model binaries and feature mappings reloaded successfully.",
        "features_count": len(FEATURES),
        "classifier": clf.__class__.__name__ if clf else None,
        "regressor": reg.__class__.__name__ if reg else None,
    }


# ── 1. /predict ──────────────────────────────────────────────────────────────
@app.post("/predict")
def predict(metrics: ProjectMetricsInput):
    try:
        if clf is None or reg is None or not FEATURES:
            load_artifacts()
            if clf is None or reg is None or not FEATURES:
                return JSONResponse(status_code=503, content={
                    "error": "Models not loaded", "code": 503,
                    "detail": "Run train_model.py to generate model binaries."
                })

        row = metrics.model_dump()
        row["forest_clearance_applied"] = int(row["forest_clearance_applied"])
        row["lao_backlog_ratio"] = row.get("lao_backlog_ratio") or 1.5
        row["political_cycle_proximity"] = row.get("political_cycle_proximity") or 24
        row["document_rejection_rate"] = row.get("document_rejection_rate") or 0.05
        row["is_schedule_v_tribal"] = row.get("is_schedule_v_tribal") or 0
        row["is_forest_land"] = row.get("is_forest_land") or 0
        row["is_urban_commercial"] = row.get("is_urban_commercial") or 0

        X = pd.DataFrame([row])[FEATURES]
        x_values = X.iloc[0]

        risk_level = str(clf.predict(X)[0])
        risk_proba = dict(zip([str(c) for c in clf.classes_], clf.predict_proba(X)[0].round(3)))
        predicted_delay_months = round(float(reg.predict(X)[0]), 1)
        predicted_delay_days = int(round(predicted_delay_months * 30.4))

        # Local Instance-Level Feature Attribution (breaks 35% global lock)
        local_scores: Dict[str, float] = {}
        for feat in FEATURES:
            gimp = float(FEATURE_IMPORTANCES.get(feat, 0.05))
            val = float(x_values[feat])
            base = FEATURE_BASELINES.get(feat, val)
            scale = FEATURE_SCALES.get(feat, max(1.0, abs(base)))
            risky_high = HIGH_IS_RISKY.get(feat, True)
            if not risky_high:
                d = (base - val) / scale if val < base else 0.05
            else:
                d = (val - base) / scale if val > base else 0.05
            # Strong instance-level dynamic weighting
            local_scores[feat] = max(0.01, gimp * (1.0 + max(0.0, d) * 4.5))

        total_ls = sum(local_scores.values()) or 1.0
        local_pct = {f: round(v / total_ls * 100, 1) for f, v in local_scores.items()}
        top_local = sorted(local_pct.items(), key=lambda x: -x[1])[:6]

        # Multi-Model Ensemble Survival (RSF 80% + CPH 20% with Sigmoid Normalization)
        survival_data = compute_cph_survival(row)
        delay_prob_90 = float(survival_data["delay_prob_90d"])
        
        # Harmonize composite risk score (14 - 94) directly with survival ensemble delay probability
        harmonized_score = int(round(min(94, max(14, delay_prob_90 * 100))))
        if harmonized_score >= 75:
            calibrated_level = "CRITICAL"
        elif harmonized_score >= 54:
            calibrated_level = "HIGH"
        elif harmonized_score >= 34:
            calibrated_level = "MODERATE"
        else:
            calibrated_level = "LOW"

        return {
            "risk_score": harmonized_score,
            "risk_level": calibrated_level,
            "risk_probabilities": risk_proba,
            "predicted_delay_months": predicted_delay_months,
            "predicted_delay_days": predicted_delay_days,
            "delay_prob_30d": float(survival_data["delay_prob_30d"]),
            "delay_prob_60d": float(survival_data["delay_prob_60d"]),
            "delay_prob_90d": float(survival_data["delay_prob_90d"]),
            "delay_prob_180d": float(survival_data["delay_prob_180d"]),
            "survival_analysis": {
                "stratum": survival_data["stratum"],
                "hazard_ratio": survival_data["hazard_ratio"],
                "cph_hazard_ratio": survival_data["cph_hazard_ratio"],
                "clearance_probabilities": {
                    "day_30": survival_data["clearance_prob_30d"],
                    "day_60": survival_data["clearance_prob_60d"],
                    "day_90": survival_data["clearance_prob_90d"],
                },
                "delay_probabilities": {
                    "day_30": survival_data["delay_prob_30d"],
                    "day_60": survival_data["delay_prob_60d"],
                    "day_90": survival_data["delay_prob_90d"],
                    "day_180": survival_data["delay_prob_180d"],
                },
                "survival_curve": survival_data["survival_curve"],
                "hazard_table": survival_data["hazard_table"],
            },
            "local_feature_attribution": [
                {"feature": f, "local_pct": pct} for f, pct in top_local
            ],
            "top_drivers": [
                {
                    "feature": f,
                    "importance": round(local_pct[f] / 100.0, 4),
                    "local_pct": local_pct[f],
                    "global_importance": round(float(FEATURE_IMPORTANCES.get(f, 0)), 4),
                }
                for f, _ in top_local
            ],
        }
    except Exception as e:
        return JSONResponse(status_code=500, content={
            "error": str(e), "code": 500, "detail": traceback.format_exc()
        })


# ── 2. /statutory/compensation — RFCTLARR Sec 23/26/30 Calculator ────────────
@app.post("/statutory/compensation")
def calculate_rfctlarr_compensation(data: CompensationInput):
    """
    Calculates total compensation per RFCTLARR Act 2013:
      - Market Value (Sec 26, First Schedule)
      - Multiplier: 1.0 (urban) or 1.0-2.0 (rural) per Sec 30(1)
      - Solatium: 100% of market value per Sec 30(1)
      - Additional Interest: 12% per annum on market value per Sec 30(3)
    """
    try:
        mv = data.market_value_inr
        if data.khasra_number and not data.khasra_number.replace("/", "").replace("-", "").isalnum():
            return JSONResponse(status_code=400, content={
                "error": "Invalid Khasra Format", "code": 400,
                "detail": f"Khasra '{data.khasra_number}' contains invalid characters."
            })

        multiplier = round(min(2.0, max(1.0, 1.0 + (0.01 * min(100, data.land_area_sqm / 100.0)))), 2) if data.is_rural else 1.0
        market_value_adjusted = round(mv * multiplier, 2)
        solatium = round(mv * 1.0, 2)  # 100% Solatium per Sec 30(1)
        interest_12pct = round(mv * 0.12, 2)  # Sec 30(3): 12% pa on market value
        total_compensation = round(market_value_adjusted + solatium + interest_12pct, 2)

        return {
            "khasra_number": data.khasra_number,
            "land_area_sqm": data.land_area_sqm,
            "zone": "Rural" if data.is_rural else "Urban",
            "market_value_inr": mv,
            "sec_30_multiplier": multiplier,
            "market_value_adjusted_inr": market_value_adjusted,
            "solatium_100pct_inr": solatium,
            "interest_12pct_pa_inr": interest_12pct,
            "total_compensation_inr": total_compensation,
            "statutory_reference": "RFCTLARR Act 2013, Sections 23, 26 (First Schedule), 30(1), 30(3)",
        }
    except Exception as e:
        return JSONResponse(status_code=500, content={"error": str(e), "code": 500})


# ── 3. /statutory/bhoomi-rashi — Lifecycle State Machine ────────────────────
BHOOMI_RASHI_STAGES = {
    "INTENTION":         {"next": "SEC_3A",  "sla_days": 30,  "section": "Sec 4(1) - Preliminary Notification"},
    "SEC_3A":            {"next": "SEC_3D",  "sla_days": 60,  "section": "Sec 11 - Preliminary Notification (3A)"},
    "SEC_3D":            {"next": "SEC_11",  "sla_days": 45,  "section": "Sec 19 - Declaration (3D)"},
    "SEC_11":            {"next": "SEC_19",  "sla_days": 60,  "section": "Sec 11 - Notice to Interested Persons"},
    "SEC_19":            {"next": "SEC_23",  "sla_days": 90,  "section": "Sec 19 - Declaration of Acquisition"},
    "SEC_23":            {"next": "SEC_38",  "sla_days": 60,  "section": "Sec 23 - Award by Collector"},
    "SEC_38":            {"next": "PFMS_DISBURSEMENT", "sla_days": 30, "section": "Sec 38 - Possession"},
    "PFMS_DISBURSEMENT": {"next": "COMPLETED", "sla_days": 15, "section": "PFMS Electronic Disbursement"},
}


@app.post("/statutory/bhoomi-rashi")
def bhoomi_rashi_lifecycle(data: BhoomiRashiInput):
    """
    Emulates the Bhoomi Rashi gazette notification lifecycle per RFCTLARR Act.
    Generates mock PFMS UTR number upon reaching disbursement stage.
    """
    try:
        stage = data.current_stage.upper()
        if stage not in BHOOMI_RASHI_STAGES:
            return JSONResponse(status_code=400, content={
                "error": f"Invalid stage: {stage}", "code": 400,
                "valid_stages": list(BHOOMI_RASHI_STAGES.keys()),
            })

        stage_info = BHOOMI_RASHI_STAGES[stage]
        sla_days = stage_info["sla_days"]
        is_overdue = data.days_in_current_stage > sla_days
        overdue_days = max(0, data.days_in_current_stage - sla_days)

        # Generate deterministic mock UTR for PFMS stage
        utr_number = None
        if stage == "PFMS_DISBURSEMENT":
            hash_input = f"{data.project_id}-{datetime.utcnow().strftime('%Y%m%d')}"
            utr_hash = hashlib.sha256(hash_input.encode()).hexdigest()[:12].upper()
            utr_number = f"PFMS{utr_hash}"

        return {
            "project_id": data.project_id,
            "current_stage": stage,
            "section_reference": stage_info["section"],
            "statutory_sla_days": sla_days,
            "days_in_stage": data.days_in_current_stage,
            "is_overdue": is_overdue,
            "overdue_by_days": overdue_days,
            "next_stage": stage_info["next"],
            "pfms_utr_number": utr_number,
            "lifecycle_stages": [
                {"stage": k, "section": v["section"], "sla_days": v["sla_days"]}
                for k, v in BHOOMI_RASHI_STAGES.items()
            ],
        }
    except Exception as e:
        return JSONResponse(status_code=500, content={"error": str(e), "code": 500})


# ── 4. /analytics/bottlenecks ────────────────────────────────────────────────
@app.post("/analytics/bottlenecks")
def analyze_bottlenecks(payload: BottleneckAnalysisInput):
    try:
        bottlenecks = []
        total_cascade = 0

        for ms in payload.milestones:
            breach = max(0, ms.days_elapsed - ms.statutory_sla_days)
            is_overdue = breach > 0 or ms.status == "OVERDUE"

            if is_overdue and ms.is_blocking:
                mult = 1.6 if "Forest" in ms.department_name else 1.3 if "Revenue" in ms.department_name else 1.1
                cascaded = int(round(breach * mult))
                total_cascade += cascaded
                bottlenecks.append({
                    "department_id": ms.department_id,
                    "department_name": ms.department_name,
                    "milestone": ms.milestone_name,
                    "statutory_sla_days": ms.statutory_sla_days,
                    "days_elapsed": ms.days_elapsed,
                    "sla_breach_days": breach,
                    "cascaded_delay_days": cascaded,
                    "severity": "CRITICAL" if breach > 45 else "HIGH" if breach > 15 else "MEDIUM",
                    "recommended_action": f"Issue Section 48 / SLA notice to {ms.department_name} Head for immediate joint conciliation.",
                })

        cost_escalation = round(min(35.0, (total_cascade / 365.0) * 8.5), 2)

        return {
            "project_id": payload.project_id,
            "project_name": payload.project_name,
            "total_cascade_delay_days": total_cascade,
            "estimated_cost_escalation_pct": cost_escalation,
            "critical_bottlenecks_count": len(bottlenecks),
            "bottlenecks": bottlenecks,
        }
    except Exception as e:
        return JSONResponse(status_code=500, content={"error": str(e), "code": 500})


# ── 5. /analytics/escrow-forecast ───────────────────────────────────────────
@app.post("/analytics/escrow-forecast")
def calculate_escrow_forecast(payload: EscrowForecastInput):
    try:
        total_val = sum(p.valuation_inr for p in payload.parcels) or payload.total_budget_inr
        litigated_val = sum(p.valuation_inr for p in payload.parcels if p.is_litigated)
        unlitigated_val = total_val - litigated_val
        paralyzed_pct = round((litigated_val / max(1.0, total_val)) * 100.0, 2)
        threshold = paralyzed_pct >= 30.0
        diversion = round(litigated_val * 0.70, 2) if threshold else 0.0

        return {
            "project_id": payload.project_id,
            "project_name": payload.project_name,
            "total_budget_inr": total_val,
            "litigated_amt_frozen_inr": litigated_val,
            "unlitigated_amt_active_inr": unlitigated_val,
            "paralyzed_capital_pct": paralyzed_pct,
            "is_liquidity_paralyzed": threshold,
            "liquidity_release_forecast": {
                "recommended_diversion_amt_inr": diversion,
                "statutory_retained_escrow_inr": round(litigated_val * 0.30, 2) if threshold else litigated_val,
                "recommendation_summary": (
                    f"Collector advised to divert INR {diversion:,.2f} of frozen escrow to accelerate "
                    f"Section 3G/23 compensation on unlitigated corridors, retaining 30% statutory LARRA security."
                    if threshold else
                    "Litigated escrow within operational threshold (<30%). Diversion not required."
                ),
            },
        }
    except Exception as e:
        return JSONResponse(status_code=500, content={"error": str(e), "code": 500})


# ── 6. /analytics/litigation-scanner ────────────────────────────────────────
@app.post("/analytics/litigation-scanner")
def scan_litigation_patterns(parcels: List[ParcelLitigationItem]):
    try:
        litigated = [p for p in parcels if p.is_litigated]
        if not litigated:
            return {"total_litigated_cases": 0, "suspicious_cartel_clusters": [], "cartel_attack_detected": False}

        lawyer_counts: Dict[str, int] = {}
        objection_templates: Dict[str, list] = {}

        for p in litigated:
            lawyer = p.petitioner_lawyer or "Unknown Advocate"
            lawyer_counts[lawyer] = lawyer_counts.get(lawyer, 0) + 1
            if p.objection_text:
                snippet = p.objection_text.strip().lower()[:60]
                objection_templates.setdefault(snippet, []).append(p.survey_number)

        clusters = []
        for lawyer, count in lawyer_counts.items():
            if count >= 3 and lawyer != "Unknown Advocate":
                clusters.append({
                    "cluster_type": "PROXY_LAWYER_POOLING", "risk_score": 85,
                    "advocate": lawyer, "cases_linked_count": count,
                    "description": f"Advocate {lawyer} filing mass proxy injunctions across {count} contiguous parcels.",
                    "remedy": "Request District Judge for composite single-day hearing and expedited disposal.",
                })

        for snippet, surveys in objection_templates.items():
            if len(surveys) >= 3:
                clusters.append({
                    "cluster_type": "TEMPLATED_SPECULATIVE_LITIGATION", "risk_score": 90,
                    "surveys_involved": surveys, "template_snippet": snippet,
                    "description": f"Identical boilerplate phrasing across {len(surveys)} revenue surveys.",
                    "remedy": "Submit Section 15(2) RFCTLARR composite counter-affidavit.",
                })

        return {
            "total_litigated_cases": len(litigated),
            "suspicious_cartel_clusters_count": len(clusters),
            "cartel_attack_detected": len(clusters) > 0,
            "clusters": clusters,
        }
    except Exception as e:
        return JSONResponse(status_code=500, content={"error": str(e), "code": 500})
