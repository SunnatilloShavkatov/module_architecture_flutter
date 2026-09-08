#!/usr/bin/env bash

# Runs .claude/hooks/arch-guard.sh over every file it covers, instead of one
# file at a time the way the PostToolUse hook does.
#
#   scripts/arch_guard_scan.sh                   # whole repo
#   scripts/arch_guard_scan.sh --staged          # only files staged for commit
#   scripts/arch_guard_scan.sh --changed         # only files changed vs HEAD
#   scripts/arch_guard_scan.sh modules/battle    # only these paths
#   scripts/arch_guard_scan.sh --md              # rewrite .claude/rules/arch-migration.md
#   scripts/arch_guard_scan.sh --quiet           # exit code only, no per-file output
#
# Scope is the guard's own: modules/*/lib/**/*.dart, tests excluded. Anything
# else passed on the command line is skipped by the guard itself.
#
# Exit 0 = clean, 1 = violations found, 2 = bad usage.

set -uo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${REPO_DIR}"

GUARD=".claude/hooks/arch-guard.sh"
MIGRATION_DOC=".claude/rules/arch-migration.md"

[ -x "${GUARD}" ] || { echo "arch_guard_scan: ${GUARD} not found or not executable" >&2; exit 2; }

MODE="all"
QUIET=0
WRITE_MD=0
PATHS=()

while [ $# -gt 0 ]; do
  case "$1" in
    --staged) MODE="staged" ;;
    --changed) MODE="changed" ;;
    --md) WRITE_MD=1 ;;
    --quiet|-q) QUIET=1 ;;
    -h|--help) awk 'NR > 1 { if ($0 !~ /^#/ && $0 != "") exit; sub(/^# ?/, ""); print }' "$0"; exit 0 ;;
    -*) echo "arch_guard_scan: unknown option $1" >&2; exit 2 ;;
    *) PATHS+=("$1") ;;
  esac
  shift
done

# --- collect the files to check ----------------------------------------------
collect() {
  case "${MODE}" in
    staged)  git diff --cached --name-only --diff-filter=ACMR -- '*.dart' ;;
    changed) git diff --name-only --diff-filter=ACMR HEAD -- '*.dart' ;;
    all)
      local roots=("${PATHS[@]:-modules}")
      find "${roots[@]}" -path '*/lib/*' -name '*.dart' -type f 2>/dev/null
      ;;
  esac | grep -v -e '/test/' -e '_test\.dart$' -e '/test_helpers/' | sort -u
}

# In --staged / --changed mode the path list narrows what git reported.
narrow() {
  if [ "${MODE}" = "all" ] || [ ${#PATHS[@]} -eq 0 ]; then
    cat
  else
    grep -F -e "$(printf '%s\n' "${PATHS[@]}")"
  fi
}

# One guard run per file. Printed as a single short line so parallel workers can
# share stdout without interleaving.
arch_guard_check_one() {
  local file="$1"
  [ -f "${file}" ] || return 0
  local message
  message=$(printf '{"tool_input":{"file_path":"%s/%s"}}' "${PWD}" "${file}" | bash "${ARCH_GUARD}" 2>&1) && return 0
  # Line 1 of the guard output is the path, line 2 the reason.
  printf '%s\t%s\n' "${file}" "$(printf '%s' "${message}" | sed -n '2p' | sed 's/^  //')"
}
export -f arch_guard_check_one
export ARCH_GUARD="${GUARD}"

TMP_REPORT=$(mktemp -t arch-guard-scan)
TMP_FILES=$(mktemp -t arch-guard-files)
trap 'rm -f "${TMP_REPORT}" "${TMP_FILES}"' EXIT

collect | narrow > "${TMP_FILES}"
JOBS=${ARCH_GUARD_JOBS:-$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 4)}
xargs -P "${JOBS}" -I{} bash -c 'arch_guard_check_one "$1"' _ {} < "${TMP_FILES}" > "${TMP_REPORT}"

total=$(grep -c . "${TMP_FILES}")
failed=$(grep -c . "${TMP_REPORT}")

# --- output -------------------------------------------------------------------
if [ "${QUIET}" -eq 0 ]; then
  if [ "${failed}" -gt 0 ]; then
    while IFS=$'\t' read -r file reason; do
      printf '%s\n  %s\n' "${file}" "${reason}" >&2
    done < "${TMP_REPORT}"
    echo >&2
    echo "Grouped:" >&2
    cut -f2 "${TMP_REPORT}" | sed -E 's/^[a-z_]+_state\.dart/<x>_state.dart/' | sort | uniq -c | sort -rn >&2
    echo >&2
  fi
  printf 'arch-guard: %d file(s) checked, %d violation(s)\n' "${total}" "${failed}"
fi

# --- optional migration doc ---------------------------------------------------
if [ "${WRITE_MD}" -eq 1 ]; then
  if [ "${MODE}" != "all" ] || [ ${#PATHS[@]} -gt 0 ]; then
    echo "arch_guard_scan: --md needs a full scan (no --staged/--changed/paths)" >&2
    exit 2
  fi
  {
    printf '# Migratsiya ro'"'"'yxati — arch-guard buzilishlari\n\n'
    printf 'Manba: `.claude/rules/flutter-architecture.md`\n'
    printf 'Guard: `.claude/hooks/arch-guard.sh`\n'
    printf 'Generator: `scripts/arch_guard_scan.sh --md`\n\n'
    printf '**%d / %d fayl** — qamrov: `modules/*/lib/**/*.dart`, test'"'"'siz.\n\n' "${failed}" "${total}"
    if [ "${failed}" -eq 0 ]; then
      printf 'Buzilish yo'"'"'q.\n'
    else
      printf '| Sabab | Fayl |\n|-------|------|\n'
      sort -t$'\t' -k2,2 -k1,1 "${TMP_REPORT}" | while IFS=$'\t' read -r file reason; do
        printf '| %s | `%s` |\n' "${reason}" "${file}"
      done
    fi
  } > "${MIGRATION_DOC}"
  echo "arch_guard_scan: wrote ${MIGRATION_DOC}"
fi

[ "${failed}" -eq 0 ]
