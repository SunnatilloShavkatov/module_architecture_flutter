# CLAUDE.md — Canonical AI Instructions

This file is the single source of truth for architecture rules. Do not follow a module's local
style if it conflicts with the rules below — the rules below are correct, not every existing
module is. `AGENTS.md` only adds output-formatting notes on top of this file.

## 0. Mandatory Docs Read (agents keep skipping this — stop skipping it)

`docs/` is not optional background reading. Before touching a task in the listed category,
open the file — don't rely on memory of this summary, the doc has edge cases this file omits.

| Task involves | Open before coding |
|---|---|
| any new entity | `docs/domain_layer/entities.md` |
| any new repository interface | `docs/domain_layer/repositories.md` |
| any new usecase | `docs/domain_layer/usecases.md` |
| any new model / `fromMap`/`toMap` | `docs/data_layer/models.md` |
| any bloc/event/state/page/mixin | `docs/presentation_layer/page_bloc_widget_mixin_plan.md` |
| any `components`/`core` widget or token use | `docs/presentation_layer/components_core_usage.md` |
| picking which module owns a feature | `docs/architecture/module_selection.md` (map drifts — cross-check `ls modules/`) |
| creating a brand-new module | `docs/architecture/new_module_creation.md` |
| unsure where a file goes | `docs/architecture/project_map.md` |
| DI/GetIt registration | `docs/architecture/dependency_injection.md` |
| general layering doubt | `docs/architecture/clean_architecture.md`, `docs/architecture/overview.md` |

`docs/architecture/solid_standards.md` and `docs/presentation_layer/reference_best_practices.md` are supplementary — read when the task is non-trivial (new module, ambiguous ownership), skip for small mechanical additions.

## 1. Reference Priority (fixes "clone wrong module" problem)

1. **`docs/TEMPLATE_REFERENCE.md`** — always correct, always current. Primary reference for syntax/structure.
2. **`docs/presentation_layer/page_bloc_widget_mixin_plan.md`** — mandatory for any bloc/event/state/page/mixin work. Rules inlined below too, but the doc is authoritative on edge cases.
3. An existing module (`modules/auth`, etc.) — use only for finding local folder-naming (`repo` vs `repository`). Never copy its bloc/state naming if it disagrees with sections 2–3 below — older modules may predate the current convention.

Never invent a fourth pattern. Never mix patterns from different modules in one feature.

## 2. Bloc / Event / State — Strict Naming (non-negotiable)

```
part 'feature_event.dart';
part 'feature_state.dart';

final class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  FeatureBloc(this._useCase) : super(const FeatureInitialState()) {
    on<GetFeatureEvent>(_getFeatureHandler, transformer: droppable());
  }
  final GetFeature _useCase;

  Future<void> _getFeatureHandler(GetFeatureEvent event, Emitter<FeatureState> emit) async { ... }
}
```

- bloc class: `final class`
- root `Event`/`State`: `sealed class extends Equatable`
- concrete event/state: `final class`
- handler method: **`_<verb><Target>Handler`** — e.g. `_getProfileHandler`, `_sendOtpHandler`. **NEVER `_onXxx`.**
- event names: `GetXxxEvent`, `CreateXxxEvent`, `UpdateXxxEvent`, `DeleteXxxEvent`, `ResetXxxEvent`, `SendXxxEvent` — verb-first, explicit target, `Event` suffix always.
- state names: `XxxInitialState`, `XxxLoadingState`, `XxxLoadedState`/`XxxSuccessState`, `XxxErrorState`/`XxxFailureState`. Multi-flow pages: grouped sealed states (`XxxInfoState`, `XxxCodeState`) — see plan doc §3.4.
- every concrete state overrides `props` even if empty (`=> []`).
- transformer required on every `on<Event>()` call, pick deliberately:
  - `droppable()` — repeated load events, ignore duplicates while running
  - `throttle()` — button-triggered, rate-limit
  - `debounce()` — search/filter typing
  - `sequential()` — order-dependent

Before writing a new bloc: grep the target module for an existing bloc, confirm it already follows this. If it doesn't, **do not copy it** — write the new one correctly and flag the mismatch instead of propagating it.

## 3. File Placement

