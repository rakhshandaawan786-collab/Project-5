# Codify the Body: One Command, Not a Loop

Turns Project 4's fix-loop into a single re-runnable unit (`run_fix_loop.sh`),
then proves that unit is an **engine**, not a **loop**.

## The one command

```bash
bash run_fix_loop.sh
```

This does the entire body with zero step-by-step prompting:
1. **Fan-out** — drafts a fix for 3 candidates in parallel, each in its
   own isolated git worktree (`implement_fix.sh &` × 3, then `wait`)
2. **Fan-in** — reviews each candidate with a real checker (tests pass +
   test file untouched + implementation file actually changed)
3. **Gate** — opens a PR only for candidates that got `PASS`

## Repository contents

| File | Purpose |
|---|---|
| `issue1_slugify.py`, `issue2_dedupe.py`, `issue3_palindrome.py` | 3 real bugs, each with a failing test file |
| `implement_fix.sh` | Drafts one candidate's fix in its own worktree/branch |
| `reviewer.sh` | The checker — PASS/FAIL by exit code, with reasons |
| `open_pr.sh` | Called only on PASS |
| `run_fix_loop.sh` | **The one command** — fans out, fans in, gates on verdict |

## A real gotcha hit along the way

Running `git worktree add` / `git branch -D` from several background
jobs at once is not safe — git's own metadata isn't built for concurrent
mutation. First attempt at Run 2 produced:
```
fatal: a branch named 'fix/issue1_slugify' already exists
```
Fixed by serializing just the git-setup bookkeeping with `flock`, while
the actual fix-drafting per candidate stays logically independent. Worth
knowing if you build this pattern for real: **parallelize the work,
serialize the shared state.**

## Proof #1 — it's one command, not step-by-step

```
=== FAN-OUT: drafting fixes in parallel worktrees ===
[issue1_slugify] fix drafted on fix/issue1_slugify
[issue2_dedupe] fix drafted on fix/issue2_dedupe
[issue3_palindrome] fix drafted on fix/issue3_palindrome

=== FAN-IN: reviewing each candidate ===
[issue1_slugify] PASS
[issue2_dedupe] PASS
[issue3_palindrome] PASS

=== RESULT ===
[issue1_slugify] PR opened: PR_issue1_slugify.md
[issue2_dedupe] PR opened: PR_issue2_dedupe.md
[issue3_palindrome] PR opened: PR_issue3_palindrome.md
```
3 candidates, 3 isolated checkouts, 3 verdicts, from one invocation.

## Proof #2 — it remembers nothing (it's an engine, not a loop)

Ran again in a genuinely fresh shell (`env -i`, stripping all inherited
variables) right after Run 1. Result: **identical** — same 3 PASS
verdicts, same 3 PRs regenerated. The only trace of Run 1 was git
itself reporting it deleted the old branch to make room for the new
one — the *script* never referenced "last time," because nothing in
it does. There is no state/progress file anywhere in this repo:

```bash
find . -maxdepth 1 -type f | grep -vE "\.py$|\.sh$|\.md$"
# (empty)
```

Compare this to Project 3's morning brief, which had `.brief_state.json`
specifically so run #2 could build on run #1. This project has nothing
like that on purpose — that absence is the proof.

## What it would take to become a loop

Two things, named plainly:

1. **A heartbeat** — something that fires `run_fix_loop.sh` on its own
   schedule (cron, a scheduler, a long-running watcher), instead of a
   human typing the command each time.
2. **A progress file its agents write** — something like
   `.workflow_state.json`, updated at the end of each run, that the
   *next* run reads first: which candidates already passed and shouldn't
   be redone, which ones failed last time and why, so retries build on
   history instead of starting cold every time.

Without both, this is a very capable **engine** — powerful, parallel,
correctly gated — but it has no memory between invocations. That's the
actual difference between an engine and a loop.
