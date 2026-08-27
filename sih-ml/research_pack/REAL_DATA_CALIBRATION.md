# Real-Project Calibration Notes (added 26 Aug 2026, updated same day)

Source: 10 ADB/MoSPI project records assembled and independently sourced
(`ADB_MoSPI_real_source_records.csv`, `SIH_26017_real_source_data_and_schema.xlsx`,
`SIH_26017_FULL_REAL_DATA_RESEARCH_PACK.pdf`, plus 2 records added 26 Aug 2026
by fetching full ADB Project Completion Reports directly). Every value carries
a `source_url`; fields with no public source are left blank, not guessed —
same discipline as the rest of this project's data grounding.

## What's in it

10 real Indian ADB-financed road projects. Still **too small to train on**
(n=10, several rows incomplete) — this is calibration/validation evidence,
not a training set. It checks the synthetic dataset; it doesn't replace it.

## Headline finding: a real project where ADB itself names land acquisition as the delay cause

**Chhattisgarh State Road Sector Project (44427-013)** is the strongest
single record in the corpus. From ADB's own Project Completion Report
(July 2021):
- Land acquisition/resettlement/utility-shifting cost ran 12% over budget
  ($16.3m appraisal → $18.5m actual), on a project acquiring 17.5 hectares
  from 579 titleholders plus 2,289 non-titleholders affected.
- ADB's PCR explicitly states: **"limited availability of encumbrance-free
  land in some sections exacerbated the delays."**
- One 60.81 km road package was **dropped entirely from the project**
  because land acquisition was never completed.
- Result: project completion slipped 18 months from the original plan
  (Dec 2017 → June 2019), 12 months from the revised plan (loan closing
  extended twice, June 2018 → June 2019).

This is a genuine, ADB-attributed, real-world instance of land acquisition
directly causing project delay and even causing scope to be cut — the exact
mechanism this tool is built to flag earlier. Use this as the anchor
example in judge Q&A over the vaguer PRAGATI percentage-of-issues framing.

## Contrasting case, for honesty: a real project where land acquisition was NOT the cause

**Bihar State Highways Project (41127-013)** — a different, earlier Bihar
project from the one already in the corpus. ADB's PCR states plainly: **"no
land acquisition was required"** (improvements stayed within existing
right-of-way). Yet the project still slipped 50 months (physical completion
appraisal Jan 2012 → actual March 2016), driven instead by local insurgency
and 2 of 9 contractors' poor performance.
**Why this matters for the pitch:** it's honest evidence that land
acquisition is a major driver, not the only one — useful to pre-empt a
judge asking "what about delays your tool wouldn't catch?" This tool's own
`buildTopDrivers()` already surfaces 5 categories, not just compensation, so
the product design already anticipates this; this record is real-world
proof for why that breadth matters.

## Updated delay-band cross-check (now n=4, not n=3)

- **revised→actual** (closest analog to `predictedDelayMonths`, which
  predicts delay from the current plan forward): **4.27, 5.72, 9.17, 12.0
  months (mean ~7.8)**. Three of four land inside or at the edge of
  `lib/riskScore.ts`'s HIGH band (4–8 months); the Chhattisgarh 12.0-month
  figure — the one project where land acquisition is explicitly the named
  cause — lands just past HIGH and close to the CRITICAL band's 10–14 month
  range, which is arguably the more meaningful match given its cause.
- **original→actual** (full historical slippage, not what the tool
  predicts): now 40.25, 45.77, 21.16, 4.86, 50.0, 18.0 (mean ~30).

**Caveat to state plainly if asked:** n=4 is still not a validation sample.
These are ADB-financed national/state highway projects, not the
district-level land-acquisition monitoring this tool targets. Treat this as
"our banding isn't obviously wrong, and the one project with an explicit
land-acquisition cause matches the higher-risk end," not "our model is
statistically validated."

## Other usable facts

- **Bihar State Highways II** (the project already in the corpus, distinct
  from 41127-013 above): land acquisition + resettlement + utility shifting
  budgeted at $78.93m of a $424.7m project (~18.6% of total cost). ADB
  recommends ~50% of land be acquired *before* contract award — good
  concrete number for "how much does land acquisition actually cost."
- Safeguard categories confirm land/resettlement materially differs by
  project: Madhya Pradesh State Roads II lists involuntary resettlement as
  *not applicable*, Bihar 41127-013 required none at all, while Karnataka
  SHIP, MP District Connectivity, and Chhattisgarh SRSP are all category A/B
  — real evidence that land-acquisition risk varies enough per project to
  need per-project monitoring rather than a flat assumption.

## What this does NOT change

- Synthetic training data remains 100% synthetic (1150 rows). No change to
  `generate_dataset.py` weights — real figures are broadly consistent with
  the existing bands; retuning off n=10 (n=4 for the delay-months check)
  would overfit noise, not improve the model.
- Still true: no public dataset links individual project features to
  outcomes for India specifically. This pack strengthens the *citation and
  calibration* story, not the training data itself.

## If there's time before demo (unchanged priority from HANDOFF.md)

Expanding toward the full 108-report ADB corpus (per Andrić et al. 2024)
remains the single highest-leverage real-data task. Two more full PCRs were
pulled today (Bihar 41127-013, Chhattisgarh 44427-013) using the same
method: web-search the ADB project page/PCR PDF, fetch the full PCR,
extract cost/schedule/land-acquisition fields with `source_url`, never fill
gaps by guessing. Repeating this for another 10-15 ADB India road PCRs
(search "ADB India [state] road project completion report") would
meaningfully deepen the corpus in another hour or two of work.
