"""
Trains two models on the synthetic dataset:
  1. RandomForestClassifier -> risk_level (LOW/MODERATE/HIGH/CRITICAL)
  2. RandomForestRegressor  -> actual_delay_months

Saves both to model/ as .joblib files, and prints feature importances
(your Explainable AI talking point — compare these to the guide's stated
32/24/18/15/6/5 weights in your pitch).

Usage:
    python train_model.py
"""

import pandas as pd
from sklearn.ensemble import RandomForestClassifier, RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, mean_absolute_error
import joblib
import json
import os

FEATURES = [
    "compensation_paid_pct",
    "court_cases_active",
    "court_cases_recent_90d",
    "court_case_avg_age_days",
    "rr_progress_pct",
    "possession_refusing_pct",
    "st_families",
    "forest_clearance_applied",
    "days_since_forest_clearance_needed",
    "months_elapsed",
    "months_total",
    "dept_response_days",
    "total_land_area_hectares",
    "est_families_affected",
]

df = pd.read_csv("synthetic_projects.csv")
df["forest_clearance_applied"] = df["forest_clearance_applied"].astype(int)

X = df[FEATURES]
y_class = df["risk_level"]
y_reg = df["actual_delay_months"]

X_train, X_test, yc_train, yc_test, yr_train, yr_test = train_test_split(
    X, y_class, y_reg, test_size=0.2, random_state=42, stratify=y_class
)

# --- Classifier: risk level ---
clf = RandomForestClassifier(
    n_estimators=200, max_depth=8, random_state=42, class_weight="balanced"
)
clf.fit(X_train, yc_train)
yc_pred = clf.predict(X_test)
print("=== Risk Level Classifier ===")
print(classification_report(yc_test, yc_pred))

# --- Regressor: predicted delay months ---
reg = RandomForestRegressor(n_estimators=200, max_depth=8, random_state=42)
reg.fit(X_train, yr_train)
yr_pred = reg.predict(X_test)
mae = mean_absolute_error(yr_test, yr_pred)
print(f"\n=== Delay Month Regressor ===\nMean Absolute Error: {mae:.2f} months")

# --- Feature importance (Explainable AI) ---
importances = dict(zip(FEATURES, clf.feature_importances_.round(4)))
importances = dict(sorted(importances.items(), key=lambda x: -x[1]))
print("\n=== Feature Importances (Explainable AI) ===")
for feat, imp in importances.items():
    print(f"  {feat}: {imp}")

# --- Save everything the FastAPI service needs ---
os.makedirs("model", exist_ok=True)
joblib.dump(clf, "model/risk_classifier.joblib")
joblib.dump(reg, "model/delay_regressor.joblib")
with open("model/feature_importances.json", "w") as f:
    json.dump(importances, f, indent=2)
with open("model/features.json", "w") as f:
    json.dump(FEATURES, f, indent=2)

print("\nSaved model/risk_classifier.joblib, model/delay_regressor.joblib, model/feature_importances.json")
