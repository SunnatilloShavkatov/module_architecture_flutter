# AGENTS.md — Modular Architecture Standard and Rules

> **SINGLE SOURCE OF TRUTH.** `CLAUDE.md`, `GEMINI.md`, `.agents/rules/` point here.
> This project is a standalone reference template (template/boilerplate) for new mobile apps.
> On conflict: **this file > actual code > other docs**. Guard rules:
> [`.claude/rules/flutter-architecture.md`](.claude/rules/flutter-architecture.md).

---

## 0. Communication Language and Style

- Always answer the user in Uzbek. Keep technical terms (bloc, mixin, transformer, sealed, route) in English.
- Write code, comments, commit messages, PR text, and identifiers in English.
- Do not translate error/log text — show it verbatim.
- Write tersely. Skip plan/option lists — do the work, then report what you did in 3–5 lines.

---

## 1. Workflow — Every Task

1. **Read the reference file** (table in §3) — don't invent, copy the existing style.
2. Read the file you're changing **in full** + one neighboring file.
3. Per the §2 router, read **only the needed** rules file. Reading all of them is not required.
4. Write. Minimal diff. Don't touch unrelated code.
5. On a guard message — fix that exact line. **No analyze/test command at all** (§7).

### Token rules

- Don't read one file twice; remember what you've already read.
- Search with `rg`. Not `find`, `ls -R`, or reading a whole folder.
- If a file exceeds 400 lines, read only the needed part via `offset/limit`.
- A guard (`arch-guard`) message is a ready-made diagnosis. Don't re-check — fix it directly.
- Don't write a plan/option list. Response: what was done (3–5 lines) + touched files.

---

## 2. Rules Router (Rules Map)

| Task                                                    | Read (only this)                                             |
|---------------------------------------------------------|--------------------------------------------------------------|
| bloc / event / state / transformer                      | `docs/rules/bloc.md`                                         |
| page / mixin / widget / setState / pagination           | `docs/rules/page-mixin.md`                                   |
| new module, DI, container, cross-module communication   | `docs/rules/module.md`                                       |
| endpoint, datasource, model, repository impl            | `docs/rules/data-api.md`                                     |
| domain (entity, repository, usecase, interactor)        | `docs/rules/domain.md`                                       |
| route, navigation, args, bottom sheet, dialog           | `docs/rules/navigation.md`                                   |
| UI, spacing, padding, color, font, component            | `docs/rules/ui.md`                                           |
| text, translation, new l10n key                         | `docs/rules/l10n.md`                                         |
| websocket, audio, long-lived service                    | `docs/rules/service.md`                                      |
| work inside `packages/*` (component, theme, constant)   | `docs/rules/packages.md`                                     |
| test (unit, bloc, repo, mocktail)                       | `docs/rules/testing.md`                                      |
| guard message, adding a new check                       | `.claude/rules/flutter-architecture.md`                      |
| new module skeleton (script)                            | `docs/rules/module.md` + `./scripts/create_module.sh <name>` |
| "why does this file violate the rule?" — legacy pattern | `.claude/rules/migration-list.md` (style debt)               |
| agent's own conduct (terminal, editing, planning)       | `.agents/rules/agent-protocol.md`                            |
| unsure                                                  | this file + the nearest reference file                       |

---

## 3. Reference Files — Pattern to Copy

All real reference files in the project. **`notifications` is the primary reference module.**
The `auth` module has legacy naming remnants (`domain/repos/`, `AuthRepo`) —
take only the form/OTP page+mixin pattern from it, not the naming
(`.claude/rules/migration-list.md`).

| What you're writing                    | Reference File                                                                                                        |
|----------------------------------------|-----------------------------------------------------------------------------------------------------------------------|
| bloc + event + state                   | `modules/notifications/lib/src/presentation/notifications/bloc/notifications_bloc.dart`                               |
| multi-operation sealed state           | `modules/notifications/lib/src/presentation/notifications/bloc/notifications_state.dart`                              |
| paginated list + set-union             | `modules/notifications/lib/src/presentation/notifications/notifications_page.dart` & `mixin/notifications_mixin.dart` |
| form + validation + auth               | `modules/auth/lib/src/presentation/login/login_page.dart` & `mixin/login_mixin.dart`                                  |
| OTP / confirmation input               | `modules/auth/lib/src/presentation/otp_login/otp_login_page.dart` & `mixin/otp_login_mixin.dart`                      |
| edit form + args + pop result          | `modules/profile/lib/src/presentation/edit_profile/edit_profile_page.dart` & `mixin/edit_profile_mixin.dart`          |
| card entry / formatting                | `modules/payments/lib/src/presentation/add_card/add_card_page.dart` & `mixin/add_card_mixin.dart`                     |
| dashboard / multi-section screen       | `modules/home/lib/src/presentation/main/home_page.dart` & `mixin/home_mixin.dart`                                     |
| splash / app bootstrap                 | `modules/initial/lib/src/presentation/splash/splash_page.dart` & `mixin/splash_mixin.dart`                            |
| navigation shell / tabs                | `modules/main/lib/src/presentation/main/main_page.dart` & `mixin/main_mixin.dart`                                     |
| bottom sheet (via route)               | `modules/notifications/lib/src/presentation/notifications_filter_sheet/notifications_filter_sheet.dart`               |
| dialog (via route)                     | `modules/notifications/lib/src/presentation/clear_notifications_dialog/clear_notifications_dialog.dart`               |
| router (CupertinoRoute, Sheet, Dialog) | `modules/notifications/lib/src/router/notifications_router.dart`                                                      |
| args + `.parse()`                      | `modules/notifications/lib/src/presentation/notifications_filter_sheet/args/notifications_filter_args.dart`           |
| domain (entity, repo, usecases)        | `modules/notifications/lib/src/domain/`                                                                               |
| datasource + model + repo impl         | `modules/notifications/lib/src/data/`                                                                                 |
| DI (injection)                         | `modules/notifications/lib/src/di/notifications_injection.dart`                                                       |
| module container                       | `modules/notifications/lib/src/notifications_container.dart`                                                          |
| widget factory                         | `modules/notifications/lib/src/presentation/notifications/factory/notification_item_factory.dart`                     |
| module interactor                      | `modules/notifications/lib/src/domain/interactor/get_unread_notifications_count_interactor.dart`                      |
| full test suite                        | `modules/notifications/test/notifications_test.dart`                                                                  |

