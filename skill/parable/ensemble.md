# ENSEMBLE — adjudicated N-way diagnosis (capability amplification)

WHEN: mechanism-level unknowns, "feel" regressions, high-stakes diagnosis,
or whenever the director judges a single worker insufficient. The evidence
(EXPERIMENTS.md): on identical hard problems, the UNION of independent runs
contained nearly every observation in the best-known answer — what any
single run lacked was the synthesis. This protocol forces the synthesis.

## Protocol
1. **N independent workers** (default 3; Opus, or mix Opus/Sonnet for error
   diversity), identical brief, separate thoughts files, NO cross-talk, and
   for diagnosis: READ-ONLY (no edits, no commits, no shared-config swaps —
   runs parameterized via CLI args/env only, so parallel workers don't
   collide over one project copy).
2. Each worker returns: root cause + a CAUSAL CHAIN from root to each
   symptom clause (every link marked tested or assumed) + its anomaly
   ledger + a proposed minimal fix.
3. **The adjudicator** (fresh agent, this file + review.md V2.5) gets all N
   reports. Its job is NOT to pick a winner — it MINES DISAGREEMENTS:
   - Every contradiction between competent reports marks a load-bearing
     unknown. Resolve each with a test or a code-path citation, not a vote.
   - Every observation unique to one report gets checked against the others'
     chains: does it break them, or complete them?
   - Unexplained anomalies from ANY ledger must be explained or promoted.
   It returns one coherent chain that survives all N reports' evidence —
   the union of observations, the synthesis of mechanism.
4. The director gates the adjudicated answer as usual (review gate applies).

**Unanimity shortcut (token efficiency):** if all N workers independently
converge on the same verdict AND their key numbers cross-match, skip the
adjudicator — the coordinator does a consistency check (verdicts identical?
numbers agree? residual discrepancies presentation-level only?) and accepts.
Spawn the adjudicator only when there is disagreement to mine; that is its
entire value. Unanimous-but-wrong is still possible, so the coordinator
check must include one spot-verification of the decisive citation.

## Why this raises capability (not just compliance)
"Instinct" decomposes into asking the right question + verifying the answer.
Independent sampling generates the observations cheaply; disagreement
between competent agents is a mechanical detector for exactly the questions
worth asking; forced reconciliation makes answering them unavoidable. The
system's ceiling exceeds any single sample's.
