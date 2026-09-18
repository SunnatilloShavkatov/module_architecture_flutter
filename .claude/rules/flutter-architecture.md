---
paths:
  - "modules/*/lib/src/**/*.dart"
  - "packages/*/lib/src/**/*.dart"
  - "lib/**/*.dart"
---

# Flutter architecture rules

This file was written by **measuring the existing code**. The evidence column on each row is
the ratio `<files matching the rule>/<files checked>`, as of 2026-09-06.
Measurement scope: **279 `.dart` files** (`modules/*/lib` 152, `packages/*/lib` 121, `lib/` 6).

`lib/` holds only 6 files (bootstrap: `main_dev`, `main_prod`, `app`, `main_common`,
2 `firebase_options`). Real code lives inside `modules/` and `packages/` — that's why
the frontmatter isn't limited to `lib/**`.

**Enforcement threshold:** ≥90% → mandatory rule. 60–90% → written as the chosen convention,
but `arch-guard.sh` does **not** enforce it. <60% → listed under "Unsettled areas".

---

## 1. Folder layout

Three levels: **monorepo → module → layer-first inside the module → feature-first inside the layer.**
No mixed scheme.

| Rule                                                                                                                       | Evidence                              |
|----------------------------------------------------------------------------------------------------------------------------|---------------------------------------|
| App code must live inside `modules/<m>/` or `packages/<p>/`; `lib/` is bootstrap only                                      | 273/279 files in `modules`+`packages` |
| Module barrel file must be `modules/<m>/lib/<m>.dart` and export only `<M>Container`                                       | 8/8                                   |
| Module entry point must be `modules/<m>/lib/src/<m>_container.dart`, `final class <M>Container implements ModuleContainer` | 8/8                                   |
| Router must live at `modules/<m>/lib/src/router/<m>_router.dart`                                                           | 8/8                                   |
| DI must live at `modules/<m>/lib/src/di/<m>_injection.dart`                                                                | 6/6 (modules that have DI)            |
| Domain layer must be `src/domain/{entities,repository,usecases}/`                                                          | 5/6 modules (`auth` uses `repos/`)    |
| Data layer must be `src/data/{datasource,models,repository}/`                                                              | 5/6 modules (`auth` uses `repo/`)     |
| Presentation must be `src/presentation/<feature>/` — each feature in its own folder                                        | 42/42 presentation files              |
| The bloc triad must live in `src/presentation/<feature>/bloc/`                                                             | 6/6 features                          |
| Mixin must live in `src/presentation/<feature>/mixin/`                                                                     | 8/8                                   |
| Route arguments must live in `src/presentation/<feature>/args/`                                                            | 1/1                                   |
| A sheet gets its own top-level folder: `src/presentation/<name>_sheet/`                                                    | 1/1                                   |
| Cross-module page factory at the module root: `src/<m>_page_factory.dart`                                                  | 2/2                                   |
| Module-local API paths must be `src/data/datasource/<m>_api_paths.dart`; adding to a global `ApiPaths` is forbidden        | 5/5, 0 global                         |

Module skeleton:

```
modules/<m>/
  lib/<m>.dart                                  ← barrel: export 'src/<m>_container.dart' show <M>Container;
  lib/src/<m>_container.dart
  lib/src/<m>_page_factory.dart                 ← only if the module exposes a page externally
  lib/src/di/<m>_injection.dart
  lib/src/router/<m>_router.dart
  lib/src/domain/entities/<x>_entity.dart
  lib/src/domain/repository/<m>_repository.dart
  lib/src/domain/usecases/<verb>_<target>.dart
  lib/src/data/datasource/<m>_api_paths.dart
  lib/src/data/datasource/<m>_{remote,local}_data_source.dart
  lib/src/data/datasource/<m>_{remote,local}_data_source_impl.dart
  lib/src/data/models/<x>_model.dart
  lib/src/data/repository/<m>_repository_impl.dart
  lib/src/presentation/<feature>/<feature>_page.dart
  lib/src/presentation/<feature>/bloc/<feature>_{bloc,event,state}.dart
  lib/src/presentation/<feature>/mixin/<feature>_mixin.dart
  lib/src/presentation/<feature>/args/<feature>_args.dart
  test/src/**                                   ← mirrors lib/src/**
```

