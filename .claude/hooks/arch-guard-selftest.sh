#!/usr/bin/env bash
# arch-guard-selftest.sh — RULES bloki .claude/rules/flutter-architecture.md §2 jadvali bilan
# belgi-ba-belgi mos ekanini tekshiradi. Mos bo'lmasa exit 1.

set -uo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
GUARD="$ROOT/.claude/hooks/arch-guard.sh"
DOC="$ROOT/.claude/rules/flutter-architecture.md"

# RULES bloki: RULES=( ... ) orasidagi "a|b|c" qatorlari
from_guard=$(awk '/^RULES=\(/{f=1;next} f&&/^\)/{f=0} f' "$GUARD" \
  | sed -e 's/^[[:space:]]*"//' -e 's/"[[:space:]]*$//' -e '/^[[:space:]]*#/d' -e '/^$/d')

# §2 jadvali: 4 ustunli, birinchi ustuni `/lib/src/...` bilan boshlanadigan qatorlar
from_doc=$(grep -E '^\| `(@|/)' "$DOC" \
  | awk -F'|' '{print $2"|"$3"|"$4}' \
  | sed -e 's/`//g' -e 's/[[:space:]]//g')

if [ "$from_guard" = "$from_doc" ]; then
  printf 'OK — RULES (%s qator) va §2 jadvali belgi-ba-belgi mos\n' "$(wc -l <<<"$from_guard" | tr -d ' ')"
  exit 0
fi

printf 'FARQ TOPILDI\n\n--- arch-guard.sh RULES ---\n%s\n\n--- flutter-architecture.md §2 ---\n%s\n\n--- diff ---\n' \
  "$from_guard" "$from_doc" >&2
diff <(printf '%s\n' "$from_guard") <(printf '%s\n' "$from_doc") >&2
exit 1
