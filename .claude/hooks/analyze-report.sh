#!/usr/bin/env bash
# analyze-report.sh — tells the model if the background analyzer found errors.
# UserPromptSubmit hook.

set -uo pipefail

REPORT=".claude/.analyze_report"
if [ -f "$REPORT" ]; then
  cat "$REPORT" >&2
  rm -f "$REPORT"
fi
exit 0
