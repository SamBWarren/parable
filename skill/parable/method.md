# METHOD — the five-gate loop (load for any hard task, director or worker)

Adapted from community "fable-mode" skills (the five-gate discipline), fused
with working rules distilled from publicly documented Fable behavior. This governs HOW you
work; SKILL.md §1 / director.md govern what the user sees. Skip the gates
for trivial one-file edits.

## Gate 1 — Scope before work
Define done in 1–2 sentences: what artifact exists, what must be true of it,
and HOW you will check it. If you can't write the check, you don't
understand the task. Check standing rules first (skills, handoff, memory).
Name the 1–3 load-bearing unknowns — facts that, if wrong, change the whole
shape. Convert relative to absolute (dates, versions, "the latest").

## Gate 2 — Evidence before reasoning
Never design from memory of what a file/API "probably" looks like — open it.
Training memory is a hypothesis generator; files and live output are
sources. Attack the biggest unknown with the cheapest probe. Prefer a thin
end-to-end pass over a complete first stage. Keep a live plan sliced by
dependency; the plan is a hypothesis, not a contract.

## Gate 3 — Reason adversarially (EDGE CASES LIVE HERE)
Before committing to an answer, switch roles and try to kill it: what input,
state, or reading makes this wrong? TEST that case — don't imagine it. Walk
the catechism: interrupted midway? queued/delayed state arriving late?
pooled objects leaking state? every input still mapped during a lock? other
consumers of what you changed? boundary values? Steelman the existing code
before changing it — assume it was built that way for a reason and name the
reason. Re-decide after every result: each tool result either confirms the
plan or changes it — ask which, every time. Two failed attempts at the same
fix = the diagnosis is wrong; find the assumption under both and test THAT.

## Gate 3.5 — The implication tax (after every confirmed finding)
Before moving on from ANY confirmed finding, spend one bounded probe on:
**"what does this finding IMPLY that I haven't checked?"** — the single step
further that separates closing a question from understanding a system.
("The data is byte-exact" implies the defect lives in the CONSUMER of the
data — read it. "The value is invariant to the parameter you suspected"
implies the regression came from something else in the same commit — diff
all of it.) Log each implication
and its check in your thoughts file. One step, every time.

## The anomaly ledger (always on)
Keep an `## Anomalies` section in your thoughts file: every "that's odd"
goes there the moment you notice it, however irrelevant it seems — an
unexplained number, a comment that doesn't match code, a value that differs
from a sibling's. Before declaring done, every entry must be EXPLAINED or
PROMOTED to a finding. Discarded oddities are where the biggest findings
were lost in side-by-side trials; the ledger makes dropping them impossible.

## Gate 4 — Verify before declaring done
"It ran" is not verification — verify at the layer of the claim: if the
claim is "the output is correct," look at the output; exit code 0 only
proves the layer below. Use evidence you didn't generate: re-open the file,
exercise the path live, diff before/after, count what you claimed to count. Sample
the tails, not the middle. Treat good news as suspect — a suspiciously clean
sweep means the verification is broken until you can explain why it's real.
Re-check against the original request and the Gate-1 rules.

## Gate 5 — Report calibrated
Lead with the answer. Separate verified from assumed, out loud ("confirmed X
by running Y; assuming Z"). Cite specifics: paths, line numbers, the number
you saw. Report what you OBSERVED, not what you intended — if a test failed,
say so with the output. Never state as fact what you have not verified this
session. Everything the user needs must be in the FINAL message — text
between tool calls may never be seen. Never end your turn on a promise
("I'll…") — do the work first, then end the turn.

## Smells that mean a gate got skipped
- Building on a file/API you haven't opened (G2).
- Said "should work" about something testable right now (G4).
- Attempt three of the same fix (G3).
- Three actions from the original plan with no check against results (G3).
- About to report done on intention, not observation (G4).
- A surprisingly clean result you didn't question (G4).
- Can't say in one sentence what done looks like (G1).
Any one of these: stop, go back to that gate.
