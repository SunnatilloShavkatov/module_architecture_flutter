#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${REPO_DIR}"
. "${REPO_DIR}/scripts/_flutter_env.sh"

# 1. Faqat o'zgargan yoki yangi .dart fayllarni ajratib olish
CHANGED_FILES=$(git diff --name-only --diff-filter=d HEAD 2>/dev/null | grep '\.dart$' || true)
UNTRACKED_FILES=$(git ls-files --others --exclude-standard 2>/dev/null | grep '\.dart$' || true)
RAW_FILES="$CHANGED_FILES $UNTRACKED_FILES"
FILES=$(echo "$RAW_FILES" | xargs)

if [ -z "$FILES" ]; then
  echo "⚡ O'zgargan .dart fayllar topilmadi (0 soniya)."
  exit 0
fi

COUNT=$(echo "$FILES" | tr ' ' '\n' | wc -l | tr -d ' ')
echo "🚀 $COUNT ta o'zgargan fayl tekshirilmoqda..."

# 2. Tezkor formatlash (< 1 soniya)
dart format $FILES >/dev/null 2>&1 || dart format $FILES

# 3. Tezkor analiz (dart analyze - flutter analyze dan 5x tezroq, ~3-4s)
dart analyze $FILES

echo "✅ Formatlash va analiz toza!"
