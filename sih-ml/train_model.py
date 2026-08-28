"""
SIH 2026: Machine Learning Training Pipeline
- Automatically detects XGBoost vs. Scikit-Learn native ensembles.
- Prevents right-censored data leakage by training regressor on completed stages (stage_completed == 1).
- Tunes models with high-precision hyper-parameters for Indian E-Governance infrastructure datasets.
"""

import os
import json
import joblib
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, mean_absolute_error, r2_score

# 1. Inspect & Import Native Framework
FRAMEWORK = "scikit-learn"
try:
    import xgboost as xgb
    from xgboost import XGBClassifier, XGBRegressor
    FRAMEWORK = "xgboost"
    print("[Framework Detection] XGBoost detected! Using XGBClassifier and XGBRegressor with tuned parameters.")
except ImportError:
    from sklearn.ensemble import GradientBoostingClassifier, RandomForestRegressor, RandomForestClassifier
    print("[Framework Detection] Scikit-Learn detected. Using native GradientBoostingClassifier & RandomForestRegressor.")

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
    "lao_backlog_ratio",
    "political_cycle_proximity",
    "document_rejection_rate",
    "is_schedule_v_tribal",
    "is_forest_land",
    "is_urban_commercial",
]

def train():
    if not os.path.exists("synthetic_projects.csv"):
        print("synthetic_projects.csv not found. Running generate_dataset.py...")
        import generate_dataset
        generate_dataset.generate()

    df = pd.read_csv("synthetic_projects.csv")
    df["forest_clearance_applied"] = df["forest_clearance_applied"].astype(int)

    X = df[FEATURES]
    y_class = df["risk_level"]

    # Prevent Data Leakage: Regressor is trained strictly on completed projects
    completed_mask = df["stage_completed"] == 1
    X_reg = df.loc[completed_mask, FEATURES]
    y_reg = df.loc[completed_mask, "actual_delay_months"]

    # Train/Test Split for Classification
    X_train_c, X_test_c, yc_train, yc_test = train_test_split(
        X, y_class, test_size=0.2, random_state=42, stratify=y_class
    )

    # Train/Test Split for Regression
    X_train_r, X_test_r, yr_train, yr_test = train_test_split(
        X_reg, y_reg, test_size=0.2, random_state=42
    )

    # --- 1. Train Risk Classifier ---
    if FRAMEWORK == "xgboost":
        classes = sorted(list(y_class.unique()))
        label_map = {c: i for i, c in enumerate(classes)}
        inv_label_map = {i: c for i, c in enumerate(classes)}
        
        clf = XGBClassifier(
            max_depth=6,
            learning_rate=0.05,
            subsample=0.8,
            n_estimators=250,
            random_state=42,
            eval_metric="mlogloss",
        )
        clf.fit(X_train_c, yc_train.map(label_map))
        preds_numeric = clf.predict(X_test_c)
        yc_pred = pd.Series(preds_numeric).map(inv_label_map)
    else:
        clf = GradientBoostingClassifier(
            n_estimators=200,
            max_depth=6,
            learning_rate=0.05,
            subsample=0.8,
            random_state=42,
        )
        clf.fit(X_train_c, yc_train)
        yc_pred = clf.predict(X_test_c)

    print("\n=== Risk Level Classifier Evaluation ===")
    print(classification_report(yc_test, yc_pred))

    # --- 2. Train Delay Regressor ---
    if FRAMEWORK == "xgboost":
        reg = XGBRegressor(
            max_depth=6,
            learning_rate=0.05,
            subsample=0.8,
            n_estimators=250,
            random_state=42,
        )
        reg.fit(X_train_r, yr_train)
    else:
        reg = RandomForestRegressor(
            n_estimators=150,
            max_depth=8,
            random_state=42,
            n_jobs=1,
        )
        reg.fit(X_train_r, yr_train)

    yr_pred = reg.predict(X_test_r)
    mae = mean_absolute_error(yr_test, yr_pred)
    r2 = r2_score(yr_test, yr_pred)
    print(f"=== Delay Regressor Evaluation (Uncensored Validation) ===")
    print(f"Mean Absolute Error: {mae:.2f} months")
    print(f"R2 Score: {r2:.3f}")

    # --- 3. Compute Explainable AI Feature Importances ---
    importances = dict(zip(FEATURES, np.round(clf.feature_importances_, 4)))
    importances = dict(sorted(importances.items(), key=lambda x: -x[1]))

    print("\n=== Top Feature Importances ===")
    for k, v in list(importances.items())[:8]:
        print(f"  {k}: {v}")

    # --- 4. Serialize Model Artifacts ---
    os.makedirs("model", exist_ok=True)
    joblib.dump(clf, "model/risk_classifier.joblib")
    joblib.dump(reg, "model/delay_regressor.joblib")

    with open("model/features.json", "w") as f:
        json.dump(FEATURES, f, indent=2)

    with open("model/feature_importances.json", "w") as f:
        json.dump(importances, f, indent=2)

    with open("model/framework_info.json", "w") as f:
        json.dump({
            "framework": FRAMEWORK,
            "classifier": clf.__class__.__name__,
            "regressor": reg.__class__.__name__,
            "mae_months": round(float(mae), 2),
            "r2_score": round(float(r2), 3),
            "total_features": len(FEATURES),
        }, f, indent=2)

    print("\n[SUCCESS] Successfully trained and saved model binaries in model/")

if __name__ == "__main__":
    train()
