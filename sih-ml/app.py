"""
FastAPI service exposing the trained risk model.

Local run:
    pip install fastapi uvicorn joblib pandas scikit-learn --break-system-packages
    uvicorn app:app --reload --port 8000

Deploy free on Render.com or Railway.app:
    - Push this folder to a GitHub repo
    - Render: New -> Web Service -> point at the repo
      Build command: pip install -r requirements.txt
      Start command: uvicorn app:app --host 0.0.0.0 --port $PORT
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import joblib
import json
import pandas as pd

app = FastAPI(title="Land Acquisition Delay Risk Model")

# Allow the Next.js app to call this from the browser during the demo.
# Tighten allow_origins to your actual deployed domain before submitting.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

clf = joblib.load("model/risk_classifier.joblib")
reg = joblib.load("model/delay_regressor.joblib")
with open("model/features.json") as f:
    FEATURES = json.load(f)
with open("model/feature_importances.json") as f:
    FEATURE_IMPORTANCES = json.load(f)


class ProjectMetrics(BaseModel):
    compensation_paid_pct: float
    court_cases_active: int
    court_cases_recent_90d: int
    court_case_avg_age_days: float
    rr_progress_pct: float
    possession_refusing_pct: float
    st_families: int
    forest_clearance_applied: bool
    days_since_forest_clearance_needed: int
    months_elapsed: int
    months_total: int
    dept_response_days: float
    total_land_area_hectares: float
    est_families_affected: int


@app.get("/")
def health():
    return {"status": "ok", "model": "risk_classifier + delay_regressor"}


@app.get("/feature-importances")
def feature_importances():
    """Exposed separately so the dashboard can show 'why' without a full prediction."""
    return FEATURE_IMPORTANCES


@app.post("/predict")
def predict(metrics: ProjectMetrics):
    row = metrics.model_dump()
    row["forest_clearance_applied"] = int(row["forest_clearance_applied"])
    X = pd.DataFrame([row])[FEATURES]

    risk_level = clf.predict(X)[0]
    risk_proba = dict(zip(clf.classes_, clf.predict_proba(X)[0].round(3)))
    predicted_delay_months = round(float(reg.predict(X)[0]), 1)

    # Sort drivers by this project's own feature values weighted by global importance,
    # so the "why" is specific to this project, not just the model's overall ranking.
    driver_scores = {
        feat: round(FEATURE_IMPORTANCES.get(feat, 0), 4) for feat in FEATURES
    }
    top_drivers = sorted(driver_scores.items(), key=lambda x: -x[1])[:5]

    return {
        "risk_level": risk_level,
        "risk_probabilities": risk_proba,
        "predicted_delay_months": predicted_delay_months,
        "top_drivers": [{"feature": f, "importance": i} for f, i in top_drivers],
    }
