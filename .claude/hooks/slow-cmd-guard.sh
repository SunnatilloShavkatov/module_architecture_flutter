#!/usr/bin/env bash
# slow-cmd-guard.sh — keeps minute-long commands out of an agent turn.
#
# PreToolUse(Bash) hook. Reads {"tool_input":{"command":"..."}} on stdin.
# Exit 0 = allowed. Exit 2 = blocked, stderr goes back to the model.
#
# Rationale: this repo is a modular architecture template. A repo-wide analyze,
# format or test run costs minutes per turn and finds what arch-guard, the
# pre-commit hook and CI already find. See AGENTS.md §7.
#
# Matching is per command word, not per substring: a banned name that appears as
# an argument (`rg "flutter analyze" AGENTS.md`, `echo 'dart test'`) is data, not
# an invocation, and must not be blocked.
#
# Escape hatch: ALLOW_SLOW=1 in the environment disables the guard.

set -uo pipefail

[ "${ALLOW_SLOW:-0}" = "1" ] && exit 0

payload=$(cat)

cmd=$(printf '%s' "$payload" | python3 -c \
  'import sys,json;print(json.load(sys.stdin).get("tool_input",{}).get("command",""))' 2>/dev/null)

# Fallback for a machine without python3: first "command" value on the line.
if [ -z "${cmd:-}" ]; then
  cmd=$(printf '%s' "$payload" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)
fi

[ -z "${cmd:-}" ] && exit 0

block() {
  echo "slow-cmd-guard: blocked in-turn command" >&2
  echo "  $1" >&2
  exit 2
}

# Wrappers that leave the real command inside the same segment:
# `time flutter analyze`, `FOO=1 dart test`, `bash scripts/run_tests.sh`.
strip_wrappers() {
  local seg="$1" trimmed
  while :; do
    trimmed=${seg#"${seg%%[![:space:]]*}"}
    case "$trimmed" in
      time\ *|sudo\ *|nice\ *|env\ *|command\ *|exec\ *|bash\ *|sh\ *|zsh\ *)
        seg=${trimmed#* } ;;
      [A-Za-z_][A-Za-z0-9_]*=*\ *)
        seg=${trimmed#* } ;;
      *)
        printf '%s' "$trimmed"; return ;;
    esac
  done
}

segments=$(printf '%s\n' "$cmd" | tr ';|&()' '\n\n\n\n\n')

while IFS= read -r raw; do
  [ -z "$raw" ] && continue
  seg=$(strip_wrappers "$raw")
  case "$seg" in
    "flutter analyze"*|"dart analyze"*)
      block "analyze does not run in a turn. arch-guard already checked this edit; scoped analyze runs in pre-commit. AGENTS.md §7." ;;
    "flutter test"*|"dart test"*)
      block "tests run in CI or pre-commit, not in a turn. AGENTS.md §7." ;;
    "flutter pub get"*|"flutter clean"*|"flutter build"*)
      block "pub get / clean / build are the developer's call. Ask instead of running it." ;;
    "dart format ."*|"dart format lib"*)
      block "repo-wide format is done by the Stop hook on changed files only." ;;
    "dart fix --apply"*)
      block "dart fix --apply runs in pre-commit, not in a turn." ;;
  esac

  case "${seg%% *}" in
    *run_tests.sh)
      block "tests run in CI, not in a turn. AGENTS.md §7." ;;
  esac
done <<EOF
$segments