```
modules/<module>/lib/src/presentation/<feature>/
  <feature>_page.dart
  bloc/<feature>_bloc.dart | _event.dart | _state.dart
  mixin/<feature>_mixin.dart
  widgets/*.dart
```

Page: `StatefulWidget`, dispatch initial event in `initState()`, `BlocListener` for side effects, `BlocBuilder` for render, `buildWhen`/`listenWhen` set explicitly. Mixin: `part of` page, holds controllers/focus/timers, `_handleStates` listener, disposes everything, exposes `FeatureBloc get bloc => context.read<FeatureBloc>();`. Widgets: `StatelessWidget`, constructor-only data, no repo/datasource access.

## 4. Cross-Module Reuse — `ModuleInteractor` (mandatory, not optional)

Problem this solves: a usecase in `auth` needed by `profile` → do **not** import auth's usecase directly into profile (creates compile-time module coupling). Instead:

- Define the shared operation as `ModuleInteractor<T, P>` (`packages/core/lib/src/core_abstractions/module_interactor.dart`) implementation in the **owning** module.
- Register it in the owning module's injection with an `instanceName` (add key to `packages/core/lib/src/constants/instance_name_keys.dart`).
- Consuming module resolves it via `di.get<ModuleInteractor<T, P>>(instanceName: InstanceNameKeys.xxx)` — no import of the owning module's package.

If you catch yourself adding another module's package to `pubspec.yaml` just to reuse one usecase, stop — that's the `ModuleInteractor` case.

## 5. Cross-Module Pages — `PageFactory` (mandatory, not optional)

Reference implementation, confirmed correct: `modules/main/lib/src/router/main_router.dart`.

