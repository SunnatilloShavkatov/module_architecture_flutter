---
description: Find and fix arch-guard violations
allowed-tools: Read, Edit, Bash(bash scripts/arch_guard_scan.sh:*), Grep
---

1. Run `bash scripts/arch_guard_scan.sh --changed`.
2. For each message, fix **only the indicated line** — don't re-read the whole file.
3. Repeat until clean (max 3 times), then report what remains.

If the rule doesn't apply — exception comment (reason mandatory):
`// arch-guard: allow <id> — <reason>` (`.claude/skills/flutter-conventions/SKILL.md`).

Don't use `flutter analyze` — guard is enough.

$ARGUMENTS
