# SIH 2025 — ML Risk Model (Round 1 Differentiator)

A Random Forest predicting risk level and delay duration, trained on a
synthetic dataset. Weighting is informed by verified real sources (see below)
— NOT by the original reference guide's invented percentages, and not by
any single unverified source either. Every citation here was independently
checked by fetching the actual paper/portal, not taken on trust.

## Files

- `generate_dataset.py` — builds `synthetic_projects.csv` (1150 synthetic projects)
- `train_model.py` — trains `RandomForestClassifier` + `RandomForestRegressor`, saves to `model/`, prints feature importances
- `app.py` — FastAPI service exposing `/predict` and `/feature-importances`
- `model/` — trained model files (already generated)

## Run locally

```
pip install -r requirements.txt
uvicorn app:app --reload --port 8000
```

Test it:
```
curl -X POST http://localhost:8000/predict -H "Content-Type: application/json" -d '{
  "compensation_paid_pct": 36.8,
  "court_cases_active": 23,
  "rr_progress_pct": 40,
  "possession_refusing_pct": 30,
  "st_families": 120,
  "forest_clearance_applied": false,
  "days_since_forest_clearance_needed": 120,
  "months_elapsed": 20,
  "months_total": 36,
  "dept_response_days": 18,
  "total_land_area_hectares": 1250,
  "est_families_affected": 847
}'
```
Returns `"risk_level": "HIGH"` (~68% confidence) with ~7 months predicted delay
for the NH-44 numbers. This is deliberately NOT tuned to match any guide's
specific number — it reflects the sourced weights below, honestly, wherever
they land.

## Data grounding — read this before your pitch

**Every source below was independently verified** (fetched the actual paper
or portal, not just trusted a summary):

1. **Devi & Sindhu (2025), "Delay Analysis of Infrastructure Construction
   Projects in India"** — *Journal of The Institution of Engineers (India):
   Series A*, Vol 106, pp 763–771. DOI: 10.1007/s40030-025-00899-5. Open
   access, peer-reviewed. Survey of 72 Indian construction professionals,
   Relative Importance Index (RII) methodology.
   - **Land acquisition has RII=0.68 for road projects** — higher than every
     one of the paper's own top-ranked general delay categories (material
     issues 0.562, construction site 0.555, contractor inefficiencies
     0.506). For road/highway projects specifically — our NH-44 example —
     this is the single most-documented delay factor in this dataset.
   - Land acquisition groups under the paper's "Government & External
     Factors" PCA dimension, alongside permits and environmental clearance.
   - **Limitation:** this paper validates land acquisition as the *top
     category* but doesn't break it into sub-causes (compensation vs.
     litigation vs. clearances vs. right-of-way) — that granularity isn't
     in its 25-factor list.
   - Also independently confirms Random Forest as an appropriate model
     choice for this kind of prediction (see Andrić papers below).

2. **Andrić et al. (2025), "Investigating the possible regression functions
   for modelling delays in infrastructure projects in South Asia"** — *KSCE
   Journal of Civil Engineering*, 29(9), 100209. DOI: 10.1016/j.kscej.2025.100209.
   138 completed South Asian infrastructure projects (83 in India), sourced
   from ADB completion reports (108) and MoSPI (30). Found Random Forest
   regression outperforms linear/quadratic models for this problem — same
   model family we use here, independently validated.

3. **Andrić et al. (2024), "Determining Cost and Causes of Overruns in
   Infrastructure Projects in South Asia"** — *Sustainability* (MDPI),
   16(24), 11159. DOI: 10.3390/su162411159. Same 138-project database,
   focused on cost overruns; also finds Random Forest most suitable.
   Reports average cost overrun of 3.3% in South Asian infra projects.

4. **PRAGATI review, January 2026** — India's central infrastructure
   project monitoring platform. Cabinet Secretary T.V. Somanathan: of 7,156
   resolved project issues, 35% were land acquisition (largest category),
   20% forest/wildlife/environment clearance, 18% right-of-way (source: PTI,
   reported via ThePrint/BusinessToday, Jan 2026). Used for the internal
   *split* between compensation/clearances/right-of-way, since Devi & Sindhu
   validates land acquisition as #1 overall but doesn't provide that
   sub-breakdown.

