# CLAUDE.md

Full rules: `AGENTS.md` — read on demand, not autoloaded.
Ban/naming table: `.claude/skills/flutter-conventions/SKILL.md` (autoloads on any Dart file edit).

## Turn Policy

- Never during a turn: `flutter analyze`, `flutter test`, `flutter pub get`,
  `flutter clean`, `flutter build`, `dart format ./`, `dart fix --apply`.
  Quality gate: PostToolUse guard (every edit) → Stop hook (format + scan) → pre-commit → CI (full).
- On a guard message: fix only the indicated line, don't re-read the file.
- Don't read one file twice. Search with `rg` — not `find` / `ls -R`.
- Don't write plans or option lists — do the work, 3–5 line summary + list of touched files.

## Ready Commands

`/bloc`, `/page`, `/endpoint`, `/l10n`, `/module`, `/test`, `/guard` — `.claude/commands/`.
Each shows its own needed reference + rules file, no extra file reads.

Communicate with the user in Uzbek. Rules and code comments stay English.
