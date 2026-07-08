# Testing protocol — measure this on YOUR project

Don't take the numbers in `../skill/parable/EXPERIMENTS.md` on faith.
They come from one small study on one codebase. The test harness below is the
most transferable part of this repo: run it on your own backlog and decide
for yourself. Everything here assumes you have (or can cheaply build) a few
objective verifiers — tests, probes, a compile/lint gate. **Without
verifiers, none of these measurements mean anything** (see "Build verifiers
first" below).

---

## 0. Build verifiers first (the prerequisite)
Cheap objective checks — unit tests, integration probes, a telemetry line per
feature, strict compiler/lint settings, a reusable smoke test — are what let
you buy quality with compute. This is the single highest-leverage step and
the thing every measurement below depends on. If your project can't answer
"did this actually work?" with a command, fix that before running any of the
protocols here.

Define your two commands up front — you'll reuse them everywhere:
- **{{BUILD_CHECK}}** — your compile/type/lint gate (exits non-zero on
  breakage). Remember a clean build can still hide a runtime-only failure.
- **{{RUNTIME_CHECK}}** — the command that actually exercises the app and
  surfaces runtime errors.

---

## 1. The A/B protocol (one afternoon)
Compares this skill against a stronger baseline model, or against any
competing workflow package.

1. **Pick 3 tasks from your real backlog**: one bug that has a reproduction,
   one multi-file feature, and one "diagnose why X feels wrong / behaves
   wrong" with no obvious trail.
2. **Run each task twice from the *identical* lazy prompt** — once with the
   baseline (a stronger model, or the competing package), once with the
   cheaper model + this skill. **Firewall the runs**: different branches, no
   shared notes, and don't let run 2 see run 1's diff. A firewall is an
   explicit deny-list of paths, not a polite request.
3. **Score four axes, by hand:**
   - **Signal density** — words of visible output vs. decisions actually
     made. Count them. (In the origin study this went from ~13,000 to
     ~1,000 visible words for the same work — the reasoning moved into an
     append-only thoughts file, not out of existence.)
   - **Defects caught before merge** — does the workflow have a review gate,
     and did it catch anything *real*? Count the pre-merge catches that a
     happy-path test would have missed.
   - **False-claim rate** — spot-check 3–5 factual citations per run
     (file:line, "X doesn't exist", measured numbers). This is where
     well-written output goes to die: in the origin study, three separate
     agents once confidently reported a component was absent, and a
     30-second `head -3` chain down the inheritance tree proved it present.
   - **Tokens and wall-clock**, reported honestly.

Recall and counts end arguments that adjectives can't. Write the four numbers
per run into a table and compare.

---

## 2. The seeded-bug protocol (for diagnosis tasks)
The sharpest way to compare solo vs. ensemble vs. a competitor on diagnostic
recall.

1. **Plant 4–6 realistic bugs**, each disguised as a *plausible commit* (a
   sign flip in an "improvement", a dropped guard clause in a "cleanup", an
   off-by-one in a "refactor"). Record exactly what you planted and where —
   honestly, in a file the graded agents can't see.
2. **Run three arms** on the identical audit prompt, firewalled:
   - a single solo agent (`solo mode — no subagents`),
   - an adjudicated ensemble (`use the ensemble` — N independent agents +
     an adjudicator, per `../skill/parable/ensemble.md`),
   - the competitor / baseline.
3. **Score recall** — how many of the planted bugs each arm found, and how
   many *real, unplanted* defects it surfaced as a bonus. Note which findings
   came from exactly one agent in the ensemble (those are the ones a solo run
   would have missed).
4. **Watch for the "declared clean" failure**: an agent that confidently
   clears a code path a peer flagged is the signal that its coverage, not its
   judgment, was the limit. Require a per-subsystem coverage citation for any
   ALL-CLEAR verdict.

When a seed proves trivially easy, that's a finding ("trail-based diagnosis
is solved at the skill level"), not a failed experiment — record it and make
the next seed harder (no trail: a subtle behavior deviation with no symptom
and no diff to follow).

**Environment realism caveat (learned the hard way).** If a bug can't
physically reproduce in the agent's environment — an isolated clone missing
the known-good generated data — the agent will confidently root-cause some
*other* secondary issue and call it done. Always tell each agent where a
known-good copy of any gitignored/generated data lives, or your recall
numbers measure the wrong thing.

---

## 3. The decay test (does the workflow survive a long run?)
A skill read at minute one is buried by minute thirty.

1. Give the agent a task that takes **30+ minutes of continuous tool use**.
2. At the end, check whether the **output style and the hard rules survived**
   to the last message: is the visible channel still terse verdicts, or did
   it drift back into thinking-out-loud? Did the late-run work still run the
   verification gates, or start claiming instead of checking?

Static prompt-only packages decay here. The hook mechanism in `../hooks/`
exists specifically to defeat this: the rule card is re-injected on every
prompt and subagent start, and `rule-refresh.sh` re-plants a condensed
reminder on a 5-minute cooldown during long tool activity. Run the decay test
with the hooks off, then on, and compare the last five visible messages.

---

## 4. The artifact test (does a rule demand evidence or accept a claim?)
The cheapest test, and the one competing packages most often fail.

Grep the package's rules and ask, for each rule that matters: does it demand
a **pasted artifact** (command output, a measured before/after, a citation),
or will it accept a **compliance claim** ("verified", "done", a checkmark)?

A rule that accepts a claim will eventually be satisfied by a hallucination —
an agent will cite the rule by name while violating it. This is the master
lesson of the whole method: **naming a check is not running it.** Every rule
in this package that matters demands the command output, not the assertion.
Hold your own ratchet rules to the same bar: if a new rule can be satisfied
by writing "I checked", rewrite it to require the artifact.

---

## Reporting your results
Keep it honest and small:
- the four A/B numbers per task,
- seeded-bug recall per arm (and the one-agent-only findings),
- decay: survived / drifted, hooks off vs. on,
- artifact audit: which rules would accept a bare claim (fix those).

If your numbers differ from `EXPERIMENTS.md` — they will — trust yours. One
codebase's study is a starting hypothesis, not a result you inherit.
