#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
python3 "${REPO_DIR}/scripts/create_module.py" "$@"

MODULE_NAME="${1:-}"
if [ -n "$MODULE_NAME" ] && [ -d "${REPO_DIR}/modules/$MODULE_NAME" ]; then
  . "${REPO_DIR}/scripts/_flutter_env.sh"
  ensure_flutter_on_path
  echo "📦 Paketlar o'rnatilmoqda (flutter pub get)..."
  (cd "${REPO_DIR}/modules/$MODULE_NAME" && flutter pub get >/dev/null 2>&1)
  # Shablon o'qilishi uchun keng yozilgan — loyihaning line-length'iga keltiramiz.
  dart format "${REPO_DIR}/modules/$MODULE_NAME" >/dev/null 2>&1 || true
  echo "🎉 Modul to'liq tayyor!"
fi