- Module exposes its page via `final class XxxPageFactory implements PageFactory { Widget create(Injector di) => BlocProvider(...); }`.
- Registered in owning module's injection: `di.registerFactory<PageFactory>(XxxPageFactory.new, instanceName: InstanceNameKeys.xxxFactory)`.
- Consumer (e.g. `main`'s router/shell) resolves with `di.get<PageFactory>(instanceName: InstanceNameKeys.xxxFactory).create(di)` and **never imports the page/bloc classes directly**.
- Check consumer's `pubspec.yaml` after: it must NOT list the produced module as a dependency. If it does, the factory pattern was bypassed — fix it.

## 6. Domain Layer Contract (non-negotiable)

```dart
// entity — no JSON, no fromMap/toMap, extends Equatable, all fields final
class FeatureEntity extends Equatable {
  const FeatureEntity({required this.id, required this.items});
  final String? id;              // scalar/object fields: nullable
  final List<ItemEntity> items;  // list fields: non-null, required
  @override
  List<Object?> get props => [id, items];
}

// repository — abstract interface class, returns ResultFuture<T>, no impl body
abstract interface class FeatureRepository {
  const FeatureRepository();
  ResultFuture<FeatureEntity> getFeature();
}

// usecase — final class, extends UsecaseWithParams/UsecaseWithoutParams, one operation, depends on interface not impl
final class GetFeature extends UsecaseWithoutParams<FeatureEntity> {
  const GetFeature(this._repo);
  final FeatureRepository _repo;
  @override
  ResultFuture<FeatureEntity> call() => _repo.getFeature();
}
```

- entity naming: `Xxx` folder-local convention aside, suffix `Entity` when disambiguation needed, otherwise follow module's existing style.
- repo interface naming: `repo`/`repository`/`repos` — match the target module's existing style, don't mix within one module (see `docs/architecture/module_structure.md §3`).
- one usecase = one business operation. Never bundle two operations in one usecase class.

## 7. Data Layer Contract (non-negotiable)

```dart
class FeatureModel extends FeatureEntity {
  const FeatureModel({required super.id, required super.items});

  factory FeatureModel.fromMap(Map<String, dynamic> map) {
    final items = <ItemModel>[];
    if (map['items'] is List) {
      for (final item in map['items'] as List) {
        if (item is Map<String, dynamic>) items.add(ItemModel.fromMap(item));
      }
    }
    return FeatureModel(id: map['id'] as String?, items: items);
  }

  Map<String, dynamic> toMap() => {'id': id, 'items': items.map((e) => (e as ItemModel).toMap()).toList()};
}
```

- model extends entity, never the reverse.
- `fromMap`/`toMap` live in model only — never in entity/bloc/page/widget.
- list fields: initialize empty, only iterate if runtime type is `List`, type-check each element before parsing.
- scalar fields: nullable cast (`as String?`), no invented fallback (`''`, `0`) unless a stated business rule requires it.
- module-local API paths only: `final class <Feature>ApiPaths { const <Feature>ApiPaths._(); static const String x = '/...'; }` inside that module's `data/datasource/`. Never add to a shared/global `ApiPaths`.
- datasource impl catches `ServerException`/`Exception`/`Error`, converts to `ServerException.*`; repo impl converts `ServerException` → `Failure` via `Left`.

## 8. Component/Core Usage (presentation layer only)

- import only `package:components/components.dart` and `package:core/core.dart` — never `.../src/...`.
- colors: `context.color.*` first, `context.colorScheme.*` for Material interop, hardcoded `Colors.*` only when no token exists.
- text: `context.textStyle.*` first, avoid ad-hoc `TextStyle(...)`.
- spacing: `Dimensions.kGap*`/`Gap(...)`/`Dimensions.kPadding*` — avoid raw `EdgeInsets`/`SizedBox` when a token exists.
- safe area: `SafeAreaWithMinimum`, not plain `SafeArea`, unless explicitly not wanted.
- primary/submit buttons: `CustomLoadingButton` (built-in double-tap throttle), not raw `ElevatedButton`.
- full-screen async block: `ModalProgressHUD`.
- all user-facing text: `context.l10n.<key>` — never a hardcoded string.
- navigation: `GoRouter` named routes only (`context.pushNamed`/`goNamed`/`pop`). No `Navigator 1.0`.
- forbidden APIs anywhere in module code: `Navigator.push`/`Navigator.pop` (use GoRouter), `MediaQuery.of(context)` (use `context.width`/`context.height`/`context.padding` extensions), `print()` (use the project logger).

## 9. Package Isolation (verified clean as of now — keep it that way)

`packages/components`, `packages/core`, `packages/navigation`, `packages/platform_methods` must **never** depend on each other or on any `modules/*`. Before adding an import between these four, stop — it's wrong by construction. Shared code that needs to cross them belongs in `core` only, and even `core` must stay dependency-free of the other three.

## 10. Module Ownership & Ordering

- Pick one owner module per feature — see `docs/architecture/module_selection.md` for the ownership map and algorithm.
- Build order inside a module: domain (entity → repo interface → usecase) → data (model → datasource → repo impl) → presentation (bloc → page/mixin → widgets) → DI → router.
- New module: follow `docs/architecture/new_module_creation.md` exactly, and register in `packages/merge_dependencies/lib/merge_dependencies.dart`'s `_allContainer` — skipping this means DI/routes silently don't load.

## 11. DI Rules

- `registerLazySingleton`: datasources, repositories, usecases, `ModuleInteractor` impls.
- `registerFactory`: blocs, `PageFactory` impls.
- Register in dependency order: datasource → repo → usecase → bloc.
- Only public barrel imports (`package:core/core.dart`), never `package:core/src/...`.

## 12. Quality Gate (before calling anything done)

```bash
dart fix --apply
dart format ./
flutter analyze
```

## 13. Definition of Done

- [ ] owner module stated + reason
- [ ] section 1 reference used (not an arbitrary module)
- [ ] bloc/event/state naming matches section 2 exactly, no `_onXxx`
- [ ] cross-module usecase → `ModuleInteractor`, cross-module page → `PageFactory` (sections 4–5), not direct import
- [ ] entity has no `fromMap`/`toMap`, model has both, list fields non-null (§6–7)
- [ ] API endpoints are module-local, not added to a global `ApiPaths` (§7)
- [ ] no forbidden API used: `Navigator 1.0`, `MediaQuery.of(context)`, `print()` (§8)
- [ ] user-facing strings via `context.l10n.*`, not hardcoded (§8)
- [ ] no new dependency added between `components`/`core`/`navigation`/`platform_methods`
- [ ] DI + router wired, module registered in `merge_dependencies` if new
- [ ] fix/format/analyze clean
- [ ] touched files listed
