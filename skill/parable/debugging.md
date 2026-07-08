# Parable addendum: DEBUGGING (append after the core)

## D1. Hypotheses are mechanisms with signatures
After reading the recent diff (core §3), write down 2–4 candidate MECHANISMS,
each with the observable signature it would produce — "if A, cost scales with
X; if B, one-time on first use; if C, only when rendering". If you can't name
a hypothesis's signature, you don't understand it well enough to test it.
Ask of each recently-changed code path: what does it cost, how often does it
run, and what does it touch that others share?

## D2. Secure a red-capable reproduction early
Before deep analysis, establish ONE command you can run that goes red on
this bug (shows the symptom concretely) and will go green when it's fixed —
a probe run, a test, a measured scenario. Reading the diff first is how you
DESIGN that command well; but no root-cause claim is finished until the
loop has gone red for the reason you named. Tighten it: faster, sharper
signal, deterministic.

## D3. Design ONE discriminating measurement
Prefer a probe whose output SHAPE identifies the mechanism — the symptom
metric tracked against time AND the suspected driver (count, size, distance)
— so one run can kill several hypotheses at once. Instrument ONCE,
comprehensively: symptom metric + driver variables + a cheap timer around
each suspect path in the SAME probe. Aim for a first faithful run that both
reproduces and ranks the suspects.

## D4. Never test a hypothesis by building its fix
Test with cheap toggles: disable a subsystem, add a counter, flip an env
flag, bisect. Writing a candidate fix "to see if it helps" is the most
expensive possible experiment — and "I'll revert it" doesn't excuse it; the
revert costs the time twice. If you catch yourself editing system code
before the evidence names the cause, STOP mid-edit and go back to toggles.
You change behavior exactly ONCE: after the evidence names the cause — the
SMALLEST change at the level where the invariant lives, with a comment
stating the constraint the code can't show.

## D5. Root cause means a causal chain that explains the SYMPTOM'S SHAPE
"X happens per Y, costing ~k×N, because Z" — with numbers and file:line.
The named mechanism must account for the reported symptom's MAGNITUDE,
DURATION, and GROWTH — a one-time 200 ms stall does not explain "hitches for
15 seconds"; a flat per-frame cost does not explain "then it's smooth". If
your mechanism's arithmetic can't reproduce the curve the reporter described,
you have found A bug, not THE bug — keep looking, and say so.
Validate the fix with a before/after from the SAME measurement (core §6:
then stop). State in the commit message the mechanism and the numbers.

## D6. If you never reproduced the reporter's symptom, say so in the headline
Sometimes the environment can't reproduce it (missing data, wrong platform).
You may still fix real costs you found — but the FIRST sentence of your
report must say the reported symptom was never reproduced and the fix is
therefore unverified against it. A confident root-cause claim built on a
synthetic stand-in loop is the most expensive kind of wrong. Also: a
measurement that reads ~zero for a suspect is only exonerating if the
conditions that make the suspect expensive were PRESENT (the crowd spawned,
the cache was cold, N was large) — check the driver before ruling out.
