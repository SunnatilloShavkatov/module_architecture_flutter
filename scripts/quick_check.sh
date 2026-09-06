#!/usr/bin/env bash
set -e

# Git configuration fallback to avoid sandbox permission errors
export GIT_CONFIG_GLOBAL="${GIT_CONFIG_GLOBAL:-/dev/null}"
export GIT_CONFIG_SYSTEM="${GIT_CONFIG_SYSTEM:-/dev/null}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-/tmp}"

# 1. Git bo'yicha faqat o'zgargan yoki yangilangan .dart fayllarni ajratib olish
CHANGED_FILES=$(git diff --name-only --diff-filter=d HEAD 2>/dev/null | grep '\.dart$' || true)
UNTRACKED_FILES=$(git ls-files --others --exclude-standard 2>/dev/null | grep '\.dart$' || true)
RAW_FILES="$CHANGED_FILES $UNTRACKED_FILES"

# Bo'sh joylar va yangi qatorlarni tozalab, bitta qatorga olish
FILES=$(echo "$RAW_FILES" | xargs)

if [ -z "$FILES" ]; then
  echo "⚡ O'zgargan .dart fayllar topilmadi."
  exit 0
fi

echo "🚀 O'zgargan fayllar tekshirilmoqda:"
echo "$FILES" | tr ' ' '\n' | sed 's/^/  - /'

# 2. Maxsus dizayn widgetlarini avtomatik migratsiya qilish
dart fix --apply --code=migrate_design_widgets $FILES 2>/dev/null || true

# 3. Faqat o'zgargan fayllarni formatlash (juda tez)
dart format $FILES

# 4. Faqat o'zgargan fayllarni analiz qilish
flutter analyze $FILES

echo "✅ Hammasi toza va standartga mos!"
