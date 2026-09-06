#!/bin/bash
# =============================================================
# THE ONE RE-RUNNABLE UNIT.
# "Draft fixes for these candidates in parallel worktrees, and
# have a reviewer grade each one." One command. No step-by-step
# prompting. Everything below is mechanical — nothing here
# remembers a previous run of this script.
# =============================================================

CANDIDATES=("issue1_slugify" "issue2_dedupe" "issue3_palindrome")
mkdir -p logs

echo "=== FAN-OUT: drafting fixes in parallel worktrees ==="
for c in "${CANDIDATES[@]}"; do
  bash implement_fix.sh "$c" > "logs/${c}_implement.log" 2>&1 &
done
wait
cat logs/*_implement.log

echo ""
echo "=== FAN-IN: reviewing each candidate ==="
declare -A VERDICT
for c in "${CANDIDATES[@]}"; do
  bash reviewer.sh "$c" > "logs/${c}_review.log" 2>&1
  VERDICT[$c]=$?
  cat "logs/${c}_review.log"
done

echo ""
echo "=== RESULT ==="
for c in "${CANDIDATES[@]}"; do
  if [ "${VERDICT[$c]}" -eq 0 ]; then
    bash open_pr.sh "$c"
  else
    echo "[$c] no PR opened"
  fi
done
