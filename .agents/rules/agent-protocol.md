# Agent conduct protocol (Antigravity / autonomous agents)

> Rules source: `AGENTS.md`. This file is only about **the agent's own conduct**.
> Antigravity autoloads `.agents/rules/`.

## 1. Terminal (`run_command`)

- Never use `cd`. Always pass the `Cwd` parameter.
- Default sandbox: `BypassSandbox: false`. Only request bypass when network access is needed.
- Don't chain commands with `&&` into a long sequence — one prefix-matchable, single-purpose command.
- **Banned commands (during a turn):** `flutter analyze`, `dart analyze`, `flutter test`,
  `flutter pub get`, `flutter clean`, `flutter build`, `dart format ./`, `dart fix --apply`.
  Quality gate: guard → pre-commit → CI (`AGENTS.md` §7). If needed:
  `bash scripts/arch_guard_scan.sh --changed` (~1 s).

## 2. Editing files (`replace_file_content`)

- `view_file` before editing — check the line number and indentation.
- Don't fire multiple parallel edit calls at the same file.
- Don't overwrite a large existing file with `write_to_file` — replace only the needed part.

## 3. Planning

- Bug fix, l10n, UI styling, single-file refactor → **don't write a plan**, just do it.
- A plan is only for: a new module or a large architectural refactor.

## 4. After every edit (self-check, no command)

- Did `package:flutter/material.dart` sneak into an import (only `material_ui` allowed)?
- No import of another module from `modules/*`.
- Constructor uses `const new(...)` form.
- Text via `context.l10n.*`, `BlocBuilder` has `buildWhen`.

## 5. Token discipline

- Don't read one file twice; search with `rg`.
- Don't read a long file in full — only the needed range.
- Response: what was done in 3–5 lines + touched files. No plan/option list.
