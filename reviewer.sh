#!/bin/bash
# Generic checker: exit 0 = PASS, exit 1 = FAIL.
# Same tightened rules as Project 4: tests must pass, the test file must
# not have been touched, and the real implementation file must have changed.
CANDIDATE=$1
BRANCH="fix/$CANDIDATE"
WORKTREE="../wt_$CANDIDATE"
IMPL="${CANDIDATE}.py"
TEST="test_${CANDIDATE}.py"

REASONS=()

TEST_RESULT=$(cd "$WORKTREE" && python3 -m unittest "$TEST" 2>&1)
TESTS_PASS=$?
[ $TESTS_PASS -ne 0 ] && REASONS+=("tests do not pass")

TEST_DIFF=$(git diff main "$BRANCH" -- "$TEST")
[ -n "$TEST_DIFF" ] && REASONS+=("$TEST was modified (spec must not change)")

IMPL_DIFF=$(git diff main "$BRANCH" -- "$IMPL")
[ -z "$IMPL_DIFF" ] && REASONS+=("$IMPL was never modified")

if [ ${#REASONS[@]} -eq 0 ]; then
  echo "[$CANDIDATE] PASS"
  exit 0
else
  echo "[$CANDIDATE] FAIL: ${REASONS[*]}"
  exit 1
fi