**What's still NOT real:** the training data itself is synthetic — no
public, project-level dataset links individual project features
(compensation %, court case counts, etc.) to actual delay outcomes in
India. The MoSPI PAIMANA portal (https://paimana-proj.mospi.gov.in/) and
its public dashboard track project-level cost/schedule data nationally,
and the Andrić papers' 138-project database is drawn partly from MoSPI, but
neither exposes a downloadable, granular land-acquisition-specific dataset
suitable for direct training in a hackathon timeframe. If your team has
time before the demo, reconstructing even a small subset of the 138-project
database from the cited ADB completion reports would be a genuine step up
from synthetic data — see "Possible upgrade" below.

**Update (26 Aug 2026):** a first batch of 8 real ADB/MoSPI project records
has been collected — see `research_pack/REAL_DATA_CALIBRATION.md`. It's
still too small to train on (n=8, mostly incomplete), but it's a genuine
external check: the real "months of further delay from the current plan"
figures (4.27, 5.72, 9.17 months across 3 projects) land inside or right at
the edge of this app's HIGH-risk predicted-delay band (4–8 months) — good
ammunition for judge Q&A. Read that file before the demo.

**Honest pitch framing:** "Our feature ranking is grounded in peer-reviewed
research — Devi & Sindhu (2025, Journal of The Institution of Engineers
India) found land acquisition has the highest documented delay-impact score
of any factor for Indian road projects, ahead of material and contractor
issues. We use PRAGATI's national issue-category data to split that into
compensation, clearance, and right-of-way sub-factors. Since no public
dataset links individual project features to delay outcomes, we trained on
a synthetic dataset reflecting this real-world ranking."

**What NOT to say:** don't present the ~72% classifier accuracy as
real-world predictive power — it measures how well the model learned the
synthetic data's own pattern. Say so plainly if asked.

## Possible upgrade before the demo (optional, real data)

The Andrić et al. papers' 138-project database (83 Indian) was assembled
from ADB completion reports + MoSPI. If someone on your team has a spare
few hours: ADB completion reports are individually public
(adb.org/documents), and reconstructing even 15-20 Indian road/highway
project records (cost, planned vs. actual duration, stated delay causes)
from those reports would let you validate the model against a handful of
*real* outcomes instead of purely synthetic ones — a genuinely stronger
claim than most hackathon teams can make. Not required for round 1, but
worth mentioning as immediate future work in the pitch either way.

## Retraining

```
python generate_dataset.py
python train_model.py
```
Overwrites `model/*.joblib` — FastAPI picks up new files on restart.

## Deploying (free tier — Render.com)

1. Push `sih-ml/` to its own GitHub repo (or subfolder)
2. Render.com → New → Web Service → connect repo
3. Build command: `pip install -r requirements.txt`
4. Start command: `uvicorn app:app --host 0.0.0.0 --port $PORT`
5. Copy the deployed URL, set `ML_SERVICE_URL` in the Next.js app's `.env.local`
6. Redeploy/restart — dashboard shows "⚡ ML model prediction" instead of the fallback badge

**Render free tier note:** spins down after 15 min idle, takes 30-60s to
wake. Hit `GET /` a few minutes before your demo slot to warm it up — the
Next.js route has a 4s timeout and silently falls back to rule-based
scoring if the ML service is still waking, which is safe but not what you
want live.

## Pitch talking points

- "Our feature ranking is grounded in peer-reviewed research — Devi & Sindhu
  (2025) found land acquisition has the highest delay-impact score of any
  factor for Indian road projects specifically (RII=0.68), higher even than
  material or contractor issues"
- "We independently validated Random Forest as the right model family —
  Andrić et al. (2024, 2025) found it outperforms linear/quadratic
  regression for South Asian infrastructure delay/cost prediction"
- "The system gracefully falls back to rule-based scoring if the ML service
  is unavailable — production-realistic design, not just a demo hack"
- If asked about accuracy: "72% on our synthetic validation set — that
  measures how well the model learned our synthetic data's patterns, not
  real-world performance. A production version would retrain on real
  project data, and we've identified a concrete path to that using ADB
  completion reports (see README)."
