#!/usr/bin/env bash
# stop-check.sh — end-of-turn check. Formats and re-guards ONLY the files that
# changed, and never runs analyze or tests (AGENTS.md §7).
#
# Stop hook. Exit 0 = turn ends. Exit 2 = model is asked to keep going, with
# stderr as the instruction.
#
# Budget: ~2s. Anything slower belongs in pre-commit.

set -uo pipefail

payload=$(cat)

# A Stop hook that already fired once must not fire again — that is an infinite
# turn. The flag is set by the runtime on the second pass.
printf '%s' "$payload" | grep -q '"stop_hook_active"[[:space:]]*:[[:space:]]*true' && exit 0

files=$(
  {
    git diff --name-only --diff-filter=ACMR -- '*.dart'
    git diff --cached --name-only --diff-filter=ACMR -- '*.dart'
  } 2>/dev/null | sort -u | grep -v -e '\.g\.dart$' -e '\.freezed\.dart$'
)

[ -z "$files" ] && exit 0

# --- format changed files (skipped silently when dart is not on PATH) --------
if command -v dart >/dev/null 2>&1; then
  printf '%s\n' "$files" | while IFS= read -r f; do
    [ -f "$f" ] && dart format --line-length 120 "$f" >/dev/null 2>&1
  done
fi

# --- re-run the architecture guard over the same set -------------------------
if ! bash scripts/arch_guard_scan.sh --changed --quiet 2>/dev/null; then
  echo "stop-check: arch-guard violations remain." >&2
  bash scripts/arch_guard_scan.sh --changed 2>&1 | head -20 >&2
  echo "Fix these, then finish. Do not run flutter analyze." >&2
  exit 2
fi

exit 0