---

## 2. File ↔ class naming

Rows **enforced** by `arch-guard.sh` (≥90%, `modules/*/lib/src/` only).

The table matches the `RULES` block in `arch-guard.sh` **character for character**. Columns
are exactly `path_marker|allowed_file_suffixes|class_suffix` fields, in the same order
(first match wins). Verify with: `bash .claude/hooks/arch-guard-selftest.sh`.

| path_marker               | allowed_suffixes                       | class_suffix                      | Evidence |
|---------------------------|----------------------------------------|-----------------------------------|----------|
| `@src_root`               | `_container,_factory`                  | `Container,Factory`               | 10/10    |
| `@presentation_root`      | `_page,_sheet,_dialog,_widget`         | `Page,Sheet,Dialog,Widget`        | 18/18    |
| `/src/data/models/`       | `_model`                               | `Model`                           | 10/10    |
| `/src/data/datasource/`   | `_source,_impl,_api_paths,_datasource` | `Source,Impl,ApiPaths,DataSource` | 16/16    |
| `/src/data/repository/`   | `_impl`                                | `RepositoryImpl`                  | 5/5      |
| `/src/domain/repository/` | `_repository`                          | `Repository`                      | 5/5      |
| `/src/domain/interactor/` | `_interactor`                          | `Interactor`                      | 1/1      |
| `/src/di/`                | `_injection`                           | `Injection`                       | 6/6      |
| `/src/router/`            | `_router`                              | `Router`                          | 8/8      |
| `/bloc/`                  | `_bloc,_event,_state`                  | `Bloc,Event,State`                | 18/18    |
| `/mixin/`                 | `_mixin`                               | `Mixin`                           | 8/8      |
| `/args/`                  | `_args`                                | `Args`                            | 2/2      |

Markers starting with `@` are positional (not path substrings):

- `@src_root` — `modules/<m>/lib/src/<file>.dart` (directly inside `src`, no subfolder).
- `@presentation_root` — `modules/<m>/lib/src/presentation/<feature>/<file>.dart`.
  `presentation/widgets/` is the shared widget bucket — exempt.

Out of guard scope (deliberately): `packages/**`, root `lib/**`, any `*/test/*`,
`*_test.dart`, and `*/test_helpers/*` — they follow other conventions (§9, §10).
A `// arch-guard: ignore <reason>` line at the top of a file excludes that one file.

Naming rules that are not enforced by guard but must still be followed:

| Rule                                                                                                                                                             | Evidence                                                                         |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------|
| Page class must be the PascalCase equivalent of the file name (`login_page.dart` → `LoginPage`)                                                                  | 14/14                                                                            |
| `State` class must be `_<X>PageState` — private                                                                                                                  | 8/9 (`InternetConnectionPageState` public — migration)                           |
| Mixin name must be `<Feature>Mixin`, constrained to `on State<<Feature>Page>`                                                                                    | 8/8                                                                              |
| Usecase class must be verb-first, no suffix (`GetHomeCategories`, `Login`, `UpdateProfileUser`) — `UseCase` suffix is forbidden                                  | 11/11                                                                            |
| Usecase parameters must be `final class <Usecase>Params` — in the **same file** as the usecase                                                                   | 5/5                                                                              |
| Datasource interface must be `abstract interface class`                                                                                                          | 11/11                                                                            |
| Impl file must be `_impl.dart`, class must be `<Interface>Impl`                                                                                                  | 11/11                                                                            |
| Container must be `final class <M>Container implements ModuleContainer`                                                                                          | 8/8                                                                              |
| Injection must be `final class <M>Injection implements Injection`                                                                                                | 6/6                                                                              |
| Router must be `final class <M>Router implements AppRouter<RouteBase>`                                                                                           | 8/8                                                                              |
| Page factory must be `final class <M>PageFactory implements PageFactory`, `InstanceNameKeys` key = class name                                                    | 2/2                                                                              |
| Constructor must use the `const new(...)` / `new(...)` shorthand; classic `const <ClassName>(` form is forbidden                                                 | 199 files vs 15 (93%)                                                            |
| `final class` modifier is mandatory on infrastructure classes: Bloc · Event · State · Container · Injection · Router · PageFactory · Params · ApiPaths · `*Impl` | 5/6 bloc, 6/6 container, 6/6 injection, 8/8 router, 5/5 params, 5/5 apipaths     |
| Domain/data data classes must be unmodified `class`: Entity · Model · Usecase                                                                                    | 10/10 entity, 10/10 model, 11/11 usecase — 0 `final`                             |
| Repo interface name must be `<M>Repository`, folders `domain/repository/` + `data/repository/`                                                                   | chosen convention; folders 5/6, class name 3/6 — `auth` is in the migration list |

