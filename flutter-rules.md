# Flutter Rules (Project Source of Truth)

Use this file as the primary rule set for code generation and refactoring.

## 0. Rule Priority (Mandatory)

1. `flutter-rules.md` (primary)
2. `docs/**` rules (supporting)
3. existing module conventions in target module

Merge policy:

- apply rules from both `flutter-rules.md` and docs;
- if conflict appears, apply stricter architectural rule;
- preserve existing module-local conventions unless the task explicitly asks to refactor them.

This file is self-applying:

- updates to `flutter-rules.md` must also follow `flutter-rules.md`.

## 1. AI Work Mode (Mandatory)

- Use minimal tokens, maximum outcome.
- Do not generate generic placeholder code as final output.
  - avoid names like `FeatureNameBloc`, `GetFeatureEvent` in real implementation.
- Before coding, inspect target module structure and follow existing local style.
- Explain only what is needed for implementation decisions.
- Final delivery must include:
  - owner module decision;
  - touched files list (only changed files);
  - quality-gate command status for touched scope.

## 2. Repository Awareness (Mandatory)

Current modules:

- `modules/auth`
- `modules/home`
- `modules/initial`
- `modules/main`
- `modules/more`
- `modules/system`

Where to add feature code:

- module code: `modules/<module>/lib/src/`
- data: `modules/<module>/lib/src/data/`
- domain: `modules/<module>/lib/src/domain/`
- presentation: `modules/<module>/lib/src/presentation/<feature>/`
- DI: `modules/<module>/lib/src/di/`
- router: `modules/<module>/lib/src/router/`

Module naming in this repository is module-based and explicit:

- container: `<module>_container.dart`
- injection: `<module>_injection.dart`
- router: `<module>_router.dart`

Do not rename existing module entry files unless task explicitly requests it.

Module ownership decision (mandatory before implementation):

1. map request to an existing module by domain ownership;
2. if one module clearly owns the feature, implement there;
3. if no module owns it, create a new module (see `docs/architecture/new_module_creation.md`);
4. if cross-module impact exists, keep one owner module and connect others through navigation or interfaces.

Default ownership hints for this repository:

- auth/login/session -> `modules/auth`
- home/dashboard content -> `modules/home`
- startup/welcome/splash -> `modules/initial`
- app shell/tabs/root navigation -> `modules/main`
- settings/more menu -> `modules/more`
- fallback/error/system pages -> `modules/system`

## 3. Stack (Immutable)

- Flutter `3.38+`
- Dart `3.10+`
- `flutter_bloc`, `GetIt`, `GoRouter`, `Dio`, `Hive`, `Firebase`
- shared packages: `core`, `components`, `navigation`, `base_dependencies`
- do not add new packages unless already in repository and explicitly requested.

## 4. Monorepo and Module Architecture Principles (Mandatory)

- This is a modular monorepo; changes must be module-scoped first.
- Add feature code only inside the target module unless shared reuse is required.
- Shared reusable code belongs in `packages/`, not copied across modules.
- Avoid direct module-to-module tight coupling.
- Cross-module communication should prefer:
  - shared packages
  - route-based navigation
  - explicit interfaces only when required
- Do not move files between modules unless task explicitly requires architectural migration.

## 5. Clean Architecture Boundaries (Immutable)

Dependency direction:

```
Presentation -> Domain <- Data
```

Rules:

- Presentation must not access repositories directly.
- BLocs/pages/widgets must not call data sources.
- Use cases call domain repository interfaces only.
- Repository implementations stay in data layer.

## 6. Folder and File Conventions

For business features, keep 3 layers:

1. Data
   - `data/datasource/` (abstract + impl via `part`)
   - `data/models/` (`fromMap`, `toMap`)
   - `data/repo/` or `data/repository/` based on target module convention
2. Domain
   - `domain/entities/`
   - `domain/repos/` or `domain/repository/` based on target module convention
   - `domain/usecases/`
3. Presentation
   - `presentation/<feature>/bloc/`
   - `presentation/<feature>/mixin/`
   - `presentation/<feature>/widgets/`
   - `presentation/<feature>/<feature>_page.dart`

Use existing folder naming of the target module. Do not mix both styles inside one module.

Monorepo consistency rule:

- keep naming and folder style consistent with the target module's existing conventions.

