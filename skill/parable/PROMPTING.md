# How to prompt a new Opus agent on your project

Throughout, `{{PROJECT_SKILL}}` is the name of your project-context skill (if
you have one — optional), and `{{PROJECT_ROOT}}` is the repo the agents work
in. See the README for the full placeholder table.

## The COORDINATOR prompt (programs: pipelines, experiments, "iterate until")

    continue {{your project}} using the parable skill in
    COORDINATOR mode (coordinator.md)[ and the {{PROJECT_SKILL}} skill]

    <the program in your own words — e.g. "run the next three build rounds
    from the pipeline", "iterate X until it matches Y", "evaluate these
    approaches against each other">

The coordinator runs the machine notification-driven: turns armed with
watches before every yield, hand verification of decisive claims, sequential
build rounds on the one project copy, comparator-graded experiments, and the
ratchet. If your `{{PROJECT_SKILL}}` has a role router, it can self-select
this mode when the request is clearly a program.

## Mode-forcing one-liners (append to any prompt)
- Token-efficient simple change: **"solo mode — no subagents."**
- Hard unknown / failed prior fix: **"use the ensemble."**
Otherwise the director triages the mode itself (director.md §2b).

## Model choice per seat (token budget)
Directors type each plan part and pick the model per §2b. Default split:
- **Opus (judgment seats):** the director/coordinator itself, no-trail
  diagnosis, ensemble members + adjudicator, design/planning briefs, the
  review-gate second-agent reviewer.
- **Sonnet (mechanical seats):** implementation workers executing a COMPLETE
  brief (files, numbers, must-not-regress clauses all spelled out), doc
  regeneration/site work, probe running + evidence collection, transcript
  extraction, Explore-style searches, Monitor/watch agents.
The rule of thumb: if the brief is good enough that being wrong requires
disobedience rather than misjudgment, it's a Sonnet seat. The review gate
stays Opus so a Sonnet worker's output is always judged by a stronger model.
Force it in a prompt with: **"workers on Sonnet where the brief is
complete."**

## The LAZY prompt (default — just talk, director mode)

    continue {{your project}} using the parable skill in
    DIRECTOR mode (director.md)[ and the {{PROJECT_SKILL}} skill]

    <the request in the user's own words>

That's it. The agent becomes a DIRECTOR (see director.md): it translates the
request into a precise worker brief, branches IN PLACE in {{PROJECT_ROOT}}
(one project copy — no worktrees/clones unless you ask for one), writes and
announces a plan, spawns worker agents that deliberate in thoughts files in
{{NOTES_DIR}}, reports short folding summaries per plan part as they land
(Monitor beat), runs the review-gate checklist incl. the second-agent
edge-case review, and ends with a headline report + absolute links to all
thoughts files. Your raw words are safe to include because translation is
the director's first duty — workers echo the brief's wording verbatim into
commits and docs, which is exactly why the director rewrites it first.

## The EXPLICIT worker template (what a director sends its worker)

    Load the {{PROJECT_SKILL}} skill (if any), then the parable skill
    (follow its <feature|debugging|research>.md addendum + method.md). Work in
    {{PROJECT_ROOT}} on branch <name> (already created); do not push.
    <the thoughts-file contract block from director.md §4, verbatim>
    TASK: <the translated brief + the plan>. Must not regress: <clauses>.
    Commit on your branch (trailer: your team's Co-Authored-By convention)
    and report per the skill.

Git worktrees/clones are NOT used unless you specifically request isolation
(separate copies can cause a split-brain where the build you run lacks the
new feature). If you DO request one: copy any gitignored generated
data/assets from the main repo into it, and budget one build/import pass.

STYLE ENFORCEMENT NOTE: the top-level output style lives in the skill itself
— §1's format contract + think-below-the-fold notes-file rule + the
frontmatter description, which the agent sees even before loading. If an
agent still streams deliberation at top level, that is a skill bug: fix §1,
don't grow the prompt.

## The FULL inline template (when pasting instead of loading — e.g. for
## agents without skill access, or A/B experiments where you control exactly
## what they see)

1. <working-style skill> block: the body of SKILL.md (core), then ONE
   addendum, then </working-style skill>.
2. Sandbox line (branch/worktree, work only there, no push) or read-only
   contract + scratch dir.
3. Project context: your language's strict-typing/lint settings and any
   non-negotiable house rules, verbatim.
4. The task, quoting the user's words where tone matters; "must not
   regress" clauses explicit.
5. Environment facts ({{BUILD_CHECK}} / {{RUNTIME_CHECK}} commands, any
   import/build step, known ignorable startup warnings, the fixture/data
   pattern, where the local docs live, where known-good generated data lives).
6. Deliverables (commit trailer + report shape).

Notes:
- The Agent tool has NO thinking-level knob; model choice is the only lever.
- Don't restrict subagent spawning beyond your own project's rules.
- Don't name the house rules in feature prompts if you want rule-discovery
  tested; DO name them (via the skills) when you just want the work done —
  the agents load the project skills either way.
- Worktrees inherit tracked files only: generated data and build caches are
  absent — budget the one-time build/import.
- ENVIRONMENT REALISM DETERMINES WHAT'S FINDABLE: always tell the agent
  where a known-good instance of generated/untracked data lives (e.g. "copy
  the generated data dir from {{PROJECT_ROOT}} if the task needs it").
  Learned the hard way: two isolated clones with no pointer to the main repo
  meant the reported bug physically could not reproduce, and two disciplined
  agents each confidently root-caused a DIFFERENT (secondary) issue instead.
