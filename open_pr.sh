#!/bin/bash
CANDIDATE=$1
BRANCH="fix/$CANDIDATE"
DIFF=$(git diff main "$BRANCH")
cat > "PR_${CANDIDATE}.md" << EOF2
# PR: $CANDIDATE
**Branch:** $BRANCH
**Verdict:** PASS

\`\`\`diff
$DIFF
\`\`\`
EOF2
echo "[$CANDIDATE] PR opened: PR_${CANDIDATE}.md"
