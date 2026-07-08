# EXEMPLAR: a FLAT (solo) agent's visible stream — SYNTHETIC.
# THIS IS NOT A REAL TRANSCRIPT. It is a constructed exemplar in a neutral
# fictional project (a task-tracker web app) that defines the OUTPUT BAR:
# the shape, length-class, and formatting a solo agent's visible channel
# should hit. Content is illustrative; match the FORM, not the facts.
# For agents doing the work THEMSELVES. Directors: use exemplar_director_stream.md instead.
# Roughly 150 tool calls produced the 27 visible messages below (~980 words total).
# Shape: verdict-of-last-phase + name-of-next-move, ~15 words, at phase
# boundaries only; one ~555-word headline report at the end. Match this.


    [6 tool call(s) fold away here]

--- VISIBLE MESSAGE #1 (16 words) ---
Now let me read the assignment path. First, how tasks get an assignee in the create-task flow.

    [15 tool call(s) fold away here]

--- VISIBLE MESSAGE #2 (21 words) ---
No auto-reassign-on-close rule exists yet in the app. Let me check the task-state machine and how TaskCard reacts to a status change.

    [5 tool call(s) fold away here]

--- VISIBLE MESSAGE #3 (12 words) ---
Part 1 design is settled. Now gathering Part 2 (bulk-edit) facts.

    [4 tool call(s) fold away here]

--- VISIBLE MESSAGE #4 (30 words) ---
The validation schema matches the API contract verbatim. The slow save must come from what the last migration changed in the query. Let me diff the endpoint against its pre-migration state.

    [9 tool call(s) fold away here]

--- VISIBLE MESSAGE #5 (25 words) ---
Let me verify the pagination path once (to confirm the list query uses the index) and check which columns the other filters sort on.

    [6 tool call(s) fold away here]

--- VISIBLE MESSAGE #6 (14 words) ---
Part 2 is fully diagnosed. Now Part 3 — the notification fan-out on assignment.

    [8 tool call(s) fold away here]

--- VISIBLE MESSAGE #7 (20 words) ---
All the mechanisms are identified. Now the Part 4 research cites — watchers vs assignees in the events model.

    [25 tool call(s) fold away here]

--- VISIBLE MESSAGE #8 (14 words) ---
Now Part 2 — the row counts on the bulk query and the N+1 it fans into.

    [15 tool call(s) fold away here]

--- VISIBLE MESSAGE #9 (2 words) ---
Type check.

    [8 tool call(s) fold away here]

--- VISIBLE MESSAGE #10 (4 words) ---
Writing the test now.

    [11 tool call(s) fold away here]

--- VISIBLE MESSAGE #11 (14 words) ---
All six checks pass. Now verify the bulk-edit numbers with a quick timing script.

    [5 tool call(s) fold away here]

--- VISIBLE MESSAGE #12 (14 words) ---
Bulk edit hits the target latency exactly; other filters unchanged. Now the fan-out stats.

    [6 tool call(s) fold away here]

--- VISIBLE MESSAGE #13 (14 words) ---
I'll wait for the background load test to complete while I write the docs.

    [1 tool call(s) fold away here]

--- VISIBLE MESSAGE #14 (13 words) ---
Now the Part 4 write-up — the watchers-vs-assignees events question.

    [4 tool call(s) fold away here]

--- VISIBLE MESSAGE #15 (19 words) ---
The load test keeps getting auto-backgrounded (10k notifications is slow). Let me wait for it and check the log.

    [3 tool call(s) fold away here]

--- VISIBLE MESSAGE #16 (27 words) ---
Fan-out confirmed: closing a task notifies ~1 watcher per assignee change at 3ms each, ~40ms at the 14-watcher cap, ~8ms typical; the actor is never self-notified. Restoring the config and cleaning up.

    [1 tool call(s) fold away here]

--- VISIBLE MESSAGE #17 (21 words) ---
Now update the API docs to reflect uncapped reassignment + the fan-out note, and add the watcher-dedup note to the events page.

    [7 tool call(s) fold away here]

--- VISIBLE MESSAGE #18 (5 words) ---
Now regenerate the API reference.

    [1 tool call(s) fold away here]

--- VISIBLE MESSAGE #19 (17 words) ---
Docs done (115 endpoints, 16 pages). Now the smoke suite regression check plus a full app boot.

    [2 tool call(s) fold away here]

--- VISIBLE MESSAGE #20 (21 words) ---
Smoke suite passed all checks up to the clean run but 4000 events wasn't enough to drain the queue. Running longer.

    [1 tool call(s) fold away here]

