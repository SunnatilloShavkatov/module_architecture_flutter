---
name: flutter-conventions
description: Use when writing or editing any Dart/Flutter file under modules/ or packages/ — module folder structure, module-boundary rules, forbidden API/pattern table (Navigator, MediaQuery, print, showDialog, hardcoded EdgeInsets/Text, etc.), naming conventions, and class modifiers (final class / sealed class / abstract interface class).
---

# Structure and Module Boundary

```
packages/              # Shared packages (no dependency on modules)
  core/                # entity, Either, usecase base, network, l10n, Constants, DI interfaces
  components/          # UI: Dimensions (kGap*, kPadding*, kRadius*), buttons, snackbar, theme
  navigation/          # Routes, CupertinoRoute, MaterialSheetRoute, MaterialDialogRoute, args
  platform_methods/    # native channel
  merge_dependencies/  # Single orchestrator: aggregates every module (_allContainer)

modules/<module>/lib/src/
  domain/              # entities/, repository/, usecases/, interactor/ (pure Dart, zero Flutter)
  data/                # datasource/ (+impl part), models/, repository/
  presentation/<feature>/
    <feature>_page.dart
    bloc/ mixin/ widgets/ args/
  di/<module>_injection.dart
  router/<module>_router.dart
  <module>_container.dart
```

**Hard Boundary:**
- `modules/*` **never** import each other directly or list each other in `pubspec.yaml` (`arch-guard`).
- Cross-module communication only via `ModuleInteractor`, `PageFactory`, `WidgetFactory<T>`, or `Routes`.
- Never reach into another package's `src/` — use only its barrel: `package:core/core.dart`.

---

# Hard Bans — Zero Tolerance

| ❌ Don't write                                   | ✅ Write                                                                         | Reason                                                              |
|-------------------------------------------------|---------------------------------------------------------------------------------|---------------------------------------------------------------------|
| `package:flutter/material.dart`                 | `package:material_ui/material_ui.dart` and `package:components/components.dart` | Architecture standard (`arch-guard`)                                |
| `Navigator.push/pop`, `MaterialPageRoute`       | `context.pushNamed(...)`, `context.pop(value)`                                  | go_router navigation                                                |
| `showDialog`, `showModalBottomSheet`            | `MaterialDialogRoute<T>`, `MaterialSheetRoute<T>`                               | Every modal and dialog must live on the router stack (`arch-guard`) |
| `MediaQuery.of(context)`                        | `context.width` / `context.height` / `context.padding` / `context.viewInsets`   | Core extensions                                                     |
| `print()`, `debugPrint()`                       | `logMessage('...', error: e, stackTrace: s)`                                    | Safe logging                                                        |
| `Text('Login')` hardcoded                       | `Text(context.l10n.login)`                                                      | Localization (l10n) (`arch-guard`)                                  |
| `EdgeInsets.all(16)`                            | `Dimensions.kPaddingAll16`                                                      | UI design system                                                    |
| `SizedBox(height: 16)` for spacing              | `Dimensions.kGap16` or `spacing: 16`                                            | UI design system                                                    |
| `List _items = []` or `int _page` in a BLoC     | mixin field (`docs/rules/page-mixin.md`)                                        | BLoC is a stateless engine; the mixin owns data                     |
| public usecase in a BLoC                        | `final GetXxx _getXxx;` (private final)                                         | Encapsulation                                                       |
| `_onXxx` handler name                           | `_getXxxHandler` (`_<verb><target>Handler`)                                     | Naming standard                                                     |
| `on<Event>()` without `transformer:`            | always an explicit transformer (`droppable()`, `throttle()`, `debounce()`)      | Prevents duplicate requests                                         |
| `fromJson` / `toJson`                           | `fromMap` / `toMap`                                                             | Model standard                                                      |
| `Theme.of(context)`                             | `context.color`, `context.textStyle`, `context.textTheme`                       | Theme tokens (`arch-guard`)                                         |
| passing a callback via `extra`                  | `context.pop(value)` + `await context.pushNamed<T>(...)`                        | A callback is lost on deep link / restore                           |
| adding a module to `pubspec.yaml`               | `ModuleInteractor` / `WidgetFactory`                                            | Cross-module isolation                                              |
| `flutter analyze`, `flutter test` during a turn | never during a turn (AGENTS.md §7), only hook and pre-commit                    | Time and token savings                                              |

### If you need an exception

Guard allows disabling one rule for a file — a reason is mandatory:
```dart
// arch-guard: allow l10n-text — 'Visa' is a brand name, identical in every locale
```
IDs: `l10n-text`, `bloc-mutable`, `bloc-public-dep`, `build-when`, `import-order`.
Excluding a whole file (parked code): `// arch-guard: ignore — <reason>`, in the first 3 lines.
Exception is a last resort — first try to fit the code to the rule.

---

# Naming and Class Modifiers

| What          | Rule                     | Example                     |
|---------------|--------------------------|-----------------------------|
| file / folder | snake_case               | `notifications_page.dart`   |
| class         | PascalCase               | `NotificationsBloc`         |
| private field | `_camelCase`             | `_getNotifications`         |
| event         | `<Verb><Noun>Event`      | `GetNotificationsEvent`     |
| state         | `<Noun><Status>State`    | `NotificationsLoadingState` |
| handler       | `_<verb><target>Handler` | `_getNotificationsHandler`  |
| usecase       | `<Verb><Noun>`           | `GetNotifications`          |
| repository    | `<Noun>Repository`       | `NotificationsRepository`   |
| api paths     | `<Module>ApiPaths`       | `NotificationsApiPaths`     |

- `sealed class`: Event and State roots (and subfamilies).
- `final class`: implementations (`*Impl`), BLOC, Router, Container, Injection, Interactor, Args, `*Params`, `*ApiPaths`.
- `abstract interface class`: Repository and DataSource contracts.
- `class` (no modifier): Entity, Model, **UseCase**, StatefulWidget page, Mocktail mocks.
- Constructor: **`const new(...)`** / **`new(...)`** (Dart 3.47 shorthand). Repeating the class name is banned.

Import order: `dart:` block → blank line → all `package:` imports **in one alphabetical list**
(the module's own package is in that same list, not separate). `arch-guard` checks this.
