---
description: New API endpoint (api_paths + datasource + model + repository + usecase)
argument-hint: <module> <endpoint>
allowed-tools: Read, Edit, Write, Grep, Glob
---

Reference: `modules/notifications/lib/src/data/` (api_paths, datasource + impl, models, repository impl)
and `modules/notifications/lib/src/domain/` (entity, repository interface, usecase).
Rules: `docs/rules/data-api.md` TL;DR block; `docs/rules/domain.md` for the domain layer.

Requirements:
- `fromMap` / `toMap` — never `fromJson` / `toJson`
- add the path to `<Module>ApiPaths`
- `abstract interface class` for the datasource/repository interface; `final class` for impl
- domain is pure Dart: no `package:flutter/*` or `material_ui` import
- result is `Either<Failure, T>`; usecase is `class <Verb><Noun>`
- DI: update `modules/<module>/lib/src/di/<module>_injection.dart`

Don't use analyze/test during the turn.

Task: $ARGUMENTS
