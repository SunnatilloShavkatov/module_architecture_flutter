#!/usr/bin/env bash
#
# analyze_changed.sh — dart analyze, scoped to the packages the change set touches.
#
#   scripts/analyze_changed.sh                  # working tree vs HEAD
#   scripts/analyze_changed.sh --staged         # staged files only
#   scripts/analyze_changed.sh --base origin/main
#
# Whole-repo `flutter analyze` walks all pubspecs and costs minutes. A typical
# change touches one or two modules; analyzing just those costs 5-25s.
#
# Exit 0 = clean (or nothing to analyze), 1 = analyzer findings, 2 = bad usage.

set -uo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${REPO_DIR}"

MODE="worktree"
BASE="HEAD"

while [ $# -gt 0 ]; do
  case "$1" in
    --staged) MODE="staged" ;;
    --base) BASE="${2:-HEAD}"; shift ;;
    -h|--help) sed -n '2,14p' "$0"; exit 0 ;;
    *) echo "analyze_changed: unknown option $1" >&2; exit 2 ;;
  esac
  shift
done

case "${MODE}" in
  staged) files=$(git diff --cached --name-only --diff-filter=ACMR -- '*.dart') ;;
  *)      files=$(git diff --name-only --diff-filter=ACMR "${BASE}" -- '*.dart') ;;
esac

files=$(printf '%s\n' "${files}" | grep -v -e '^$' -e '\.g\.dart$' -e '\.freezed\.dart$')

if [ -z "${files}" ]; then
  echo "analyze_changed: no dart changes"
  exit 0
fi

# Walk up from each file until a pubspec.yaml is found — that directory is the
# package the analyzer needs to be pointed at.
roots=$(
  printf '%s\n' "${files}" | while IFS= read -r f; do
    d=$(dirname "$f")
    while [ "$d" != "." ] && [ "$d" != "/" ] && [ ! -f "$d/pubspec.yaml" ]; do
      d=$(dirname "$d")
    done
    echo "$d"
  done | sort -u
)

ready=""
skipped=""
for r in ${roots}; do
  if [ -f "$r/.dart_tool/package_config.json" ]; then
    ready="${ready} $r"
  else
    skipped="${skipped} $r"
  fi
done

[ -n "${skipped}" ] && echo "analyze_changed: skipped (no pub get yet):${skipped}"

if [ -z "${ready}" ]; then
  echo "analyze_changed: nothing analyzable — run 'flutter pub get' in the package first"
  exit 0
fi

command -v dart >/dev/null 2>&1 || { echo "analyze_changed: dart not on PATH" >&2; exit 2; }

echo "analyze_changed: scope ->${ready}"
# shellcheck disable=SC2086
dart analyze ${ready}
