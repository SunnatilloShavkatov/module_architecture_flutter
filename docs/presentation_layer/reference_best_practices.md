# Reference Best Practices (Auth, Referral, Marketplace)

Use these practices when implementing new features.

## 1. Reference Scope

Reference modules provide end-to-end page + bloc + mixin + widget patterns:

- `auth`
- `referral`
- `marketplace`

Note:

- these references are external pattern sources for architecture/style;
- do not copy import paths or module paths from external references directly into this repository.

## 2. Core Practices to Reuse

### Bloc shape

- `final class XxxBloc extends Bloc<XxxEvent, XxxState>`
- root `sealed class` for events and states
- concrete `final class` events and states
- private handlers with `Handler` suffix

Preferred handler style:

- `_getXxxHandler`
- `_createXxxHandler`
- `_updateXxxHandler`
- `_deleteXxxHandler`

### Presentation import and package usage

For presentation layer, prefer project package stack used in existing modules:

- `package:components/components.dart`
- `package:core/core.dart`
- `package:navigation/navigation.dart`

Then add module-local imports.

Import order must stay:

1. Dart SDK
2. Flutter
3. Packages
4. Relative/module-local imports

### State grouping

Use grouped state families for complex pages:

- example pattern: `XxxInfoState`, `XxxCodeState`, `XxxFaqState`
- each family has loading/loaded/error classes
- page can then use `buildWhen` with a specific state family

### Concurrency control

- apply `droppable()` or `throttle()` for request events;
- add loading guard in handler when needed;
- keep one request flow per handler.

Do not use one transformer for every event.

- choose per event intent:
  - load/pagination duplicate suppression -> `droppable`
  - repeated taps -> `throttle`
  - typing/search -> `debounce`
  - order-critical mutation chains -> `sequential`

## 3. Module-Specific Patterns

### Auth-derived patterns

- one page can host multi-step flow controlled by mixin state;
- form validation + focus logic belongs in mixin helpers;
- deep-link subscriptions are created and disposed in mixin/page lifecycle;
- all failures are surfaced via listener-side `_handleStates`.

### Referral-derived patterns

- dispatch multiple startup events in `initState()` when page requires parallel data;
- split state by functional area to avoid mixed rebuild triggers;
- own `Timer`/`PageController` in mixin and always dispose.

### Marketplace-derived patterns

- use `droppable()` for heavy load events;
- guard duplicate request states;
- split big UI into widgets (`item`, `dialog`, `section`) to keep page readable;
- push navigation decisions to listener/mixin side.

## 4. Page and Mixin Separation

- page builds widgets and wires `BlocListener`/`BlocBuilder`;
- mixin owns stateful resources and side effects;
- `_handleStates` is the single transition gate for navigation, dialogs, and error messages.

## 5. Why These Practices

- keeps architecture predictable under scale;
- reduces regressions from mixed side effects in build methods;
- standardizes naming and flow so AI does not drift into ad-hoc patterns.

## 6. External Reference Quality Notes

Practices in this document are aligned with external reference documentation quality patterns:

- explicit decision trees (what to implement and where);
- strict handler naming conventions to avoid drift;
- compact instructions focused on high-signal rules;
- validation-first workflow (`fix` -> `format` -> `analyze`).
