# Parable addendum: PLANNING / DESIGN BRIEFS
Distilled from several frontier-baseline design runs (tool-sequence
analysis; the baselines ran 17-35 reads in near-total silence, then delivered
one complete brief). This is the observed process, written as steps.

## P1. Maps before terrain — start from what's already designed
Read, in order: the live handoff/status doc; the project's roadmap/design
notes; and EVERY existing proposal/design doc touching the topic (search
docs/ for them by name). Planning almost never starts from a blank page — the
baselines anchored on existing proposals and prior art before forming any
opinion. Ignoring a prior proposal is the #1 way to produce a redundant or
contradicting brief.

## P2. Ground the present — read the real implementation end-to-end
Read the core files of the system being extended IN FULL (not grepped
snippets): the data types, the generator/builder, the runtime consumer.
Every "limitation" you claim must carry file:line; count things (records,
edges, fields) rather than gesturing.

## P3. Walk the consumers — the design space is their intersection
Enumerate every system that touches the design surface and read each one (a
graph-data-model baseline read nine consumers: the follower logic, the
decision engines, the event signals, the summary view, the obstacle system,
the streaming/collision layer, the pathing mesh, the authoring tool, and the
base geometry). Each consumer contributes a constraint; the viable design is
what survives all of them. This is where planning quality is won or lost — a
brief that names consumer-by-consumer implications cannot blindside the
builder.

## P4. Precedent before invention — EXCAVATE THE PRIOR ART, and ask "is it already built?" FIRST
Before proposing anything: grep the actual CODE of everything upstream of
you (the project's own history, its frameworks and dependencies, earlier
prototypes) for the feature's nouns — docs describe what someone thought to
document, the code contains everything, including enhancements and successor
features nobody documented. One baseline found the entire requested feature
already implemented in-tree; a challenger that stopped at doc-level
generalities missed it and graded decisively below. Then read the mechanism
AND its real constants/counts — including the special cases (a graph that
special-cases degree-2 nodes is telling you something your adaptation must
honor). Divergences from precedent are allowed but must be explicit, named,
and justified in a decision log. The "is it already built?" sweep covers the
whole PROJECT — its inheritance chains, singletons/autoloads, and prototype
modules (features get built in test benches and inherited into the shipping
build silently).

## P5. Absence sweeps for gap analysis
When the question is "what's missing / what should we build next":
keyword-sweep the build for each candidate (grep for each feature's nouns) to
PROVE absence and to find half-built hooks; then confirm each gap's intended
mechanism is actually specified somewhere actionable (design docs, prior
art, a worked example). Rank by value-per-effort and be
opinionated — a ranked top-3 with reasons beats an exhaustive table (include
the table, but lead with the ranking).

## P5.5. Absence is a claim across the WHOLE stack — run the commands
Never headline "X is missing / unused" from one file's evidence. The check
is MECHANICAL, not a judgment call — before any absence claim about a module
or system, run BOTH:
1. `head -3 <root file>` and follow EVERY inheritance/`extends` hop to its
   source, grepping each for the component (inheritance delivers whole
   init pipelines — a subclass "without" a component often inherits it two
   hops up);
2. grep the project's singleton/module registry and the entry-point wiring.
Two separate agents (one WITH this rule as prose) headlined the same false
absence because they grepped the leaf file and stopped — the concrete class
inherited the "missing" component two inheritance hops up. Prose didn't
prevent it; running the commands does.
**PASTE THE EVIDENCE**: the brief itself must contain the inheritance chain
and the per-ancestor grep results for every absence claim. An absence claim
without pasted command output is INVALID — a third agent cited this rule by
name while violating it; naming a check is not running it.

## P5.7. The implication tax on your CHOSEN option
After picking your recommendation, run Gate 3.5 against the consumer list:
"what does my choice IMPLY for each consumer — especially consumers that
treat my unit (record, edge, chunk, marker) as semantically special?" A
design that multiplies nodes must answer for every consumer that thinks node
= junction; a design that adds a field must answer for every serializer.
Name these implications in the brief; the fork you didn't examine is the
one the builder will fall into.

## P6. Design instincts that recur in the baselines
- **Small interfaces, quantized contracts**: when components must agree
  (chunk edges, sockets), make the CONTRACT low-dimensional, not the
  content ("quantize the interface, not the payload").
- **One source of truth**: one generator feeding every representation
  (multiple derived views from one tessellation) so consumers can never
  disagree.
- **Reuse the already-decoupled piece**: hunt for an existing component
  that is already independent of the hard problem (a renderer that's already
  independent of the streaming layer can serve a second view for free).
- **Sequence for standalone wins**: order the plan so early tasks ship value
  alone (build the smallest self-contained piece first), and NAME the
  risk-concentrate task so the builder knows where the danger lives.

## P7. The human-pipeline pass
A design isn't done until a human can author with it in the editor. Walk
the authoring workflow start-to-finish and find where it breaks (a missing
rebuild button, a headless-only step, a generator that overwrites hand
edits). Those gaps go in the task list as first-class items.

## P8. The deliverable shape (all of these, every brief)
1. **Headline recommendation** — one committed answer, first.
2. Current-state limitations, grounded and counted (file:line).
3. Options with trade-offs + ONE recommendation (never a menu without a pick).
4. Consumer-by-consumer implications table.
5. Ordered task list; each task carries its probe/test; risk task named.
6. Edge cases (aim for 10+; interrupted-midway, boundaries, stale bakes,
   id churn, human-edit-vs-generator collisions).
7. Decision log of every divergence from precedent, with the reason.
8. Anything found-but-out-of-scope: flag, don't fix (side discoveries like
   latent bugs go in a flagged list).
9. **The deferral check**: if your recommendation serves only part of the
   request and defers the rest, adjudicate the deferred half against your
   OWN limitations table — if your fallback for it appears in your own
   limitations list, the recommendation is incomplete, not conservative.
   (Observed: a brief whose answer to half the request was the exact
   node-flooding cost it had itself listed as limitation L4.)

## P9. Channel discipline still binds
The baselines produced their entire process in silence — reads, then the
brief. Deliberate in your thoughts file; the visible channel gets the
headline + the file path.