---

## 3. Layer dependencies

Measured direction — zero violations:

| Rule                                                                                                                   | Evidence                      |
|------------------------------------------------------------------------------------------------------------------------|-------------------------------|
| All imports must be `package:`; relative imports (`../`, `./`) are forbidden                                           | 279/279                       |
| A module must reach its own files via `package:<m>/src/...` too                                                        | 279/279                       |
| A module must not import another module                                                                                | 0/8 modules violate           |
| Reaching into another package's `src/` is forbidden — barrel only (`package:core/core.dart`)                           | 0/279                         |
| `components` · `core` · `navigation` · `platform_methods` must not depend on each other or on `modules/*`              | 0 dependencies                |
| `fromMap`/`toMap` forbidden in `domain/`                                                                               | 0/17 domain files             |
| UI imports (`material_ui`, `cupertino_ui`, `package:flutter/...`) forbidden in `domain/`                               | 0/17                          |
| Model must `extends` the entity; the reverse is forbidden                                                              | 10/10                         |
| `fromMap` + `toMap` must live only on the model                                                                        | 7/7 models                    |
| Repo impl must `implements` the interface                                                                              | 6/6                           |
| Usecase must depend on the interface (`_repo` field is interface-typed)                                                | 11/11                         |
| Cross-module page handoff must go through `PageFactory`; the consumer's `pubspec.yaml` must not list the owning module | 2/2 factories, 0 dependencies |

Serialization:

| Rule                                                                                 | Evidence            |
|--------------------------------------------------------------------------------------|---------------------|
| `fromMap`/`toMap` must be hand-written                                               | 7/7 models          |
| `json_serializable` · `build_runner` · `freezed` · `fromJson`/`toJson` are forbidden | 0 pubspecs, 0 files |

DI:

| Rule                                                                                                                                       | Evidence                                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------|
| Bloc must be registered with `registerFactory`                                                                                             | 7/7                                                                                                                                        |
| Datasource · repository · usecase · factory must be registered with `registerLazySingleton`                                                | 30/30                                                                                                                                      |
| Registration order must be split by comments: `/// page factories` → `/// data sources` → `/// repositories` → `/// usecases` → `/// bloc` | `/// bloc` 5/5, `/// page factories` 2/2, `/// data sources` and `/// repositories` 4/5 (`auth` uses `/// data`, `/// domain` — migration) |

---

## 4. State management

`flutter_bloc`, `Equatable`, `bloc_concurrency`. No `freezed` (0 examples).

