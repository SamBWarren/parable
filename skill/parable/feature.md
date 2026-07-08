# Parable addendum: FEATURE WORK (append after the core)

## F0. Design interrogation BEFORE building (creative work gets questions too)
Bug-finding isn't the only place the right question beats raw effort. Before
writing code for a significant feature, generate and answer the implication
questions in your thoughts file:
- Who CONSUMES what this creates (other systems, persistence, UI, docs), and
  what do they assume?
- What INVARIANTS must hold (budgets, caps, one-owner rules, ordering), and
  what input most wants to break each?
- What's the ESTABLISHED PRECEDENT for this exact problem — in the
  framework, a dependency, or the project's own prior art — and if you're
  deviating, can you name why the precedent did it its way?
- What happens at SCALE (the load target / the perf bar)?
- What does the USER actually experience, and what metric would prove the
  intended experience landed (not just the formula)?
- What becomes HARDER to build later because of this shape?
For major features, an ENSEMBLE of independent design sketches + an
adjudicator (ensemble.md) applies to designs exactly as it does to
diagnoses: disagreements between sketches mark the decisions that matter.

## F1. Conventions before code
Discover the project's house rules BEFORE designing: code style, validation
conventions, documentation obligations, commit format. The project's own
docs and skills tell you what they are; following them is part of the
feature. Fit existing patterns — extend the neighboring idiom, never invent
a parallel one. Where established prior art for the feature exists (in the
framework or the project's own history), read how it does the job first and
follow the mechanism; document any deliberate divergence.

## F2. Smallest implementation at the right level
Explore with reads, not speculative edits. Honor every clause of the spec —
including the "must not regress" parts, which each get their own check.
Prefer containment: new behavior gated so untouched paths are structurally
unaffected (a layer inside the state that uses it beats a global layer).
Data-driven knobs (exports/resources) over constants where the project does
the same.

## F3. Validation
ONE comprehensive check that exercises the whole new path — for visual work,
an eyes-on artifact (screenshot/recording); otherwise a probe with numeric
assertions. Verify the check actually exercised the feature (the input
fired, the state changed) before calling it a pass — a green run that never
hit the new code is not evidence. Then one run of the untouched path for
each "must not regress" clause. Then stop (core §6).

## F4. Self-review before commit
Review your diff as a skeptical senior engineer: correctness first (edge
cases — pooling/reuse, cancellation, destruction mid-action, the state you
must reset), then fit (naming, patterns, doc comments in the house style),
then hygiene (dead code, leftover instrumentation, docs/manual updated,
configs restored). Fix what the review finds BEFORE committing.

## F5. The shipping ritual
Everything the project requires of shipped work: doc comments, manual/site
updates where behavior changed, regenerated artifacts, clean tree, commit
message with the mechanism, correct trailer. List each rule you identified
and how you satisfied it in your report.
