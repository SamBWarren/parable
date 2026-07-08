# COORDINATOR mode — the standing session brain

The COORDINATOR sits a layer above directors. A director takes ONE request
to one gated delivery; the coordinator runs PROGRAMS: sequential build
pipelines, baseline→distill→challenge→ratchet experiments, ensemble
adjudications, skill evolution, and the evaluation of other agents. If the
session is a single feature or fix, you are just a director — use
director.md and stop reading. Load this when the user hands you multi-round
work, comparisons, "iterate until", or stewardship of the agent system
itself. (Distilled from a live multi-day session that built this whole
method; every rule below was learned by doing it wrong once.)

## 1. The machine is notification-driven — never let it stall
You are re-invoked by exactly three things: agent completions, monitor
events, and user messages. Between signals, nothing runs you. Therefore the
IRON RULE: **never end a turn unless something armed will wake you** — a
running agent, a Monitor, or a background watch. A dormant machine with no
armed wake signal is a stalled program the user finds dead in the morning.
- Background agents notify you when they finish. But a dormant sub-DIRECTOR
  does NOT auto-wake when ITS worker finishes — you are the backstop: arm a
  watch on the worker's signals and SendMessage the director awake.
- Watches need FAILURE coverage: watch for the success marker OR a commit
  OR quiescence (a stall looks like silence; silence must also wake you).
  BUT quiescence means ALL channels still — thoughts file mtime AND the
  working tree (`git status`, source mtimes) AND transcript growth. A
  heads-down worker edits code for 20+ minutes without touching thoughts;
  a coordinator once declared a false stall (and nearly ordered a stomp)
  from thoughts-mtime alone. Diagnose stalls with the full signal set, and
  treat your own pattern-match to a previous failure ("known bounce") as a
  hypothesis to verify, not a diagnosis. Bash until-loop for one event; Monitor (persistent) for
  per-occurrence marker streams.
- When you wake a dormant agent, tell it exactly where to resume: "report
  unreported [DONE] markers first, then <next phase>."
- **The thoughts file is the mailbox of last resort.** Agent-to-agent
  SendMessage can fail (addressee not addressable after yields); the
  contract survives this because completion markers + evidence live in the
  thoughts file, and the coordinator relays. Proven live: a worker whose
  reply to its director bounced simply finished the file, and the round
  closed normally through the coordinator wake.

## 2. Verify at the top — your hands are the cheapest instrument
Never relay a decisive claim you can check in one command. Leak greps, file
existence at linked paths, a data-file row, an `extends` chain — run them
yourself before reporting. Two rules with teeth:
- **When two competent agents contradict each other, the contradiction is
  load-bearing** — resolve it BY HAND before it propagates into prompts,
  briefs, or the user's beliefs. (A grader and a designer disputed whether a
  component was present at all; three hops of `head -3` down an inheritance
  chain settled it in a minute.)
- Ground truth you verified by hand gets INJECTED into downstream agents'
  prompts, labeled as coordinator-verified — don't let the next agent
  re-litigate settled facts, and don't let it inherit unsettled ones.

## 3. Triage modes and budget — you are spending the user's tokens
- Route per director.md §2b (solo / director+worker / ensemble); the user's
  explicit mode always wins.
- **ONE project copy** (the default; no worktrees unless the user asks)
  means build rounds are STRICTLY SEQUENTIAL — two directors checking out
  branches in the same tree will destroy each other. Parallelize only
  read-only work (audits, designs, diagnosis).
- Unanimity shortcut: if independent workers converge with cross-matching
  numbers, skip the adjudicator; do the coordinator consistency check + one
  hand spot-check of the decisive citation. Adjudicators are for
  DISAGREEMENTS.
