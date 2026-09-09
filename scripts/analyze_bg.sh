#!/usr/bin/env bash
# analyze_bg.sh — runs the scoped analyze in the background and leaves a
# one-line summary the next turn can read for free. Nothing waits on it.
#
#   bash scripts/analyze_bg.sh &

set -uo pipefail
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${REPO_DIR}"

out=".dart_tool/agent"
mkdir -p "${out}"

bash scripts/analyze_changed.sh > "${out}/analyze.raw" 2>&1
issues=$(grep -cE '^[[:space:]]*(error|warning|info)' "${out}/analyze.raw" 2>/dev/null || echo 0)

if [ "${issues}" -eq 0 ]; then
  echo "analyze(bg): clean" > "${out}/analyze.txt"
else
  echo "analyze(bg): ${issues} issue(s) — see .dart_tool/agent/analyze.raw" > "${out}/analyze.txt"
fi
