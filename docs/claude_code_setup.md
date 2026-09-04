# Claude Code Setup Spec

How this repo is configured for Claude Code, and how to drive it correctly and fast.

Scope: the harness (`.claude/`), not the architecture. Architecture rules live in
[`CLAUDE.md`](../CLAUDE.md); the working procedure lives in [`AGENTS.md`](../AGENTS.md).

---

## 0. Blocker — read this first

**The Flutter on PATH cannot build or analyze this repo.**

| | |
|---|---|
| On PATH | Flutter 3.41.9, Dart 3.11.5 (`/Users/sshovkatov/src/flutter`) |
| Repo requires | `flutter: ">=3.47.0"`, `sdk: ">=3.13.0 <4.0.0"` (every `pubspec.yaml`) |
| Result | `flutter analyze` fails with `version solving failed` in every package |

`CLAUDE.md` §16's quality gate is therefore unrunnable right now, and so is CI parity
locally. `~/src/flutter_macos_arm64_3.47.2-stable.zip` is downloaded but not active, and
`fvm` is installed at `~/.pub-cache/bin/fvm`.

Fix this before anything else — every other guarantee in this document depends on the
analyzer actually running. Either extract the 3.47.2 archive and point PATH at it, or
pin the version with fvm:

```bash
fvm use 3.47.2 --force && fvm flutter --version
```

Until then the Stop hook detects the SDK-resolution failure and reports it once per
turn instead of blocking (see §2), so the setup degrades quietly rather than nagging.

---

## 1. What exists

| File | State | Purpose |
|---|---|---|
| `CLAUDE.md` | committed, 599 lines / 47 KB | architecture rules; auto-loaded every session |
| `AGENTS.md` | committed, 41 lines | working loop + output discipline |
| `docs/` | committed, 16 files / 123 KB | per-topic detail, opened on demand via `CLAUDE.md` §0 |
| `docs/template_reference.md` | committed, 37 KB | copy-paste shape of every file type |
| `.claude/settings.json` | **new** | permissions + hook wiring |
| `.claude/hooks/dart-guard.sh` | **new** | per-edit formatter and rule guard |
| `.claude/hooks/dart-gate.sh` | **new** | end-of-turn `flutter analyze` gate |

Deliberately absent, with reasons:

- **`.mcp.json`** — no Jira/Slack/GitHub MCP need in this workflow. Adding it costs a
  connection handshake per session and buys nothing.
- **`.claude/agents/`** — the `caveman:cavecrew` plugin already provides
  investigator / builder / reviewer subagents. A second set would just compete.
- **`CLAUDE.local.md`** — single-developer repo; nothing machine-specific to separate.
- **`.claude/commands/`** — see §4, worth adding once the rule split lands.

---

## 2. The hooks

Instructions in `CLAUDE.md` are advisory: the model can skip them. Hooks are executed by
the harness, so they cannot be skipped. Both hooks are wired in `.claude/settings.json`
and were verified firing end-to-end.

### `dart-guard.sh` — PostToolUse on `Write|Edit|MultiEdit`

Runs on every `.dart` file Claude writes. Non-Dart files exit immediately.

1. Runs `dart format` on the file.
2. Records the path in `$TMPDIR/claude-dart-touched-<session_id>.txt` for the Stop gate.
3. Greps for rule violations.

**Hard findings — exit 2, fed back to Claude, which must fix them:**

| Rule | Pattern caught |
|---|---|
| §12a | `import 'package:flutter/material.dart'` / `cupertino.dart` |
| §12, §15 | `package:{core,components,navigation,platform_methods,material_ui,cupertino_ui}/src/` from outside that package |
| §12 | `MediaQuery.of(` |
| §12 | `Navigator.push` / `.pop` / `.pushNamed` / `.pushReplacement` |
| §12 | `print(` |
| §2 | `_onXxx` handler naming in `*_bloc.dart` |
| §5b, §9 | `pageBuilder:` in `*_router.dart` |

**Soft findings — injected as context, do not block:**

| Rule | Heuristic |
|---|---|
| §2 | `*_bloc.dart` has more `on<Event>()` registrations than `transformer:` occurrences |
| §5b | bare `GoRoute(` in `*_router.dart` — legitimate only for shell branch roots and `Dimensions.kZeroBox` placeholders |

Soft findings are heuristics on purpose: both have real exceptions in the rules, so
blocking them would produce false positives. They surface for a judgment call instead.

### `dart-gate.sh` — Stop

Runs when Claude finishes a turn. Reads the touched-file ledger, walks up to each
file's nearest `pubspec.yaml`, and runs `flutter analyze` once per package.

- No Dart files touched this turn → exits silently. Q&A turns pay nothing.
- Analyzer findings → exit 2 with the output; Claude must fix before the turn ends.
- SDK-resolution failure (§0) → one `systemMessage`, exit 0. An environment problem is
  not something Claude can fix by editing Dart, so blocking there would loop.
- `stop_hook_active` guard prevents re-entry.
- The ledger is cleared before analyzing; files re-touched while fixing get re-recorded,
  so the gate re-runs on the next stop.

Timeouts: 60 s for the guard, 600 s for the gate.

### Changing them

Hooks are read from `.claude/settings.json` at session start. After editing either
script or the settings file, the change may not take effect until the config is
reloaded — open `/hooks` once, or restart the session. `/hooks` also lists and disables
them.

---

## 3. The `CLAUDE.md` split — specified, not yet done

