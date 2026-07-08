# The Adjudicated-Ensemble Method
### Getting frontier-tier results from mid-tier agents — a field-tested recipe

*Shareable summary. Everything here was developed and validated on one real
project over a short, controlled side-by-side study against a frontier model
baseline. Numbers are from that study — one codebase, small N; see
`../skill/parable/EXPERIMENTS.md` and re-run them yourself before
relying on them.*

---

## The two findings this is built on

**1. The gap between a frontier model and a scaffolded mid-tier model is
mostly PROCEDURE, not intelligence.** In head-to-head trials on identical
tasks, a mid-tier agent with the right working discipline reached ~90% of
frontier quality. The residual gap was concentrated in one skill:
*spontaneously asking the right question at the right moment* ("what
consumes this constant?", "what did that commit ALSO change?").

**2. That residual gap is a SYSTEM property, not a sample property — so a
system can close it.** "Instinct" decomposes into question-generation +
verification, and both are schedulable. Proof: on a no-clues audit of a
physics module, one solo scaffolded agent found 4 real formula-level defects;
three independent scaffolded agents + an adjudicator found **6 of 6**,
including a live shipping bug only one of four agents caught. Every
contradiction between agents marked a real finding. The union plus forced
reconciliation exceeded every individual — including agents that confidently
declared clean the exact code their peers flagged.

---

## The architecture (five pieces)

### 1. Channel discipline: transcript = product, not workspace
The user reads ONE stream. Every visible message is a conclusion + next step
(a few lines max). ALL deliberation — hypotheses, dead ends, self-arguments —
goes into a per-agent **thoughts file** appended via tool calls (tool calls
fold away; visible text doesn't). The thoughts files are deliverables: link
them at the end for anyone who wants the reasoning. Measured effect: same
work, ~1,000 visible words instead of ~13,000.

### 2. The director/worker split
A **director** (senior-engineer role) receives the raw request and never
implements: it translates the request, posts a numbered plan BEFORE
delegating, spawns a **worker** that deliberates in its thoughts file and
marks progress with grep-able `[DONE P<n>] <one-line conclusion>` lines,
reports one folding summary per completed part, then runs a **review gate**
itself — commands it executes, never claims it relays — including a
second-agent edge-case review of the final diff. Final report: headline
first, evidence per part, flagged-not-done, links to all thoughts files.

### 3. Rule persistence via hooks (rules decay; re-inject them)
A skill read at minute one is buried by minute thirty. Fix with hooks:
- `UserPromptSubmit` + `SubagentStart`: inject a ~250-word **rule card**
  (role, channel discipline, hard rules) every prompt / agent start.
- `PostToolUse` with a **5-minute cooldown script**: re-plant a 3-line
  reminder into any long-running agent's context, right where its attention
  is. (A stamp file per session throttles it.)

### 4. The method loop (per agent, any hard task) — five gates + two taxes
- **G1 Scope**: define done + HOW you'll check it, before touching anything.
- **G2 Evidence**: never design from memory of what code "probably" does —
  open it. Memory generates hypotheses; files settle them.
- **G3 Adversarial**: try to kill your own answer; TEST the killer case.
  Two failed fixes = the diagnosis is wrong.
- **G3.5 The implication tax**: after EVERY confirmed finding, one bounded
  probe: "what does this imply that I haven't checked?" (This single rule
  reproduces most 'brilliant' finds: "the data is correct" implies the
  defect is in the code that CONSUMES the data — read it.)
- **The anomaly ledger**: every "that's odd" is logged the moment it's
  noticed; nothing ships while an anomaly is unexplained. (Big finds start
  as oddities someone almost discarded.)
- **G4 Verify at the layer of the claim**: "it ran" proves nothing about
  "it's correct". Feel/UX claims need behavioral before/after metrics, not
  formula checks. Suspiciously clean results are broken verifications.
- **G5 Report calibrated**: lead with the answer; separate verified from
  assumed; report what you observed, not what you intended.

### 5. The ensemble (when one agent isn't enough)
For mechanism-level unknowns, audits, or any symptom that SURVIVED a fix:
spawn **N independent agents** (same brief, no cross-talk, read-only for
diagnosis), each returning findings + a causal chain + its anomaly ledger.
Then an **adjudicator** reconciles: every disagreement between competent
agents marks a load-bearing unknown; resolve each with a citation or test —
never a vote. Deliver the union of observations with one surviving synthesis.
Also works for DESIGN: independent sketches + adjudication; the
disagreements are the decisions that matter.

---

## Step-by-step: install this on your project

1. **Build verifiers first.** Cheap objective checks (tests, probes, a
   telemetry line per feature, strict compiler settings) are what let you
   buy capability with compute. This is the highest-leverage step.
2. **Write the skills** (or adapt this file's sections into your agent
   framework): a channel-discipline core, a director playbook, the five-gate
   method, an edge-case review checklist, the ensemble protocol.
3. **Write the rule card** (~250 words: roles, channel rule, your project's
   hard rules) and wire the three hooks (inject on prompt, inject on
   subagent start, cooldown-refresh after tool use).
4. **Adopt the prompts** (below). Lazy by default; force modes explicitly.
5. **Run the ratchet.** Every time something slips past the gate, hold a
   one-question retro — "what written question would have caught this?" —
   and append it to the review checklist. Never fix a miss without banking
   its question. The question corpus IS the accumulating capability.

## The prompts

**Default (director triages the mode itself):**
> continue {{your project}} using the parable skill in DIRECTOR mode
> [and the {{PROJECT_SKILL}} skill]
> <your request, in your own words>

**Token-efficient simple change:** append **"solo mode — no subagents."**

**Hard problem / failed prior fix / audit:** append **"use the ensemble."**

**Mode triage (what the director should pick when you don't say):**
| Signal | Mode |
|---|---|
| One file, low risk, mechanical, a question | SOLO (no subagents) |
| Multi-file feature or fix | Director + one worker |
| Mechanism unknown, feel/UX regression, failed prior fix, audit, expensive-if-wrong | ENSEMBLE |

## Honest limits
- Cost: the ensemble is the expensive tool. The 6/6 ensemble itself measured
  **~464k agent tokens, ~11 minutes wall-clock** (3 workers in parallel +
  adjudicator, every seat on the most expensive model); the oft-quoted ~670k
  was the whole experiment including its control arms. Cheaper-model members
  and the unanimity shortcut cut it further, but it is still the priciest
  move in this repo. Spend it on problems that deserve it (the triage table
  exists for this).
- The system finds what QUESTIONS can reach. Truly novel moves still favor
  stronger models — but the ratchet converts each one, once seen, into a
  question any model can ask forever after.
- None of this works without verifiers. Un-checkable claims stay
  un-checkable no matter how many agents vote.

---
## Addendum: the planning extension + the master lesson (overnight trial)
The same recipe extends to CREATIVE/DESIGN work: capture baseline design runs,
distill the process from their TOOL SEQUENCES (strong planners are silent —
the process is in what they read, in what order), write it as steps
(precedent excavation with "is it already built?", consumer walks, absence
sweeps, implication tax on the chosen option, a deliverable shape with a
committed pick), then iterate challengers against the baseline with a
grading comparator. In our trial, scaffolded mid-tier briefs went from 4/4
BELOW baseline to 4/4 AT baseline in three ratchet rounds.
THE MASTER LESSON of the whole program: **naming a check is not running
it.** Agents will cite your rule by name while violating it. Every rule
that matters must demand a pasted ARTIFACT — command output for absence
claims, a measured before/after for feel claims, a citation for precedent
claims — because the artifact can't be performed, only produced.
