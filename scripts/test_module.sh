#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${REPO_DIR}"
. "${REPO_DIR}/scripts/_flutter_env.sh"
ensure_flutter_on_path

MODULE="${1:-}"

if [ -z "$MODULE" ]; then
  echo "🧪 Barcha modul va paketlar test qilinmoqda..."
  TARGETS=$(all_test_targets)
  printf '   %s\n' $TARGETS
  # shellcheck disable=SC2086
  flutter test $TARGETS
  exit 0
fi

MOD_NAME=$(basename "$MODULE")
for ROOT in modules packages; do
  if [ -f "$ROOT/$MOD_NAME/test/${MOD_NAME}_test.dart" ]; then
    echo "🧪 Test yurgazilmoqda: $ROOT/$MOD_NAME/test/${MOD_NAME}_test.dart"
    (cd "$ROOT/$MOD_NAME" && flutter test "test/${MOD_NAME}_test.dart")
    exit 0
  elif [ -d "$ROOT/$MOD_NAME/test" ]; then
    echo "🧪 Test yurgazilmoqda: $ROOT/$MOD_NAME/test/"
    (cd "$ROOT/$MOD_NAME" && flutter test test/)
    exit 0
  fi
done

echo "❌ Test topilmadi: modules/$MOD_NAME/test yoki packages/$MOD_NAME/test" >&2
exit 1