## 7. Naming and Imports

- files/dirs: `snake_case`
- classes: `PascalCase`
- variables: `camelCase`
- private: `_camelCase`
- required suffixes: `Bloc`, `Event`, `State`, `Entity`, `Model`, `Repo`/`Repository`, `DataSource`, `UseCase`, `Impl`, `Page`, `Widget`, `Mixin`

Import order:

1. Dart SDK
2. Flutter
3. Packages
4. Relative

Use single quotes only.

## 8. Lint and Static Analysis Rules (Mandatory)

- Lint baseline must follow `analysis_lints`.
- Use floating latest strategy: `analysis_lints: any`.
- Every package/module should include:
  - `include: package:analysis_lints/analysis_options.yaml`
- Do not introduce code that leaves lint warnings/errors for the touched scope.
- If a subproject is intentionally configured with `flutter_lints` (for example-specific setup), keep its existing lint strategy unless task requests migration.

## 9. Bloc Rules (Strict, Non-Negotiable)

Bloc class:

- `final class XxxBloc extends Bloc<XxxEvent, XxxState>`

Events and states:

- root types must be `sealed class` + `Equatable` in `part` files;
- concrete event/state classes must be `final class`.
- legacy note: some existing module blocs may still be non-final.
  - do not mass-refactor untouched legacy files.
  - for new/rewritten blocs, use `final class`.

Handler naming:

- must use `_<verb><Target>Handler` style;
- examples: `_getProfileHandler`, `_createOrderHandler`, `_updateThemeModeHandler`;
- do not use generic `_onXxx` in new code.

Event naming pattern:

- `GetXxxEvent`, `CreateXxxEvent`, `UpdateXxxEvent`, `DeleteXxxEvent`, `ResetXxxEvent`.

State naming pattern:

- `XxxInitialState`
- `XxxLoadingState`
- `XxxLoadedState` or `XxxSuccessState`
- `XxxErrorState` or `XxxFailureState`
- for multi-flow pages, split by sealed substate groups (e.g. `ReferralInfoState`, `ReferralCodeState`, `ProductsState`).

Concurrency and safety:

- use transformers (`droppable`, `throttle`, `debounce`) where needed;
- guard duplicate requests: `if (state is XxxLoadingState) return;`;
- keep side effects out of bloc build layer.

Concurrency decision rule:

- use `droppable` for repeated async loads where only first in-flight call should run
  - examples: pagination load more, repeated refresh taps.
- use `throttle` for rapid repeated taps where limited frequency is needed
  - examples: submit/login/pay buttons.
- use `debounce` for noisy input streams
  - examples: search/filter text changes.
- use `sequential` when event order must be preserved for state correctness
  - examples: dependent multi-step mutations.

## 10. Domain Rules

Entities:

- immutable only;
- extend `Equatable`;
- no JSON/UI code.
- API-backed entity nullability contract:
  - list fields must be non-null (`final List<T> items;`) and constructor `required`;
  - scalar/object fields should be nullable by default (`String?`, `int?`, `double?`, `Entity?`);
  - do not force fallback values like `''` or `0` for nullable API fields unless business rule explicitly requires it;
  - include all fields in `props`.

Use cases:

- use `UsecaseWithParams` or `UsecaseWithoutParams`;
- call domain repository interfaces only;
- return `ResultFuture<T>`.

Repository interfaces:

- keep in domain repo folder of target module (`repos` or `repository`);
- return `ResultFuture<T>`.

## 11. Data Rules

Models:

- must have `fromMap` and `toMap`;
- mapping model ↔ entity must be explicit.
- follow fixed model standard from `docs/data_layer/models.md` (do not invent new parse style per feature).
- model nullability contract must mirror entity contract:
  - list fields non-null and required;
  - other fields nullable unless explicit business rule exists.
- parsing contract in `fromMap`:
  - read nested response safely (e.g. `result`) with map-type checks;
  - initialize list as empty and fill only when source is `List`;
  - parse each list item via child model `fromMap`;
  - cast scalar fields as nullable (`as String?`, `as int?`, ...).
- include `fromEntity` when model extends entity and repository uses explicit mapping.

Data sources:

- abstract interface + `part` impl is mandatory;
- network through `_networkProvider.fetchMethod<T>(...)` only;
- handle errors:
  - `FormatException` -> `formatException`
  - `ServerException` -> `rethrow`
  - `TypeError` -> `typeError`
  - default -> `unknownError`

