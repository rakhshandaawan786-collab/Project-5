#!/bin/bash
# Drafts a fix for one candidate, in its own isolated worktree/branch.
# Represents "the runtime writing and running the fix" step — here the
# actual patch content is hardcoded per candidate to simulate what an
# implementer agent would draft. Swap this for a real agent call in
# Claude Code / OpenCode.
#
# NOTE: git's own metadata (branch refs, worktree registration) isn't
# safe to mutate from multiple parallel processes at once — running
# `git worktree add` concurrently from several background jobs causes
# lock/race failures. So the git-setup step is serialized with flock;
# only that bookkeeping is serial, the actual fix-drafting work per
# candidate is still independent and could run concurrently.
set -e
CANDIDATE=$1
BRANCH="fix/$CANDIDATE"
WORKTREE="../wt_$CANDIDATE"
LOCK=".git/worktree-setup.lock"

(
  flock -x 200
  rm -rf "$WORKTREE"
  git worktree prune
  git branch -D "$BRANCH" 2>/dev/null || true
  git worktree add -q "$WORKTREE" -b "$BRANCH" main
) 200>"$LOCK"

case "$CANDIDATE" in
  issue1_slugify)
    cat > "$WORKTREE/issue1_slugify.py" << 'PYEOF'
import re

def slugify(text):
    text = text.lower().strip()
    text = re.sub(r"[^a-z0-9]+", "-", text)
    return text.strip("-")
PYEOF
    ;;
  issue2_dedupe)
    cat > "$WORKTREE/issue2_dedupe.py" << 'PYEOF'
def dedupe_preserve_order(items):
    seen = set()
    result = []
    for item in items:
        if item not in seen:
            seen.add(item)
            result.append(item)
    return result
PYEOF
    ;;
  issue3_palindrome)
    cat > "$WORKTREE/issue3_palindrome.py" << 'PYEOF'
def is_palindrome(s):
    cleaned = "".join(ch.lower() for ch in s if ch.isalnum())
    return cleaned == cleaned[::-1]
PYEOF
    ;;
esac

(cd "$WORKTREE" && git add -A && git commit -q -m "Fix $CANDIDATE")
echo "[$CANDIDATE] fix drafted on $BRANCH"