---

## 4–6. Structure, Hard Bans, Naming

Module folder structure, module boundary rules, the `❌/✅` ban table, and naming/class
modifier rules live in the `.claude/skills/flutter-conventions/SKILL.md` skill
(autoloads on every Dart file edit — not duplicated here).

---

## 7. Quality Gate — NOT During the Turn

These commands are **banned** during a turn (`PreToolUse` hook blocks them):
`flutter analyze`, `dart analyze`, `flutter test`, `dart test`, `scripts/run_tests.sh`,
`flutter pub get`, `flutter clean`, `flutter build`, `dart format ./`, `dart fix --apply`.

Reason: in a multi-module project, this wastes 2–5 minutes and tokens every turn.

| Stage            | What                                                           | When             | Time       |
|------------------|----------------------------------------------------------------|------------------|------------|
| PostToolUse hook | `arch-guard.sh` (flutter-conventions skill bans, §2 structure) | every Write/Edit | ~50 ms     |
| Stop hook        | `dart format` + guard scan — changed file only                 | end of turn      | ~2 s       |
| pre-commit       | format check + `dart analyze` (touched package only)           | `git commit`     | 5–25 s     |
| CI               | full tests + `flutter analyze`                                 | PR               | background |

The only check allowed during a turn — guard scan (~1 s, doesn't invoke flutter):
`bash scripts/arch_guard_scan.sh --changed`.
Manual, if the developer wants: `bash scripts/analyze_changed.sh` or `./scripts/verify.sh`.

### Self-check at end of turn (model does this itself, no command)

- [ ] Reference file opened, style copied
- [ ] Nothing from the `flutter-conventions` skill's ❌ table present
- [ ] No mutable field in BLOC, dependencies are `private final`
- [ ] Every `on<Event>()` has a `transformer:`; loading-emitting handler has a guard
- [ ] UI data lives in the mixin; derived value is a getter
- [ ] Every `BlocBuilder` has `buildWhen`, sealed subfamily is named
- [ ] Every modal and dialog is a separate Route (`MaterialSheetRoute`, `MaterialDialogRoute<T>`)
- [ ] No cross-module dependency added (`pubspec.yaml`)
- [ ] All text via `context.l10n.*`
- [ ] Response includes the list of touched files

---

## 8. Ready-Made Commands (Slash Commands / Workflows)

Each shows its own needed reference + rules file — no extra file reads.

| Command                         | What it does                                    | Claude Code                    | Other agents                    |
|---------------------------------|-------------------------------------------------|--------------------------------|---------------------------------|
| `/bloc <module> <feature>`      | bloc + event + state                            | `.claude/commands/bloc.md`     | `.agents/workflows/bloc.md`     |
| `/page <module> <feature>`      | page + mixin + route                            | `.claude/commands/page.md`     | `.agents/workflows/page.md`     |
| `/endpoint <module> <endpoint>` | api_paths + datasource + model + repo + usecase | `.claude/commands/endpoint.md` | `.agents/workflows/endpoint.md` |
| `/l10n <key> "<text>"`          | 3 `.arb` files + usage                          | `.claude/commands/l10n.md`     | `.agents/workflows/l10n.md`     |
| `/module <name>`                | new module skeleton + orchestration             | `.claude/commands/module.md`   | `.agents/workflows/module.md`   |
| `/test <module> <target>`       | test + aggregator wiring                        | `.claude/commands/test.md`     | `.agents/workflows/test.md`     |
| `/guard`                        | scan and fix guard violations                   | `.claude/commands/guard.md`    | `.agents/workflows/guard.md`    |

You may read these files even without a command — they are a shorthand for §1–§3.
