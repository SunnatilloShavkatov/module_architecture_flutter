# Project Map (Where What Exists)

This document provides a project-aware map so implementation is added in the correct place.

## Root Map

- `lib/` app entry
- `modules/` feature modules
- `packages/` shared packages
- `docs/` architecture and implementation rules

## Module Inventory

- `modules/auth`
  - full feature module with data/domain/presentation/di/router
  - reference for auth flow with bloc + mixin + page
- `modules/home`
  - module container + router + DI + presentation main page
- `modules/initial`
  - startup/welcome flow pages + router + container
- `modules/main`
  - app shell module with page + mixin + router + DI
- `modules/more`
  - settings/more feature with bloc/event/state + pages + DI + router
- `modules/system`
  - system pages (not found / internet connection) + router + container

## Entry File Pattern in This Repository

Per module, use current naming convention:

- `modules/<module>/lib/<module>.dart`
- `modules/<module>/lib/src/<module>_container.dart`
- `modules/<module>/lib/src/di/<module>_injection.dart`
- `modules/<module>/lib/src/router/<module>_router.dart`

Do not rename existing entry files unless explicitly requested.

## Where to Add New Feature Files

For a target module `<module>` and feature `<feature>`:

- domain entity: `modules/<module>/lib/src/domain/entities/<entity>_entity.dart`
- domain repository: `modules/<module>/lib/src/domain/repos/` or `modules/<module>/lib/src/domain/repository/` (follow module style)
- domain use case: `modules/<module>/lib/src/domain/usecases/<usecase>.dart`
- data model: `modules/<module>/lib/src/data/models/<model>_model.dart`
- data source: `modules/<module>/lib/src/data/datasource/<source>_data_source.dart`
- data repository impl: `modules/<module>/lib/src/data/repo/` or `modules/<module>/lib/src/data/repository/` (follow module style)
- bloc files: `modules/<module>/lib/src/presentation/<feature>/bloc/`
- page file: `modules/<module>/lib/src/presentation/<feature>/<feature>_page.dart`
- mixin file: `modules/<module>/lib/src/presentation/<feature>/mixin/<feature>_mixin.dart`
- widgets: `modules/<module>/lib/src/presentation/<feature>/widgets/`
- DI update: `modules/<module>/lib/src/di/<module>_injection.dart`
- route update: `modules/<module>/lib/src/router/<module>_router.dart`

## Why This Mapping Matters

- prevents files from being placed in wrong modules;
- keeps boundaries clear for Clean Architecture;
- avoids accidental cross-module coupling;
- keeps onboarding and maintenance predictable.

## Real Naming Examples (Current Repository)

- `repo/repos` style:
  - `modules/auth/lib/src/domain/repos/auth_repo.dart`
  - `modules/auth/lib/src/data/repo/auth_repo_impl.dart`
- `repository` style:
  - `modules/home/lib/src/domain/repository/home_repo.dart`
  - `modules/home/lib/src/data/repository/home_repository_impl.dart`
  - `modules/more/lib/src/domain/repository/more_repository.dart`
  - `modules/more/lib/src/data/repository/more_repository_impl.dart`

## Monorepo Rules (Apply on Every Task)

- Keep feature work in the target module first.
- Move only truly shared code to `packages/`.
- Do not duplicate shared logic across multiple modules.
- Do not change module entry naming or structure unless task explicitly requires it.

## Required Validation Commands

Run for touched scope before completion:

1. `dart fix --apply`
2. `dart format ./`
3. `flutter analyze` (or `dart analyze` where appropriate)

## Ownership Decision Reference

Before coding, apply:

- `docs/architecture/module_selection.md`

If no owner module fits, apply:

- `docs/architecture/new_module_creation.md`
