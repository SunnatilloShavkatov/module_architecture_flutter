#!/usr/bin/env bash
# arch-guard-selftest.sh — checks the RULES block matches the §2 table in
# .claude/rules/flutter-architecture.md character-for-character. Exit 1 on mismatch.

set -uo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
GUARD="$ROOT/.claude/hooks/arch-guard.sh"
DOC="$ROOT/.claude/rules/flutter-architecture.md"

# RULES block: the "a|b|c" lines between RULES=( ... )
from_guard=$(awk '/^RULES=\(/{f=1;next} f&&/^\)/{f=0} f' "$GUARD" \
  | sed -e 's/^[[:space:]]*"//' -e 's/"[[:space:]]*$//' -e '/^[[:space:]]*#/d' -e '/^$/d')

# §2 table: 4-column rows whose first column starts with `/lib/src/...`
from_doc=$(grep -E '^\| `(@|/)' "$DOC" \
  | awk -F'|' '{print $2"|"$3"|"$4}' \
  | sed -e 's/`//g' -e 's/[[:space:]]//g')

if [ "$from_guard" = "$from_doc" ]; then
  printf 'OK — RULES (%s lines) matches the §2 table character-for-character\n' "$(wc -l <<<"$from_guard" | tr -d ' ')"
  exit 0
fi

printf 'MISMATCH FOUND\n\n--- arch-guard.sh RULES ---\n%s\n\n--- flutter-architecture.md §2 ---\n%s\n\n--- diff ---\n' \
  "$from_guard" "$from_doc" >&2
diff <(printf '%s\n' "$from_guard") <(printf '%s\n' "$from_doc") >&2
exit 1