--- VISIBLE MESSAGE #21 (9 words) ---
Smoke suite PASS checks=8. Now commit on the branch.

    [2 tool call(s) fold away here]

--- VISIBLE MESSAGE #22 (14 words) ---
Now the standing logs (devlog + handoff additive note), which live outside the repo.

    [2 tool call(s) fold away here]

--- VISIBLE MESSAGE #23 (22 words) ---
A parallel agent (`round/notify-refactor`) already logged the same topics. I'll add my own branch's additive devlog + handoff note without touching theirs.

    [5 tool call(s) fold away here]

--- VISIBLE MESSAGE #24 (5 words) ---
Now the additive handoff note.

    [4 tool call(s) fold away here]

--- VISIBLE MESSAGE #25 (15 words) ---
Let me verify the commit message and tree contain no leftover debug logging or stray fixtures.

    [1 tool call(s) fold away here]

--- VISIBLE MESSAGE #26 (30 words) ---
Clean — the only `console.log` left is the intentional structured audit line in the notifier; commit message and all hand-written code and docs are clean.

Verifying the tree is committed and on the right branch.

    [1 tool call(s) fold away here]

--- VISIBLE MESSAGE #27 (~555 words) ---
Working tree clean, on `round/reassign-close`, committed `9c2b02a` (not pushed). All four asks done.

## Headline summary

**1. Closed tasks always reassign to the fallback owner (regression fixed).** The `round/queue` refactor had folded reassignment *conversions* into the per-project *seat* budget, so a task closed on a full project was silently left unassigned once the roster hit the (small) seat cap. The intended rule (documented in `assignment.md`) hands *any* closing task to the fallback owner whenever the project is active — the budget caps only how many *fresh* seats the project spawns. I made `_adopt_reassignments` uncapped and let the existing oldest-first `_trim_to_cap` cap by **staleness**: an over-cap reassignment is admitted (`_survives_trim` — inside the recency window, so a just-closed task always lands, or newer than the oldest by the grace margin) and the stalest holder is shed; a released seat re-arms in place. Roster stays hard at the seat cap; all queue invariants preserved. Test `_reassign_probe` 6/6 PASS.

**2. Bulk edit slow — root cause found.** The validation schema already matches the API contract verbatim; the culprit was the last migration. The endpoint **hard-coded** a per-row lookup, ignoring the batch-fetch the ORM offers — an N+1 that scaled with selection size. Added `TaskRepo.fetch_many` (one `WHERE id IN (…)` round-trip, *not* per-row) feeding the update loop. Bulk edit of 200 rows: 1490ms→310ms (was **~5×** slower = felt frozen); single-row edits unchanged (they never hit the new path). Other filters default to the old single-fetch path — latencies unchanged.

**3. Assignment notifications spamming — dedup rule added.** The fan-out path notified every watcher on every field write (a rename fired a full re-notify). Added a change-set diff so only *assignment* changes fan out, deduped per recipient, actor excluded. New `NotifyPrefs.dedup_window` (default 2s). Load test: 87% of redundant notifications suppressed at 3 watchers, down to 8ms typical fan-out.

**4. Research (no code).** `Watchers_Vs_Assignees_events.md` in the docs tree: a task and its watchers are separate records linked by ids (`watcher_ids` ↔ `watched_task_id`); a watcher is dormant for notification routing until an assignment event, and `event_kind` arbitrates which recipients receive it. The app mirrors the two-record shape but keeps watchers as `WatcherRef` *data* until the first notify. Full file:line comparison table included.

**Evidence:** `_reassign_probe` 6/6 PASS; bulk-edit latency hit the target; fan-out load test matches the curve; smoke suite STOP PASS checks=8; type check 0 errors; docs regenerated (115 endpoints, 16 pages — assignment/events/bulk pages updated). Must-not-regress items all held.

**Flagged, not fixed:** A **parallel agent already worked all four topics** on `round/notify-refactor` (devlog `..aj..`). My reassignment design converged with theirs (uncapped + staleness, no new fields); my bulk fix found the actual N+1 root cause the other only diagnosed and left; my dedup uses a change-set diff (they used a per-field flag). **Expect merge conflicts** in `assignment_service.ts`, `task_card.tsx`, `notify_prefs.ts`, `notifier.ts`, `fixtures/watchers.json` — per-topic merge notes are in devlog `2026-…ak`.

**Gotcha for the next agent:** the `fixtures/` seed data is gitignored, so a fresh clone lacks it and the tests crash on an empty watcher table — copy the seed dir from the main repo in (I did, not committed). Standalone scripts get no DI container (`Notifier` needs `EventBus`).

Start the next session by loading the project's handoff/context skill to reload state from the package.
