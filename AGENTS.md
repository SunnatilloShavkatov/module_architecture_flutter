# AGENTS.md

Default instruction file for Codex in this repository.

## Mandatory Startup

Before any implementation:

1. read `flutter-rules.md`
2. read required docs listed in `flutter-rules.md`
3. apply rule priority from `flutter-rules.md`

## Mandatory Ownership Decision

For each task, decide first:

- owner module (existing module), or
- new module required

If no existing module owns the feature:

- follow `docs/architecture/module_selection.md`
- then follow `docs/architecture/new_module_creation.md`

## Architecture and Monorepo Constraints

- keep Clean Architecture boundaries
- keep changes module-scoped first
- avoid cross-module coupling
- keep target module local conventions (`repo/repository`, `repos/repository`) consistent
- do not refactor unrelated files

## Implementation Constraints

- no generic placeholder implementations in final code
- use project naming/import/style rules from `flutter-rules.md`
- use GoRouter named navigation only
- keep BLoC/event/state/mixin patterns from docs

## Quality Gates (Required)

For touched scope before finalizing:

1. `dart fix --apply`
2. `dart format ./`
3. `flutter analyze` or `dart analyze`

Do not finalize with unresolved analyzer issues in touched scope.

## Final Delivery Contract

- state owner module;
- provide touched files list;
- report quality-gate execution status.
