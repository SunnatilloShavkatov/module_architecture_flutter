# New Module Creation Guide

Use this guide when no existing module owns a feature.

## 1. Preconditions

Create a new module only after applying:

- `docs/architecture/module_selection.md`

If owner module exists, do not create a new module.

## 2. Naming

Use `snake_case` module name.

Example: `notifications`

## 3. Create Folder Structure

```bash
mkdir -p modules/<module>/lib/src/{data/{datasource,models,repository},domain/{entities,repository,usecases},presentation,di,router}
mkdir -p modules/<module>/test
```

## 4. Create Required Module Entry Files

### `modules/<module>/lib/<module>.dart`

```
export 'src/<module>_container.dart' show <ModulePascal>Container;
```

### `modules/<module>/lib/src/<module>_container.dart`

```
import 'package:core/core.dart' show AppRouter, Injection, ModuleContainer;
import 'package:flutter/widgets.dart' show RouteBase;

import 'di/<module>_injection.dart';
import 'router/<module>_router.dart';

final class <ModulePascal>Container implements ModuleContainer {
  const <ModulePascal>Container();

  @override
  Injection? get injection => const <ModulePascal>Injection();

  @override
  AppRouter<RouteBase>? get router => const <ModulePascal>Router();
}
```

### `modules/<module>/lib/src/di/<module>_injection.dart`

- registerLazySingleton: data sources, repositories, use cases
- registerFactory: blocs

### `modules/<module>/lib/src/router/<module>_router.dart`

- use GoRouter named routes only
- inject pages/blocs using `di.get<Type>()`

## 5. Create Module Config Files

### `modules/<module>/pubspec.yaml`

Minimum:

- flutter sdk dependency
- shared packages: `core`, `components`, `navigation`
- dev dependency: `analysis_lints: any` (latest strategy)

### `modules/<module>/analysis_options.yaml`

```yaml
include: package:analysis_lints/analysis_options.yaml
```

## 6. Implement Feature in Mandatory Order

1. domain: entity -> repository interface -> use case
2. data: model -> datasource -> repository impl
3. presentation: bloc -> page + mixin -> widgets
4. DI: register all dependencies
5. router: add routes and args

## 7. Register Module in Aggregator

Update `packages/merge_dependencies/lib/merge_dependencies.dart`:

1. add import for new module package
2. add `<ModulePascal>Container()` into `_allContainer`

Without this step, module DI and routes are not loaded.

## 8. Required Quality Commands

Run in touched scope before finalizing:

1. `dart fix --apply`
2. `dart format ./`
3. `flutter analyze` (or `dart analyze`)

## 9. Completion Checklist

- [ ] module ownership confirmed as "no existing owner"
- [ ] module folder and entry files created
- [ ] module `pubspec.yaml` and `analysis_options.yaml` created
- [ ] domain/data/presentation implemented in order
- [ ] DI and router wired
- [ ] module added to merge dependencies `_allContainer`
- [ ] fix/format/analyze completed without unresolved issues