Repositories:

- implementation in data repo folder of target module;
- map errors:
  - `ServerException` -> `Left(error.failure)`
  - other `Exception` -> `Left(ServerFailure(message))`

## 12. DI Rules (GetIt)

- implementations should be `final class`.
- `registerLazySingleton`: data sources, repositories, use cases.
- `registerFactory`: blocs.
- resolve dependencies via `di.get<Type>()`.
- follow existing module DI style when page factories exist.

## 13. Navigation Rules (GoRouter Only)

Use only:

- `context.pushNamed(Routes.name, extra: Args())`
- `context.goNamed(Routes.name, extra: Args())`
- `context.pop()` / `context.pop(result)`

Args:

- `final class` with `const` constructor.

Never use Navigator 1.0 APIs.

## 14. Page, Mixin, Widget Rules

Page:

- use `StatefulWidget` for feature pages with bloc/mixin;
- dispatch initial events in `initState()`;
- use `BlocListener` for side effects and `BlocBuilder` for UI.

Mixin:

- keep in `presentation/<feature>/mixin/` and connect via `part of`;
- include `XxxBloc get bloc => context.read<XxxBloc>();`;
- place `_handleStates` listener logic here;
- dispose controllers, timers, focus nodes, notifiers.

Widget:

- stateless by default;
- constructor-driven inputs;
- no repository/data source calls;
- use callbacks to communicate actions.

## 15. UI, Localization, Logging

UI:

- use `context.width` / `context.height`, not `MediaQuery.of(context)`.
- use theme extensions: `context.color`, `context.textStyle`, `context.textTheme`, `context.colorScheme`.
- use localization: `context.localizations.key`.
- prefer components package widgets.

Logging and errors:

- use `logMessage()`;
- do not use `print`/`debugPrint`;
- show user errors with `showErrorMessage(context, message: ...)` in listeners.

## 16. Feature Implementation Order (Mandatory)

1. Domain: Entity -> Repository interface -> UseCase
2. Data: Model -> DataSource -> Repository Impl
3. Presentation: Bloc → Page + Mixin → Widgets
4. DI: register in `<module>_injection.dart`
5. Router: add route + args in `<module>_router.dart`

## 17. Formatting and Fix Rules (Mandatory)

After code changes in touched scope:

1. run `dart fix --apply`
2. run `dart format ./`
3. run static analysis (`flutter analyze` or `dart analyze` for touched module/package)

If these commands report issues, resolve them before finalizing.

## 18. Mandatory Docs to Apply

AI must read and apply these before feature implementation:

- `docs/architecture/overview.md`
- `docs/architecture/clean_architecture.md`
- `docs/architecture/module_structure.md`
- `docs/architecture/dependency_injection.md`
- `docs/architecture/module_selection.md`
- `docs/architecture/new_module_creation.md`
- `docs/domain_layer/entities.md`
- `docs/domain_layer/repositories.md`
- `docs/domain_layer/usecases.md`
- `docs/data_layer/models.md`
- `docs/presentation_layer/page_bloc_widget_mixin_plan.md`
- `docs/presentation_layer/reference_best_practices.md`
- `docs/architecture/project_map.md`

## 19. Compliance Checklist

- [ ] feature ownership decision completed (existing module vs new module)
- [ ] owner module explicitly stated before implementation
- [ ] target module structure inspected before coding
- [ ] new code placed in correct module folders
- [ ] monorepo boundaries respected (no accidental cross-module leakage)
- [ ] clean architecture boundaries preserved
- [ ] bloc uses `final class`, sealed event/state root, `final` concrete classes
- [ ] handler naming uses `_<verb><Target>Handler`
- [ ] events/states named explicitly (no generic placeholder names)
- [ ] errors handled and surfaced in listener
- [ ] entity/model nullability contract respected (list non-null, other API fields nullable)
- [ ] DI and router updated in module files
- [ ] if new module created: registered in `packages/merge_dependencies/lib/merge_dependencies.dart`
- [ ] `dart fix --apply` and `dart format ./` executed for touched scope
- [ ] analyzer warnings/errors resolved for touched scope
- [ ] touched files list included in final delivery
- [ ] no prohibited APIs used
