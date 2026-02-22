---
description: Layered execution workflow for clean arch feature
---
**Step 0: Prep**
- Decide owner module (`module_selection.md`). Inspect local naming style.

**Step 1: Domain**
- Entity, Repo interface, Usecase.

**Step 2: Data**
- Model, abstract/impl Datasource via `part`, Repo impl, Error map.

**Step 3: Presentation**
- BLoC + part, Page + Mixin, Widgets.

**Step 4: Wire**
- DI (`<module>_injection.dart`) & Routes (`_router.dart`).

**Step 5: Quality Gates (Mention only)**
- `dart fix --apply`, `dart format ./`, `analyze`.

*Output discipline*: For each step, output ONLY changed/new file content. No explanations.
