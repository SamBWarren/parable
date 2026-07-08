# parable — a pseudo-Fable mode for Claude Opus

**Parable is an unofficial, community-made pseudo-Fable mode for Claude Opus
(and Sonnet): Claude Fable 5's working discipline, distilled into a Claude
Code skill set plus a hook mechanism.** It is not affiliated with or endorsed
by Anthropic, and everything in it comes from one user's subjective
experience on one project — see the [disclaimer](#disclaimer) below.

Parable comes out of a short study of head-to-head runs between Fable and
Opus on a real project, asking why Fable's work felt an order of magnitude
tighter from the same lazy prompts. The finding, in that study: **most of
the gap — roughly 90% of it — was procedure, not intelligence.** This repo
is that procedure, packaged. In the author's personal, anecdotal opinion it
makes Opus meaningfully sharper in practice — on most tasks the scaffolded
work was hard to tell apart from the Fable baseline, and on some tasks
(multi-agent adjudicated audits) it beat that baseline. That is one user's
opinion from one project, not a measured or warranted claim. The honest
version of the pitch: here is exactly what was done, here are the numbers,
and here is the harness to get your own.

The study used baselines, seeded bugs, firewalled agents, and a comparator
required to hand-verify citations so a well-written hallucination couldn't
win. Methodology and numbers:
[`skill/parable/EXPERIMENTS.md`](skill/parable/EXPERIMENTS.md).
**Up front:** those numbers come from one small study on one codebase. Treat
them as directional and re-run [the testing protocol](docs/testing-protocol.md)
on your own project. Highlights:

- **Solo found 4/6 defects in a no-trail audit. A 3-way adjudicated ensemble
  found 6/6** — every disagreement between agents marked a real finding.
- **Planning briefs went from 4/4 below the baseline to 4/4 at it in ≤3
  ratchet rounds** — by distilling what the frontier model *did* (its tool
  sequences, not just its prose) into written planning gates.
- **Visible output dropped from ~13,000 words of thinking-out-loud to
  frontier-tier short status lines** without losing any reasoning — it moves
  into an append-only thoughts file you read when you want it.
- Once briefs were tight enough, implementation seats moved to a **cheaper
  model at roughly 1/5 the token cost**, with a stronger-model review gate
  catching anything the cheaper model missed.

## Repo layout

| Path | What it is |
|---|---|
| `skill/parable/SKILL.md` | Core: channel discipline + the format contract |
| `skill/parable/director.md` | Plan → delegate → report → review-gate playbook |
| `skill/parable/coordinator.md` | The layer above: pipelines, watches, experiments |
| `skill/parable/method.md` | The five-gate loop for hard problems |
| `skill/parable/ensemble.md` | N-way adjudicated ensembles (the 6/6 protocol) |
| `skill/parable/planning.md` | P1–P9 planning gates (incl. "paste the evidence") |
| `skill/parable/review.md` | The second-agent review gate (feel claims need feel metrics) |
| `skill/parable/debugging.md` · `feature.md` · `research.md` | Per-task addendums |
| `skill/parable/PROMPTING.md` | The exact prompts to type, incl. model-per-seat |
| `skill/parable/exemplar_*.md` | Synthetic exemplars that define the output bar |
| `skill/parable/EXPERIMENTS.md` | The experiment data behind every claim here |
| `hooks/rules-card.template.md` | ~300-word rule card injected into every prompt |
| `hooks/rule-refresh.sh` | Periodic re-injection (5-min cooldown) via PostToolUse |
| `hooks/settings.template.json` | The three hook wirings |
| `docs/method-walkthrough.md` | A generic step-by-step write-up of the method |
| `docs/testing-protocol.md` | The A/B, seeded-bug, decay, and artifact tests |

## Placeholders (fill these in)

The skill and hook files use `{{DOUBLE_BRACE}}` placeholders so they stay
project-agnostic. Replace them (or leave the optional ones out) before use:

| Placeholder | Meaning | Worked example |
|---|---|---|
| `{{PROJECT_ROOT}}` | Absolute path to the repo the agents work in | `/home/me/acme-app` (or `C:/dev/acme-app`) |
| `{{NOTES_DIR}}` | Permanent thoughts-file directory, **outside** the project repo (so links survive and agent deliberation never pollutes the tree or a diff) | `/home/me/agent-notes` |
| `{{BUILD_CHECK}}` | Your compile/type/lint gate command | `npm run typecheck && npm run lint` |
| `{{RUNTIME_CHECK}}` | The command that actually runs the app and surfaces runtime errors | `npm run smoke` (or `./run --headless scenes/boot`) |
| `{{PROJECT_SKILL}}` *(optional)* | Name of your project-context skill, if you have one | `acme-context` |

## Install

1. Copy `skill/parable/` into `~/.claude/skills/`.
2. Render `hooks/rules-card.template.md` → `.claude/rules-card.md` in your
   project, substituting the placeholders (and deleting the
   `{{PROJECT_SKILL}}` line if it doesn't apply).
3. Copy `hooks/rule-refresh.sh` into your project's `.claude/`.
4. Merge `hooks/settings.template.json` into your `.claude/settings.json`,
   replacing `{{PROJECT_ROOT}}` in the `PostToolUse` command with the
   absolute path to your project. (JSON has no comments, so the wiring is:
   `UserPromptSubmit` and `SubagentStart` `cat` the rule card at every
   start; `PostToolUse` runs `rule-refresh.sh`, which re-plants a condensed
   reminder at most once per 5 minutes per session via a `$TMPDIR` stamp
   file.)

The one mechanical trick that matters most: **rules decay in long agent
runs.** A 30-minute worker forgets its style contract by minute 20. The hooks
fix this — the rule card is re-injected at every prompt and subagent start,
and the cooldown script re-injects a condensed reminder every 5 minutes of
tool activity.

## The core ideas, in one minute

1. **Conclusions in the channel, cognition in the thoughts file.** The
   transcript is the product, not the workspace. Agents append their
   deliberation to a markdown file and show you verdicts.
2. **Roles.** A DIRECTOR translates your request, plans visibly, delegates,
   and runs a review gate — it never implements. WORKERS are near-silent and
   leave grep-able `[DONE P<n>]` markers. A COORDINATOR runs multi-round
   programs and verifies everything decisive by hand.
3. **Naming a check is not running it.** Every rule demands pasted command
   output or measured before/afters. "I verified X" doesn't count; the grep
   output does. This one principle killed almost all false claims.
4. **Disagreement is signal.** For hard problems, run 2–3 agents on identical
   prompts, firewalled from each other, and have an adjudicator mine their
   contradictions. Every contradiction we hit marked a real finding.
5. **The ratchet.** Every miss becomes a written rule the same hour, in the
   file where it would have been caught. The skill grows only from its own
   misses.

## Usage

Prompt lazily — the whole point is that the scaffolding does the work:

> continue {{your project}} using the parable skill in DIRECTOR mode
> (director.md) [and the {{PROJECT_SKILL}} skill] — <your request in your own
> words>

Append a mode/model suffix when you want to override the director's triage:

- **`solo mode — no subagents`** — cheap, simple, single-file changes.
- **`use the ensemble`** — hard unknowns, or anything a previous fix failed
  to fix.
- **`workers on Sonnet where the brief is complete`** — cut token burn by
  putting cheaper models in well-specified implementation seats (the review
  gate stays on the stronger model).

For multi-feature pipelines or "iterate until" work, swap `DIRECTOR` for
`COORDINATOR` mode. Full prompt templates are in
[`skill/parable/PROMPTING.md`](skill/parable/PROMPTING.md).

## Testing

Don't take the numbers above on faith — the harness is the most transferable
part of this repo. [`docs/testing-protocol.md`](docs/testing-protocol.md)
walks through four tests you can run on your own backlog: an A/B protocol
(one afternoon), a seeded-bug recall protocol (solo vs. ensemble vs. a
competitor), a decay test (does the style survive a 30-minute run?), and an
artifact test (do the rules demand evidence or accept a bare claim?).

## Honest caveats

- **The numbers are from one small study on one codebase**, run by one
  person. N is small. Re-measure on your project; trust your own numbers
  over the study's.
- **The coordinator layer assumes Claude Code's agent/notification
  machinery** (background agents, hooks, SendMessage, Monitor). The director
  + worker split and the five gates work anywhere skills work.
- This makes a cheaper model *procedurally* frontier-like. A skill file
  cannot give a model more capacity: on genuinely novel judgment calls, the
  strongest model you have is still the strongest model — which is why the
  method puts cheaper models in well-briefed seats and keeps the strongest
  one at the review gate.

## Contributing

**This repository does not accept contributions.** It is published as a
read-only snapshot of a working method: issues are disabled and pull
requests will be closed unread. It's MIT-licensed precisely so you don't
need anything from the author — fork it, adapt it to your project, and run
your own ratchet on your own misses.

## Disclaimer

**Unofficial.** This project is not affiliated with, endorsed by, or
sponsored by Anthropic. "Claude", "Claude Fable", "Claude Opus", and
"Claude Sonnet" are Anthropic's model names and are used here only to
identify the models the skills are written for.

Everything in this repository — the method, the rules, and every number
cited — is a community distillation of **one user's subjective, anecdotal
experience on a single codebase over a short study**. Statements like "this
makes Opus work like Fable" or "smarter in practice" are the author's
personal opinion, not a benchmark, a guarantee, or a claim about model
capabilities. It may not work for your project, your tasks, or your
definition of better; run [the testing protocol](docs/testing-protocol.md)
and trust your own results. Provided as-is, without warranty of any kind,
under the [MIT License](LICENSE).