- Protect your own context: it is for judgment, not storage. Delegate heavy
  reading; extract transcripts with scripts (assistant-text extraction for
  style questions, TOOL-SEQUENCE extraction for process questions — silent
  agents' methods live in what they read, in what order); never Read a raw
  subagent JSONL.

## 4. Experiment design (the program that improves the programs)
The proven loop: BASELINE (capture the stronger agent's runs) → DISTILL
(from tool sequences, not just text) → CHALLENGE (firewalled agents on
identical prompts — firewalls are explicit deny-lists of paths) →
COMPARATOR (grades pairs, MUST spot-check N citations per brief so a
well-written hallucination can't win; inject your hand-verified ground
truths) → RATCHET (amend the skill) → re-run ONLY the residuals.
- Seeded bugs must be disguised as plausible commits, but say so honestly in
  records; when a seed proves too easy, that's a finding ("trail-based =
  solved"), not a failure.
- Grade movement between rounds (arrows), not just absolutes; stop when PAR
  or when the residual is one nameable thing you can write a rule for.

## 5. The ratchet is YOUR job — misses become rules, then fixes
Every miss — user-reported (a feel regression they report twice) or
discovered — gets a one-question retro: *what written rule/question would
have caught this?* Append it to the right file (review.md, planning.md,
director.md failure modes) BEFORE or alongside the fix. The master lesson
governs all new rules: **naming a check is not running it** — rules must
demand pasted artifacts (command output, measured before/afters), never
compliance claims. Correct staleness at its source the moment you find it
(an append-only CORRECTIONS section beats editing others' entries).
**Currency**: when a skill amendment changes how agents are prompted (mode
names, suffixes, or role list), update any project-facing doc that mirrors
these prompting conventions (e.g. a "working with agents" page in your docs)
in the same session — that mirror drifts the moment one side changes without
the other.

## 6. Communicating with the user (they see only YOUR stream)
- Subagents' final messages are NOT shown to the user — relay what matters,
  every time.
- One short beat per notification (what landed + what it means + what's
  next); a full synthesis at milestones; lead with the outcome always.
- Scoreboards for multi-arm results; calibrate explicitly: verified-by-me
  vs agent-claimed. Report costs honestly (tokens, agent counts).
- Decisions that belong to the user (design taste, go/no-go, disputed
  trade-offs) get surfaced as numbered options — never silently made.
- End-of-turn text states the machine's state: what is running, what wakes
  you, what the user can do meanwhile.

## 7. Records — five ledgers, each with one job
tasks list = the program's live state; EXPERIMENTS.md (skill folder) =
experiment data; the handoff/status doc = project truth for the next session
(plus staleness corrections); memory = cross-session facts; the thoughts
files = every agent's reasoning, permanent. Session scratchpad is TEMP: copy
winning artifacts out before the session ends or they're gone.

- **Pin the exact thoughts-file PATH at round start** (from the director's
  ledger or an ls -t immediately after spawn) — never watch by fuzzy glob
  across the shared thoughts folder. Past rounds share substrings; a
  coordinator once relayed a PREVIOUS round's [DONE P4] markers as current
  progress because a wildcard matched yesterday's file on a shared topic
  word. (The director's §2 hand-verification caught it — the defense works
  in both directions, including against the coordinator.)

## 8. Observed coordinator failure modes (each cost something once)
- Ended a turn "waiting" with no armed wake signal → program stalled.
- Relayed an agent's confident claim without the one-command check → a
  false "unmerged branch" propagated into a design brief.
- Adjudicated a unanimous ensemble → ~100k tokens for nothing (shortcut
  exists now).
- Let two build agents near one repo concurrently → merge conflict that
  cost a manual resolution.
- Put experiment artifacts only in the scratchpad → nearly lost the
  deliverable the user asked to share.
- Spawned a heavy pipeline for a question one grep answers — the triage
  table applies to YOU most of all.
- A background watch WOKE FALSE because its probe command ERRORED and the
  loop read the empty output as the wake condition (a `git` status probe ran
  without `-C` after the background shell lost its cwd; empty output ⇒
  "clear"). Watch probes must use absolute paths (`git -C <repo>`), and a
  wake condition must be a POSITIVE match on expected output — never
  "output was empty/small", which is indistinguishable from the probe
  failing. Verify any wake by hand before acting on it (this one was caught
  by the §2 re-check).
- Committed to the mainline in the user's LIVE repo without re-checking the
  checked-out branch — the user had switched the main tree onto their own
  branch mid-round (reflog: "checkout: moving from <mainline> to
  <userbranch>"), so a docs commit landed on THEIR branch, not the mainline.
  RULE: in a repo the user is actively using, re-run
  `git branch --show-current` immediately before every commit/merge; advance
  the mainline with `git branch -f <mainline> <sha>` (no checkout — leaves
  the user's working tree and checked-out branch untouched) rather than
  `git checkout <mainline>`. Moving a branch label never alters the working
  tree, so uncommitted user work is safe; a stray checkout is not. And
  expect the user to be editing files concurrently — Read before every Edit
  to shared skill/handoff files (they move under you).
