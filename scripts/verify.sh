#!/usr/bin/env bash
set -e

# ==============================================================================
# verify.sh — Tezkor verifikatsiya (< 10-15 sekund)
#
# QOIDALAR:
# 1. Hech qachon APK yoki iOS build QILINMAYDI (u 3-5 daqiqa oladi, build foydalanuvchiga tegishli).
# 2. Odatiy holda (default): Faqat o'zgargan fayllar va o'zgargan modul testini yurgazadi.
# 3. Katta o'zgarish bo'lganda yoki foydalanuvchi so'raganda: ./scripts/verify.sh --all
# ==============================================================================

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${REPO_DIR}"
. "${REPO_DIR}/scripts/_flutter_env.sh"
ensure_flutter_on_path

MODE="${1:-}"

# --- 1. TEZKOR REJIM (Default - Faqat o'zgargan fayllar, < 10 sekund) ---
if [ "$MODE" != "--all" ]; then
  echo "⚡ Tezkor tekshiruv (Faqat o'zgargan qismlar)..."

  # 1. Arch guard (o'zgargan fayllar, < 0.1s)
  ./scripts/arch_guard_scan.sh --changed --quiet || ./scripts/arch_guard_scan.sh --changed

  # 2. Format & Dart Analyze (o'zgargan fayllar, ~3s)
  ./scripts/quick_check.sh

  # 3. O'zgargan modul va paket testlari (~3-4s)
  CHANGED_PKGS=$(git diff --name-only HEAD 2>/dev/null | grep -E '^(modules|packages)/' | cut -d'/' -f1-2 | sort -u || true)
  UNTRACKED_PKGS=$(git ls-files --others --exclude-standard 2>/dev/null | grep -E '^(modules|packages)/' | cut -d'/' -f1-2 | sort -u || true)
  for dir in $(printf '%s\n%s\n' "$CHANGED_PKGS" "$UNTRACKED_PKGS" | sort -u); do
    [ -n "$dir" ] || continue
    name=$(basename "$dir")
    if [ -f "$dir/test/${name}_test.dart" ]; then
      echo "🧪 Test: $dir/test/${name}_test.dart"
      flutter test "$dir/test/${name}_test.dart"
    elif [ -d "$dir/test" ] && [ -n "$(find "$dir/test" -name '*_test.dart' -print -quit)" ]; then
      echo "🧪 Test: $dir/test/"
      flutter test "$dir/test/"
    fi
  done

  echo "🎉 Barcha o'zgarishlar toza va tayyor (<10s)!"
  exit 0
fi

# --- 2. TO'LIQ CHUQUR TEKSHIRUV (--all, Katta o'zgarishlarda) ---
echo "🔍 To'liq chuqur tekshiruv boshlandi (--all)..."

# 1. Arch guard — butun loyiha
./scripts/arch_guard_scan.sh

# 2. RULES bloki qoida hujjati bilan mosligi
./.claude/hooks/arch-guard-selftest.sh

# 3. Format + analiz — butun loyiha
dart format ./ >/dev/null 2>&1 || dart format ./
dart analyze

# 4. Barcha modul va paket testlari (dinamik ro'yxat — yangi modul o'zi qo'shiladi)
TARGETS=$(all_test_targets)
echo "🧪 Test maqsadlari:"
printf '   %s\n' $TARGETS
# shellcheck disable=SC2086
flutter test $TARGETS

echo "🎉 Butun loyiha to'liq tekshiruvdan o'tdi!"
