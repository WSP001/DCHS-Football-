#!/usr/bin/env bash
set -euo pipefail
msg="${1:-"chore(docs): add Copilot+Claude integration + guardrails"}"
git add docs/COPILOT-CLAUDE-INTEGRATION.md \
        .github/PULL_REQUEST_TEMPLATE.md \
        .github/ISSUE_TEMPLATE/task.md \
        .github/workflows/canary.yml \
        .github/workflows/guardrails.yml \
        scripts/canary/rsvp_canary.sh \
        scripts/commit/commit-plan.sh || true
git commit -m "$msg"
echo "Committed: $msg"
