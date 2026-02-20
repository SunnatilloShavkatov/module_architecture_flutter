# Components + Core Usage Rules (Presentation Layer)

This document defines strict usage rules for `components` and `core` in module presentation code.

Goal:

- prevent wrong widget/token usage in generated code;
- keep UI consistent across modules;
- avoid importing unavailable or internal APIs.

## 1. Ownership and Layer Boundary

Use these rules only in presentation layer:

- `modules/<module>/lib/src/presentation/**`

Do not use presentation UI APIs in domain/data:

- domain and data must not depend on `BuildContext`, `Theme`, `components` widgets, or UI extensions.

## 2. Import Policy (Strict)

In module code, import public package entry files only:

```dart
import 'package:components/components.dart';
import 'package:core/core.dart';
```

Do not import package internals from modules:

- `package:components/src/...` is prohibited;
- `package:core/src/...` is prohibited.

Reason:

- `src` APIs are internal and may change;
- some widgets in package folders are not exported publicly.

## 3. Allowed Components API Surface

For module presentation code, treat the following as the supported `components` surface (via `components.dart`):

- `CustomLoadingButton`
- `SafeAreaWithMinimum`
- `SliverSafeAreaWithMinimum`
- `Gap`, `SliverGap`
- `Dimensions`
- `ModalProgressHUD`
- `KeyboardDismiss`
- `AppOptions`, `ModelBinding`
- `ThemeContextExt` (`context.color`, `context.textStyle`, `context.textTheme`, `context.colorScheme`, ...)
- `AppOptionsContextExt` (`context.options`, `context.setLocale`, `context.setThemeMode`)

If a widget is not accessible from `package:components/components.dart`, do not use it in module code until it is exported intentionally.

## 4. Token Priority (Color, Style, Spacing)

Use this order in presentation code.

### 4.1 Colors

1. `context.color.*` for app-specific colors
2. `context.colorScheme.*` for Material component interoperability
3. avoid hardcoded `Colors.*` in module UI (except technical cases like `Colors.transparent` when no token exists)

### 4.2 Typography

1. `context.textStyle.*` for app typography tokens
2. `context.textTheme.*` when integrating with Material widgets
3. avoid new ad-hoc `TextStyle(...)` in module UI unless no token can represent the requirement

### 4.3 Spacing and Radius

1. `Dimensions.kGap*`, `Gap(...)`, `SliverGap(...)`
2. `Dimensions.kPadding*`, `Dimensions.kBorderRadius*`, `Dimensions.kShape*`
3. avoid raw `EdgeInsets.*` / `BorderRadius.*` in module UI when a matching `Dimensions` token exists

## 5. Widget Usage Rules

### 5.1 Safe area

For page body and bottom actions, prefer:

```
SafeAreaWithMinimum(
  minimum: Dimensions.kPaddingAll16,
  child: ...,
)
```

Use plain `SafeArea` only when `SafeAreaWithMinimum` behavior is explicitly not desired.

### 5.2 Buttons

Use `CustomLoadingButton` for submit/retry/primary async actions.

Reason:

- built-in throttle against double taps;
- consistent loading behavior.

Use raw `ElevatedButton`/`TextButton` only for simple, non-loading secondary actions.

### 5.3 Loading overlay

For whole-screen async blocking state, prefer `ModalProgressHUD` instead of custom stack/overlay duplication.

### 5.4 Keyboard dismiss

Prefer `KeyboardDismiss` where form UX needs tap-to-dismiss behavior and it is not already handled by `ModelBinding`.

## 6. Core Context Extensions (Required)

In module presentation code:

- size: use `context.width`, `context.height`, `context.padding`, `context.viewInsets`;
- localization: use `context.localizations.<key>`;
- avoid direct `MediaQuery.of(context)` when extension getters already cover the requirement.

## 7. Navigation and User Feedback

- navigation: GoRouter named APIs only (`pushNamed`, `goNamed`, `pop`);
- side effects: perform in listener/mixin, not inside `build`;
- error feedback: use a project-approved messenger pattern from listener/mixin (for current codebase, `ScaffoldMessenger`-based snackbar pattern is acceptable).

Do not reference helpers that are not present in this repository.

## 8. String and Localization Rule

User-facing text in module presentation must come from localization keys:

- required: `context.localizations.<key>`
- avoid hardcoded UI strings in pages/widgets

Hardcoded strings are allowed only for temporary debug text in explicitly marked development-only code.

## 9. Practical Do / Don’t

Do:

```
Text(
  context.localizations.welcomeSubtitle,
  style: context.textStyle.defaultW700x24.copyWith(color: context.color.textPrimary),
)
```

Don’t:

```
Text(
  'Welcome',
  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black),
)
```

Do:

```
SafeAreaWithMinimum(
  minimum: Dimensions.kPaddingAll16,
  child: Column(children: [Dimensions.kGap16, ...]),
)
```

Don’t:

```
SafeArea(
  minimum: const EdgeInsets.all(16),
  child: Column(children: [const SizedBox(height: 16), ...]),
)
```

## 10. Pre-Delivery Checklist (Presentation Scope)

- [ ] imports use only `package:components/components.dart` and `package:core/core.dart` public API
- [ ] no `package:components/src/...` or `package:core/src/...` import in module code
- [ ] color/style/spacing follow token priority
- [ ] safe area/button/loading widgets follow rules above
- [ ] localization keys used for user-facing strings
- [ ] no direct `MediaQuery.of(context)` when extension getter exists