| Rule                                                                                                                              | Evidence                                               |
|-----------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------|
| Bloc must be `final class <F>Bloc extends Bloc<<F>Event, <F>State>`                                                               | 5/6 (`ProfileBloc` missing `final` — migration)        |
| Root event/state must be `sealed class ... extends Equatable`                                                                     | 6/6 event, 6/6 state                                   |
| Concrete event/state must be `final class`                                                                                        | 9/9 event, 26/26 state                                 |
| Every concrete state must override `props` (even if empty)                                                                        | 26/26                                                  |
| Event name must be `<Feature><Verb>Event` — noun-first: `HomeLoadEvent`, `PaymentMethodAddEvent`, `LoginSubmitEvent`              | 8/9 (`UpdateProfilePressedEvent` — migration)          |
| State names must be `<F>InitialState` · `<F>LoadingState` · `<F>SuccessState` · `<F>FailureState`; `Loaded`/`Error` are forbidden | 6/6 bloc, 0 `Loaded`/`Error`                           |
| Event/state files must attach to the bloc via `part` (`part 'x_event.dart';` + `part of 'x_bloc.dart';`)                          | 4/6 (`auth`'s two blocs import separately — migration) |
| Handler name must be `_<verb><Target>Handler`; `_on<Xxx>` is forbidden                                                            | 10/10 `Handler`, 0 `_on`                               |
| Every `on<Event>()` call must have a `transformer:`                                                                               | 10/10                                                  |
| Writes (POST/PATCH/PUT/DELETE) → `throttle()`; reads (GET) → `droppable()`                                                        | throttle 5/5 writes, droppable 5/5 reads               |
| Every handler must start with `if (state is <F>LoadingState) { return; }`                                                         | 10/10                                                  |
| Bloc constructor must take usecases as positional arguments, store them in a `final` private field                                | 6/6                                                    |

Grouped sealed state (multiple flows on one page) — one example in `profile_bloc`:
`sealed class LoadingState extends ProfileState` → `ProfileLoadingState`, `ProfileUpdatingState`.
One example, not a mandatory rule.

---

## 5. UI / design system

Design system: `packages/components` (`Dimensions`, `CustomLoadingButton`, `SafeAreaWithMinimum`,
`ModalProgressHUD`, `Gap`, `ThemeColors` extension) + `packages/core` (`context.l10n`, extensions).

| Rule                                                                                                                                                                                | Evidence                                                                                                                       |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|
| Widget import must be `package:material_ui/material_ui.dart`                                                                                                                        | 61 files                                                                                                                       |
| `package:cupertino_ui/cupertino_ui.dart` only for genuine Cupertino types                                                                                                           | 2 files                                                                                                                        |
| `package:flutter/material.dart` and `package:flutter/cupertino.dart` are forbidden                                                                                                  | 0/279                                                                                                                          |
| `package:flutter/{widgets,services,foundation}.dart` allowed only when needed                                                                                                       | 5 / 10 / 32 files                                                                                                              |
| Color must come from `context.color.*` or `context.colorScheme.*`; `Colors.*` and `Color(0x...)` are forbidden                                                                      | 62 uses, 0 hardcoded                                                                                                           |
| Text style must come from `context.textStyle.*` (primary, `ThemeTextStyles`) or `context.textTheme.*`; raw `TextStyle(` only inside `packages/components/lib/src/theme/`            | modules+packages: `textTheme` 33, `textStyle` 13; raw `TextStyle(` in `modules/*/lib` 4 (all in `auth`, on the migration list) |
| User-visible text must come from `context.l10n.<key>`; a `Text('...')` literal is forbidden (**arch-guard**)                                                                        | 0 in `modules/*/lib`. Non-alphabetic literals (`'404'`, `'1.0.0'`) and interpolation are exempt                                |
| Size/spacing must come from `Dimensions.*` tokens; raw `EdgeInsets`/`SizedBox` only when no token exists                                                                            | 99 vs 4 → 96%                                                                                                                  |
| Before using a `Dimensions.*` token, check it exists in `packages/components/lib/src/utils/dimensions.dart`                                                                         | —                                                                                                                              |
| Page `body` must be wrapped in `SafeAreaWithMinimum`; plain `SafeArea` is exempt only in `bottomNavigationBar`                                                                      | 12 vs 2 (both `bottomNavigationBar`) → 86%                                                                                     |
| Primary/submit button must be `CustomLoadingButton`; `ElevatedButton` is forbidden                                                                                                  | 14 vs 1 spot → 93%                                                                                                             |
| A full-screen async block must be wrapped in `ModalProgressHUD`                                                                                                                     | 2/2                                                                                                                            |
| `MediaQuery.of(context)` is forbidden — use `context.width` / `context.height` / `context.padding`                                                                                  | 0/279                                                                                                                          |
| `print()` is forbidden                                                                                                                                                              | 0/279                                                                                                                          |
| A page with a mixin must be `StatefulWidget`                                                                                                                                        | 8/8                                                                                                                            |
| Mixin must attach to the page via `part of '../<feature>_page.dart';`                                                                                                               | 8/8                                                                                                                            |
| A page without a mixin may be `StatelessWidget`                                                                                                                                     | 5/14 pages                                                                                                                     |
| A sheet's root must be `SafeAreaWithMinimum(minimum: Dimensions.kPaddingAll16, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, ...))` | 1/1                                                                                                                            |

---

## 6. Navigation

`go_router`, via the `packages/navigation` barrel. No `Navigator 1.0`.

| Rule                                                                                                                                                                                                                                                | Evidence                                               |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------|
| `Navigator.push` · `Navigator.pop` · `Navigator.of(` are forbidden — use `context.pushNamed`/`goNamed`/`pop`                                                                                                                                        | 0 `Navigator.`, 22 `context.*Named/pop`                |
| `showDialog(` · `showModalBottomSheet(` are forbidden — a dialog/sheet is registered on the router as `MaterialDialogRoute<T>` / `MaterialSheetRoute<T>` (**arch-guard**)                                                                           | 0/279                                                  |
| A sheet/dialog route must carry a generic (`MaterialSheetRoute<String>`, `MaterialDialogRoute<bool>`, `<void>` if no result); the result returns via `context.pop(value)` ↔ `context.pushNamed<T>`; passing a callback via `extra` is forbidden     | 3/3                                                    |
| Route classes must come only from the `package:navigation/navigation.dart` barrel                                                                                                                                                                   | 32 files, 0 `navigation/src/`                          |
| A full-screen page's route must be `CupertinoRoute`                                                                                                                                                                                                 | 9/9                                                    |
| A sheet's route must be `MaterialSheetRoute<T>`                                                                                                                                                                                                     | 2/2                                                    |
| Writing `pageBuilder:` in a module router is forbidden — the route class handles it                                                                                                                                                                 | 0/8 routers                                            |
| A `StatefulShellBranch` root / a placeholder returning `Dimensions.kZeroBox` may be a plain `GoRoute` — the sole exception                                                                                                                          | 4/4 `GoRoute`s are this case (`main_router.dart`)      |
| Route name/path must come from `Routes.*` constants (`packages/navigation/lib/src/name_routes.dart`)                                                                                                                                                | 1 source                                               |
| A sheet route's name must end in `...Sheet`                                                                                                                                                                                                         | 1/1                                                    |
| A route with input data must use `final class <F>Args` + `<F>Args.parse(state.extra, queryParameters: state.uri.queryParameters)`; a raw `state.extra! as <F>Args` cast, passing a callback via `extra`, and passing a raw entity are all forbidden | 2/2 (`edit_profile_args`, `notifications_filter_args`) |
| Router must return `List<GoRoute> getRouters(Injector di)` or `List<RouteBase> getRouters(Injector di)`                                                                                                                                             | 8/8                                                    |

---

## 7. Localization

| Rule                                                                                  | Evidence                |
|---------------------------------------------------------------------------------------|-------------------------|
| User-visible text must be provided via `context.l10n.<key>`                           | 80 vs 4 hardcoded → 95% |
| Translations must live in `packages/core/lib/src/l10n/app_{en,ru,uz}.arb`             | 3 languages             |
| Generated `app_localizations*.dart` files must not be hand-edited                     | 4 files                 |
| Key name is lowerCamelCase (`loginSuccessMessage`, `chooseThemeMode`, `expiresLabel`) | 80/80 uses              |

4 remaining hardcoded spots — on the migration list: `'Logo'`, `'1.0.0'`, `'404'`, `'Попробовать снова'`.

---

## 8. Testing

| Rule                                                                              | Evidence                                                                                                              |
|-----------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|
| Test must live under `<pkg>/test/src/**`, mirroring `lib/src/**` exactly          | 13/14 module tests                                                                                                    |
| Test file must be named `<source>_test.dart`                                      | 11/13 (`login_usecase_test.dart`, `otp_login_usecase_test.dart` — source is `login.dart`/`otp_login.dart`, migration) |
| Bloc test must be `test/src/presentation/<feature>/bloc/<feature>_bloc_test.dart` | 4/4                                                                                                                   |
| Every new bloc must have a bloc test                                              | 4/6 blocs (main/initial/system have no bloc)                                                                          |

`auth` is the only fully covered module (10 tests: datasource, model, repo, di, 2 usecases, 2 blocs, router).
Other modules only have a bloc test.

---

## 9. Unsettled areas (<60% — no rule)

| Point                        | Split                                                                                                                                                    | Status                                                                             |
|------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------|
| Repo interface name          | `<M>Repo` 3 (`HomeRepo`, `MainRepo`, `AuthRepo`) vs `<M>Repository` 3 (`NotificationsRepository`, `ProfileRepository`, `PaymentsRepository`) — **50/50** | No convention in the code. Owner chose `<M>Repository`; guard does not enforce it. |
| Repo impl file ↔ class match | `home_repository_impl.dart` → `HomeRepoImpl`, `main_repository_impl.dart` → `MainRepoImpl` — **2/6 mismatched**                                          | File says `_repository_impl`, class says `RepoImpl`. Not fixed.                    |

## 10. No example in the code — no rule in this file either

The following are described in `CLAUDE.md` but have **0 examples** in the code. They are therefore
not written as a rule here and guard does not check them:

`presentation/*/widgets/` folder · `ModuleInteractor` implementation · `WidgetFactory<T>`
implementation · pagination (page counter + scroll listener) · `Args.parse()` / `.empty()` /
`.fromQueryParameters()` · `SlideUpTransitionRoute` · `packages/core/lib/src/entities/` folder ·
`/// widget factories` and `/// interactors` DI comments.

Update this file once the first example appears.

## 11. Conflicting sources — resolved

- **`.cursorrules`** (42 lines) — contradicted the code: `fromJson`/`toJson` (code uses `fromMap`/`toMap`),
  `*UseCase` suffix (0/11 in code), `datasources/` + `repositories/` + `pages/` folders
  (code uses `datasource/`, `repo|repository/`, no `pages/` at all). **Removed.**

- **`CLAUDE.md`** — 4 conflict points aligned to this file:

  | §   | Before                                                  | Now                                                                                            | Evidence                                      |
  |-----|---------------------------------------------------------|------------------------------------------------------------------------------------------------|-----------------------------------------------|
  | §2  | verb-first event name (`GetXxxEvent`)                   | `<Feature><Verb>Event`                                                                         | 8/9 in code                                   |
  | §2  | state name alternative `XxxLoadedState`/`XxxErrorState` | only `Initial/Loading/Success/Failure`; grouped sealed example changed to `profile_state.dart` | `Loaded`/`Error` 0 in code                    |
  | §10 | usecase `final class`                                   | unmodified `class` + which type the `final` policy covers, spelled out                         | usecase 0/11, entity 0/10, model 0/10 `final` |
  | §12 | `context.textStyle.*` first                             | `context.textTheme.*` first                                                                    | 38 vs 2                                       |

  Matching adjustments (inside those same code blocks, so no contradiction remains):
  §2 example `GetFeatureEvent` → `FeatureLoadEvent`; §10 example
  `const FeatureEntity(...)` / `const FeatureRepository()` / `const GetFeature(...)` →
  `const new(...)` (repo convention, 199 vs 15).

  Remaining loose end in `CLAUDE.md`: the handler examples in §2 (`_getProfileHandler`,
  `_sendOtpHandler`) don't exist verbatim in the code — the real names are `_getProfileUserHandler`,
  `_otpLoginHandler`. The rule itself (`_<...>Handler`, 10/10) is correct, only the examples
  are approximate. Left as is.

## 12. Migration list

See `.claude/rules/migration-list.md`. Nothing was fixed at this stage.
