---
description: Template-driven constraint rules for Antigravity
---
- **Golden Rule (Clone, don't invent)**: MUST read the `Reference Feature` provided in the prompt. 
- **Reference Priorities:**
  1. Use the provided `docs/TEMPLATE_REFERENCE.md` as the primary structural reference.
  2. Alternatively, an existing module path if provided in the prompt.
- **Drift Guard**: Make the smallest safe assumption if info is missing. Explain NOTHING. Return ONLY the requested code according to the template.
- **Strict Patterns**: 
  - `final class Bloc`, `sealed` events/states, `Equatable`.
  - `registerLazySingleton` (data source, repo, usecase), `registerFactory` (bloc).
  - GoRouter only (`context.pushNamed`, `goNamed`, `pop`).
  - Isolated API endpoints per module (`final class <Feature>ApiPaths`).
- **Core Packages Use**: You MUST rely on `package:core/core.dart` (for architecture base classes), `package:components/components.dart` (for UI), and `package:navigation/navigation.dart`. Do not invent new base classes.
- **Forbidden**: `Navigator 1.0`, `print/debugPrint`, `MediaQuery.of(context)` (use context extensions from components), generating placeholders, writing unrelated files.
