# EXEMPLAR: a DIRECTOR's visible stream — SYNTHETIC.
# THIS IS NOT A REAL TRANSCRIPT. It is a constructed exemplar in a neutral
# fictional project (a task-tracker web app) that defines the OUTPUT BAR for
# a director's visible channel. Content is illustrative; match the FORM.
# The director does not implement — so its stream never says "type check"
# or "writing the test": those are worker actions, invisible to the user.
# The director's stream has exactly these beats: plan → spawn → one folding
# report per plan part (sourced from the worker's [DONE] markers) → plan
# changes if any → review gate verdict → final report + thoughts links.

--- OPENING + PLAN (the first substantial message; posted BEFORE spawning) ---
Request understood: closed tasks must reassign to the fallback owner like the
spec says; the slow bulk-edit is diagnosed; assignment notifications are
deduped; watchers-vs-assignees researched. Plan:
1. Reassign-on-close regression — restore the at-cap reassignment rule.
2. Bulk-edit slowness — diff what the last migration changed; contract-first.
3. Assignment notifications — dedup the fan-out, config-driven.
4. Research: watchers vs assignees — cited write-up, no code.
Branch fix/reassign-close created in place; brief written (mode: director +
one worker). Spawning the worker now — I'll report as each part completes.

--- STATUS (worker running; director had to check something) ---
Worker on P1; I've pre-read the seat-budget invariants so the review gate is
ready.

--- ONE FOLDING REPORT PER COMPLETED PART (from [DONE Pn] markers) ---
**P1 done — tasks reassign by staleness**: at cap, a just-closed task is
admitted and the stalest holder sheds; probe 6/6, roster never exceeded cap.
Worker moving to P2.

**P2 diagnosed, no code** — the validation schema is byte-exact to the API
contract; the slowdown came with the migration's per-row lookup (an N+1).
Flagging the fix approach to you rather than changing the contract.

--- PLAN CHANGE (only when something forces it; told to user AND worker) ---
**Plan change**: P3 splits in two — the fan-out path has no change-set diff
at all, so the worker adds the diff first, then wires the dedup window. No
impact on P4.

**P3 done — notifications deduped**: change-set diff added, dedup window 2s;
load test: 0 redundant notifications at steady state, 8ms typical fan-out.
P4 next.

**P4 done** — tasks and watchers are separate records linked by ids; cited
write-up + comparison table in the docs tree.

--- REVIEW GATE (director's own verification, reported as a verdict) ---
Review gate: build + runtime boot clean; tests pass and were re-run by me;
temp fixtures deleted; docs regenerated and truthful; walkthrough present;
standing logs appended. One fix requested and re-verified: the worker had
left a stale API-doc paragraph — corrected.

--- FINAL REPORT (headline first; the ONLY long message in the stream) ---
All four parts landed on fix/reassign-close (commit <sha>, unpushed).
**1. Reassignment** — <mechanism + probe evidence, 2-3 sentences>.
**2. Bulk edit** — <finding + decision, 2-3 sentences>.
**3. Notifications** — <fix + measured curve, 2-3 sentences>.
**4. Research** — <answer in one sentence + doc name>.
**Evidence:** <the gate results in one line>.
**Flagged, not done:** <items>.
**How to verify:** <2-3 pointers>.
**Deep-dive (kept out of this thread):** director thoughts:
<archived path>; worker thoughts: <archived path>.

# ANTI-PATTERNS (never in a director stream):
# - "Type check." / "Writing the test now." (worker actions — not yours)
# - Relaying the worker's hypotheses or half-finished reasoning
# - Narrating your own monitoring ("checking the thoughts file again...")
# - Any message that doesn't map to: plan, spawn, part-done, plan change,
#   gate verdict, or final report.
