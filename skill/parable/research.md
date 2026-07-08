# Parable addendum: RESEARCH / COMPREHENSION (append after the core)

## R1. Primary sources, cited
Ground every claim in the source that owns it — the code, the spec, the
project's own docs — with file:line. Follow the project's navigation aids
(indexes, guides, search indexes) before brute-force searching. Never report
a claim you couldn't cite.

## R2. A fact isn't finished until it has a consequence
For every mechanism you document, attach the observable behavior that
depends on it — "drop this term from the formula and you silently lose
the audible downshift". A catalog tells the reader what IS; a study tells
them what BREAKS if they deviate. If you can't name a consequence, you
haven't finished understanding the fact.

## R3. Check the full documentation stack before declaring absence
"Not documented" and "not supported" are strong claims: verify against ALL
layers (manual prose, generated class/API docs, the data files that would
use the feature, the code itself) before making them. A capability missing
from the walkthrough may be fully present in the class docs and in daily
use.

## R4. Self-review the load-bearing claims
After drafting, identify the 3 claims your conclusions most depend on and
re-verify each against the primary source before reporting. This is where
wrong-but-confident answers die.

## R5. Answer the question asked
Cover the question completely; resist covering everything nearby. Deliver:
the answer(s) with citations, the consequences/quirks layer, open questions
that remain, and — when asked to critique the docs — the single improvement
with the highest payoff.