**Status: not implemented.** This section is the spec for it. The original file is
committed at `2d6ee36` and recoverable with `git show HEAD:CLAUDE.md`.

### Problem

`CLAUDE.md` is 47 KB, roughly 12 000 tokens, loaded before every prompt in every
session. Adding one widget to `payments` pulls in the pagination rules, the interactor
generics trap, and the sheet-route conventions. The file itself names the symptom — §0
opens with "agents keep skipping this — stop skipping it".

### Design

Split by **how often a rule applies**, not by layer:

- **Always loaded** (root `CLAUDE.md`, target ~180 lines): rules that apply to nearly
  every file, plus a **one-line stub for every rule that moved out**. The stub is the
  point — it prevents "I did not know the rule existed" while leaving the detail on
  disk. Keep: §0 map, §1 priority, §2 naming + transformer table, §3 rule (not the
  worked example), §4 placement, §5b table, §10–§16, §17.
- **On demand** (`.claude/rules/*.md`), each a stub target:

  | File | Moves | Size |
  |---|---|---|
  | `setstate-and-rebuilds.md` | §3's worked example and the `login_mixin` / `otp_login_mixin` narrative | ~2 KB |
  | `route-args.md` | §5 + §5a `.parse()` | ~4 KB |
  | `pagination.md` | §6 | ~2 KB |
  | `cross-module-interactor.md` | §7 + §7a | ~5 KB |
  | `cross-module-factories.md` | §8 + §8a | ~4 KB |
  | `sheet-routes.md` | §9 | ~2 KB |

Expected: ~47 KB → ~18 KB always-loaded. About 7 500 tokens saved per session.

### Caveat

`.claude/rules/` is not an auto-loading directory in Claude Code — it is a convention,
and the files are read because the root `CLAUDE.md` stub points at them. Claude Code's
real path-scoped mechanism is a nested `CLAUDE.md` in a subdirectory, which loads when
files in that subtree are touched. That does not help here: almost all work happens
under `modules/`, so a `modules/CLAUDE.md` would load essentially always and save
nothing. The stub-and-pointer design is the one that actually reduces the resident
context.

The hooks in §2 are what make this split safe: the mechanical rules most likely to be
skipped are now enforced by execution rather than by being resident in context.

---

## 4. Optional next step — `.claude/commands/`

Worth adding after §3 lands, because slash commands are how the moved rule files get
pulled in reliably:

| Command | Does |
|---|---|
| `/new-module <name>` | reads `docs/architecture/new_module_creation.md`, scaffolds, registers in `merge_dependencies` |
| `/new-feature <module> <feature>` | reads the bloc/page/mixin plan, builds domain → data → presentation → DI → router in order |
| `/check` | runs the §16 gate manually and reports |

Not urgent. The hooks cover the correctness floor; commands only save typing.

---

## 5. Driving Claude fast on this repo

### Give the owner module up front

`AGENTS.md` step 1 makes Claude state `Owner module:` + `Reason:`. If you already know
it, say it — that skips a `docs/architecture/module_selection.md` read and an `ls
modules/`.

- Slow: "add a saved-cards list"
- Fast: "in `payments`, add a saved-cards list page"

### Ask for a whole vertical slice, not file by file

The build order is fixed (`CLAUDE.md` §14: domain → data → presentation → DI → router).
Asking for one layer at a time forces Claude to re-read the same references each turn.
One request for the whole feature costs one pass over the docs.

### Name the file type

`docs/template_reference.md` is 37 KB with per-file-type sections. Saying "a sheet" or
"a paginated list" tells Claude which section to open instead of the whole file.

### Point at the specific doc, not "the docs"

"Check the docs" makes Claude guess across 16 files. "Follow
`docs/domain_layer/usecases.md`" is one read.

### Use plan mode for anything structural

New module, ownership ambiguity, cross-module wiring: plan first, approve, then build.
Cheaper than reviewing a wrong implementation.

### Existing modules are not the reference

`CLAUDE.md` §1.3 and `AGENTS.md` step 4: modules predate the rules. Say "follow
`CLAUDE.md` §2, not `auth`'s bloc" when you want the current convention rather than the
nearest example. Note that some `CLAUDE.md` examples are themselves stale —
`auth_router.dart` is cited in §5b as a plain-`GoRoute` offender but already uses
`CupertinoRoute`.

### Delegate lookups

`caveman:cavecrew` is installed. For "where is X defined" / "what calls Y", the
`cavecrew-investigator` subagent returns a `file:line` table instead of dumping file
contents into the main thread.

### Keep `/caveman` on

Also installed, active by default in this session. Roughly 75 % fewer output tokens
with no loss of technical content. Code, commits, and security warnings stay in normal
prose.

---

## 6. Checklist for a new project copied from this template

1. Confirm the toolchain resolves: `flutter --version` ≥ 3.47.0, then
   `flutter analyze` clean at the root.
2. Copy `.claude/settings.json` and `.claude/hooks/`. The hooks are path-agnostic;
   they use `$CLAUDE_PROJECT_DIR`.
3. Delete the modules the project does not need, then prune the `CLAUDE.md` examples
   that referenced them — `CLAUDE.md`'s own preamble says every cited module is an
   illustration, not a requirement.
4. Register any new module in
   `packages/merge_dependencies/lib/merge_dependencies.dart`'s `_allContainer`.
   Skipping this means DI and routes silently do not load.
5. Re-verify the hooks fire: write a `.dart` file with
   `import 'package:flutter/material.dart';` and confirm it is blocked.
