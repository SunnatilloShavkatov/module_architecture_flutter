---
description: Template-Cloning execution workflow for clean arch feature
---

# Template-Cloning Workflow

**Step 0: Reference & Read (CRITICAL)**
- Find the `<Reference Feature>` provided in the prompt (typically `docs/TEMPLATE_REFERENCE.md`). 
- Or use a specific requested existing module.
- Read its Domain, Data, and Presentation layers. 
- Your final output MUST act as an exact 1:1 structural and logical clone of the reference architecture, adapted for the new `<Feature>`.

**Step 1: Domain Clone**
- Clone Entity, Repository interface, and Usecase logic from the reference.

**Step 2: Data Clone**
- Clone Model (exact `fromMap`/`toMap` handling), abstract/impl Datasource via `part`, Repository implementation, and Error mapping logic from the reference.

**Step 3: Presentation Clone**
- Clone BLoC (with `part` for event/state), Page + Mixin, and Widgets syntax from the reference.

**Step 4: Wire**
- Wire DI (`<module>_injection.dart`) & Routes (`_router.dart`) exactly how it is done in the reference.

**Step 5: Quality Gates (Mention only)**
- `dart fix --apply`, `dart format ./`, `analyze`.

### Output Discipline
For each step, output ONLY changed/new file content. Absolutely NO explanations.

### Prompt Template (For Vibe Coding)
```text
/clean_arch_feature.workflow
Owner module: <e.g., modules/profile>
New feature: <e.g., update_avatar>
Reference template: <e.g., docs/TEMPLATE_REFERENCE.md or path/to/module>
Scope: <Domain | Data | Presentation | All>
Do not: Use placeholders, print(), or do unrelated refactors.
Output: Only production-ready code. No explanations.
```
