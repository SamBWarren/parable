# EXPERIMENTS — how this skill was measured

> **Read this first, honestly.** Every number below comes from ONE two-day
> study on ONE codebase, run by one person. N is small; tasks were chosen by
> hand; the "frontier baseline" was a single stronger model. These are
> directional findings that shaped the rules in this skill — not a benchmark.
> Do not treat them as guarantees. The whole point of `docs/testing-protocol.md`
> is that you should re-run the measurements on YOUR project before believing
> them. Where a result is a single anecdote, it is labelled as one.

## Why the study existed
The question under test: **how much of the gap between a frontier model and a
cheaper, well-scaffolded model is procedure rather than raw capability?** The
method was to capture what the stronger model DID on real tasks (from its
tool sequences, not just its prose), distill that into written rules, then
run the cheaper model against the same prompts under those rules and grade
the pairs blind-ish, with citation spot-checks.

## Methodology (the loop)
The programs in `coordinator.md` §4 are exactly what was run:

1. **BASELINE** — capture the stronger model's runs on a task, including the
   full tool-call sequence (the process of a near-silent strong agent lives
   in *what it read, in what order* — not in its visible text).
2. **DISTILL** — turn those sequences into written gates and questions (this
   is where `planning.md`, `review.md`, the `method.md` gates came from).
3. **CHALLENGE** — run the cheaper model on the *identical* prompt under the
   distilled rules. Agents were **firewalled**: explicit deny-lists of paths
   so a challenger could not see the baseline's diff, notes, or branch.
4. **COMPARATOR** — a grading agent scores the pairs and is **required to
   spot-check N citations per brief** (file:line, "X doesn't exist", measured
   numbers) so a well-written hallucination can't win. Hand-verified ground
   truths were injected into the comparator's prompt as settled facts.
5. **RATCHET** — every miss becomes a written rule in the file where it would
   have been caught; then only the residuals are re-run.

Two instruments made the grading trustworthy:
- **Seeded bugs** — realistic defects disguised as plausible commits, for
  diagnosis tasks. Disclosed honestly in the records. When a seed proved too
  easy, that was itself a finding ("trail-based diagnosis is solved"), not a
  failure.
- **Citation spot-checks** — the comparator re-derived a sample of each
  brief's load-bearing claims from primary sources before accepting them.

## Headline results (all from the one study — treat as directional)

**1. Signal density: ~13,000 visible words → ~1,000, same work.**
Moving all deliberation into an append-only thoughts file (tool calls fold
away in the transcript; visible text doesn't) collapsed the visible channel
by roughly 13× on a representative multi-part task, with no loss of reasoning
— the reasoning is in the linked file for anyone who wants it. This is the
most reliably reproducible effect and the cheapest to verify yourself.

**2. Adjudicated ensemble beat solo on a no-trail audit: 6/6 vs 4/6.**
On a no-clues correctness audit of one module (no symptom, no diff — the
agent had to find deviations from the intended design by reading), the union of candidate
findings across all runs was 6. A single scaffolded solo agent found 4 of 6.
The best single agent among the ensemble found 3 of 6. **Three independent
scaffolded agents + an adjudicator found 6 of 6** — including one real
shipping defect that exactly one of the agents caught. Every contradiction
between agents marked a real finding; two agents each confidently declared
"exact / clean" the very code a peer had flagged. Cost: ~670k agent tokens
across six agents — spend it only where being wrong is expensive (that is
what the triage table is for).

**3. Planning briefs: 4/4 below the bar → 4/4 at the bar in ≤3 ratchet rounds.**
Four design-brief tasks started below the frontier baseline. Two ratchet
rounds — (a) "excavate the prior art and ask *is it already built?*
first"; (b) "PASTE THE EVIDENCE: an absence claim without pasted command
output is invalid" — moved all four to at-baseline. The comparator's key
diagnosis across rounds: *"cites the rule, treats the citation as the
check."* Named-but-not-run rules were every remaining failure. This is the
origin of the master lesson below.

**4. Cheaper implementation seats under a stronger review gate: ~1/5 the cost.**
Once briefs were complete enough that being wrong required disobedience
rather than misjudgment, implementation seats were swapped from the stronger
model to a cheaper one at roughly one-fifth the token cost, with the review
gate kept on the stronger model to catch anything the cheaper model missed.
(This is a cost observation from the study's own runs, not a controlled
quality comparison.)

## Task-type observations (qualitative, from the same runs)
- **Trail-based diagnosis** (a bug reachable from a recent diff) was *solved*
  at the skill level, solo — a diff turns insight into archaeology.
- **Read/research tasks** were cheap and close between models; the
  differences came from thoroughness discipline (the anomaly ledger, the
  implication tax), not speed.
- **The frontier model's residual edge was mechanism-level insight** — *why*
  something behaves and *what breaks if you deviate* — not coverage. The
  cheaper model covered; the stronger model explained. The ensemble's forced
  reconciliation is what recovered most of that edge for the system.
- **The single biggest failure mode was environment realism**: when a
  reported bug could not physically reproduce (an isolated clone with no
  pointer to the known-good generated data), two disciplined agents each
  confidently root-caused a *different* secondary issue. Hence the honesty
  rule in `debugging.md` D6 and the "borrow artifacts" rule in the core.

## The master lesson (generalizes past this study)
**Naming a check is not running it.** Agents will cite a rule by name while
violating it. Every rule that matters in this skill therefore demands a
**pasted artifact** — command output for absence claims, a measured
before/after for feel/UX claims, a citation for precedent claims — because an
artifact can only be produced, not performed. If you take one thing from
these experiments, take that, and apply it when you write your own ratchet
rules.

## What this does NOT show
- It is not a benchmark and not a controlled trial at scale.
- The ensemble result is one audit on one module.
- "At the baseline" is a human grader's judgment, not an automated metric.
- Your codebase, language, and verifiers will move all of these numbers.
Run `docs/testing-protocol.md` on your own backlog before you rely on any of
this.
