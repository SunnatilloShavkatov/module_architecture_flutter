#!/usr/bin/env bash
# _flutter_env.sh — shared helpers. Source it, do not execute it.
#
#   REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
#   . "${REPO_DIR}/scripts/_flutter_env.sh"

# Keep git and tool config out of the way so the scripts behave the same on CI.
export GIT_CONFIG_GLOBAL="${GIT_CONFIG_GLOBAL:-/dev/null}"
export GIT_CONFIG_SYSTEM="${GIT_CONFIG_SYSTEM:-/dev/null}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-/tmp}"

# Put the Flutter SDK on PATH if it is not there already.
# Set FLUTTER_ROOT to point at a custom install; no developer machine is hard-coded here.
ensure_flutter_on_path() {
  command -v flutter >/dev/null 2>&1 && return 0

  local candidates=(
    "${FLUTTER_ROOT:-}/bin"
    "$PWD/.fvm/flutter_sdk/bin"
    "$HOME/fvm/default/bin"
    "$HOME/development/flutter/bin"
    "$HOME/src/flutter/bin"
    "$HOME/flutter/bin"
    "/opt/homebrew/Caskroom/flutter/latest/flutter/bin"
    "/usr/local/flutter/bin"
  )

  local p
  for p in "${candidates[@]}"; do
    if [ -n "$p" ] && [ -x "$p/flutter" ]; then
      export PATH="$p:$PATH"
      return 0
    fi
  done

  echo "❌ Flutter SDK topilmadi. PATH ga qo'shing yoki FLUTTER_ROOT ni belgilang." >&2
  return 1
}

# Every module that has an aggregator test: "modules/<m>/test/<m>_test.dart".
# Falls back to the whole test/ folder when a module has tests but no aggregator.
all_test_targets() {
  local dir name
  [ -d test ] && echo "test/"
  for dir in modules/*/ packages/*/; do
    name=$(basename "$dir")
    if [ -f "${dir}test/${name}_test.dart" ]; then
      echo "${dir}test/${name}_test.dart"
    elif [ -d "${dir}test" ] && [ -n "$(find "${dir}test" -name '*_test.dart' -print -quit)" ]; then
      echo "${dir}test/"
    fi
  done
}
