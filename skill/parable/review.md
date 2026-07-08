# Parable addendum: SECOND-AGENT REVIEW (the two-layer pattern)

Use for SIGNIFICANT features: after the builder agent commits, spawn a FRESH
Opus agent with this addendum (+ the core's §1 voice rules) to review the
branch. Fresh matters — a reviewer who didn't design the change isn't
anchored on its intentions. The reviewer does NOT rewrite; it reports
findings ranked by severity, each with file:line and a concrete failure
scenario, and applies only fixes the orchestrator/user approves.

## V1. Spec compliance first
Re-read the ORIGINAL task words clause by clause. For each clause: where in
the diff is it satisfied, and was it VERIFIED (not just implemented)? "Must
not regress" clauses need evidence of a run, not an assertion.

## V2. The edge-case catechism
Ask each of these against the diff; every "hm" becomes a finding:
- **Interrupted midway**: what happens if the sequence is cancelled at each
  step — the actor is destroyed, the view reloads, the mode switches, the
  request is aborted? Is every piece of borrowed state (view, input focus,
  shared counters, timers, UI) restored on EVERY exit path, or only the
  happy one?
- **Queued/delayed state**: what fires AFTER this code thinks it's done —
  pending callbacks, cooldowns, tweens, one-shots, signals in flight? Can a
  queued thing re-light state this code just cleared?
- **Reuse/pooling**: when the object is recycled for a new owner, which
  fields leak from the previous life?
- **Concurrent inputs**: during any scripted/locked moment, walk the FULL
  input surface (every action in the project's input registry) — which
  handlers still poll? Locks on one node don't silence pollers on others
  (sibling controllers, cameras, debug menus).
- **The other consumer**: who else reads the state this change writes
  (background logic, persistence, UI, pooled instances)? Did they get the
  memo?
- **Boundary values**: zero items, cap reached, a value exactly at a
  threshold, first frame/first tick, the headless/no-UI path.

## V2.5 The mechanism audit (the edge questions)
These encode the moves that separated the frontier baseline from
skill-equipped Opus in side-by-side runs. Ask them of every fix in the diff:
- **Data-exact is NOT mechanism-exact.** For every constant/parameter in the
  diff, trace what code CONSUMES it and verify that code implements the
  formula the constant was designed for — not a hardcoded or approximated
  stand-in. (Live case: a parameter table was verified byte-exact to its
  spec and declared fine; the actual defect was that the formulas downstream
  ignored the per-instance dimensions the design feeds them — the constants
  were right, the machine eating them was wrong.)
- **The diagnosis must explain the symptom's SHAPE.** If the user says
  "since X" / "worse than Y" / "for the first N seconds", the accepted
  mechanism must account for each clause, quantitatively where possible
  (a term measured at HALF its intended value explains an over-sensitive
  response; "the table changed" does not explain "worse than before").
- **The collateral diff.** For "it broke when we did X": diff EVERYTHING
  commit X changed — not just the file the symptom points at. The cause is
  often a rider (a config param, an import/build setting, a retuned sibling),
  and the file everyone stares at is byte-identical.
- **Invariant stress.** Name the invariants the touched system promises
  (budgets, one-slot-per-pair, caps, ordering) and construct the input that
  most wants to break each one; check the code path, don't intuit it.

- **Feel/UX claims need behavioral metrics.** If the deliverable promises a
  FELT or perceived change ("recovers faster", "more stable", "snappier"),
  a formula-level probe is NOT evidence of it — demand a behavioral
  before/after metric (recovery time, latency, a measured trace) from a
  scripted run. (Incident: several formula fixes landed with formula probes
  green and a promised feel change; the user felt nothing — the dominant
  term for that feel lived in a different branch than the fixes.)

- **A UI probe that checks a "visible" flag proves nothing about what the
  user SEES.** A widget can be flagged visible, in the tree, with correct
  data, and still render OFF-SCREEN or at zero size. Any UI verification must
  assert the on-screen geometry — the element's rendered rect lies inside
  the viewport — not just the visibility flag and the backing value.
  (Incident: a status-bar probe asserted `hud.visible==true` and the backing
  value matched, and passed, but the whole panel was a zero-size container
  drawing its content off the left edge; the user saw nothing. A runtime
  rect dump found it in one run.)

## V3. Fit and hygiene (quick pass)
House naming/patterns, doc comments where behavior changed, manual updated,
no leftover instrumentation, configs restored, commit message carries the
mechanism.

## V4. Report
Findings ranked most-severe first, each: one-sentence defect + file:line +
concrete failure scenario ("submit the form while the confirmation modal is
still animating in → a second request fires against stale state"). End with
what you checked and found CLEAN — a review that only lists problems hides
its coverage.
