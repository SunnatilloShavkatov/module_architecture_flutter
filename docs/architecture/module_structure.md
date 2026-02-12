# Module Structure

This document explains how modules are organized in this repository and where new code must be
added.

## 1. Module Concept

A module is a feature boundary with its own:

- presentation files
- DI registration
- routing setup
- optional domain/data layers depending on module responsibility

Business features should keep Clean Architecture layering inside the module.

## 2. Current Entry Pattern in This Repository

For module `<module>`:

- public export: `modules/<module>/lib/<module>.dart`
- container: `modules/<module>/lib/src/<module>_container.dart`
- injection: `modules/<module>/lib/src/di/<module>_injection.dart`
- router: `modules/<module>/lib/src/router/<module>_router.dart`

Use this pattern for new modules. Do not rename existing entry files unless requested.

## 3. Module Directory Template

```
modules/<module>/
  lib/
    <module>.dart
    src/
      <module>_container.dart
      di/
        <module>_injection.dart
      router/
        <module>_router.dart
      data/
        datasource/
        models/
        repo/ or repository/
      domain/
        entities/
        repos/ or repository/
        usecases/
      presentation/
        <feature>/
          <feature>_page.dart
          bloc/
            <feature>_bloc.dart
            <feature>_event.dart
            <feature>_state.dart
          mixin/
            <feature>_mixin.dart
          widgets/
```

Important:

- some modules use `repo`, some use `repository`;
- some modules use `repos`, some use `repository`;
- follow the local style of the target module, do not mix styles in one module.

## 4. Public API Export Rule

Export module container from `lib/<module>.dart`.

Example:

```dart
export 'src/auth_container.dart' show AuthContainer;
```

## 5. DI and Router Ownership

- register module dependencies only in `<module>_injection.dart`;
- define module routes only in `<module>_router.dart`;
- keep module container as the single integration point.

## 6. Where to Add Feature Code

When implementing feature `<feature>` in module `<module>`:

1. domain
    - entity in `domain/entities/`
    - repository interface in `domain/repos/` or `domain/repository/`
    - use case in `domain/usecases/`
2. data
    - model in `data/models/`
        - model mapping contract: list fields non-null, scalar/object fields nullable,
          `fromMap/toMap` mandatory
    - data source in `data/datasource/`
    - repository impl in `data/repo/` or `data/repository/`
3. presentation
    - bloc/event/state in `presentation/<feature>/bloc/`
    - page in `presentation/<feature>/`
    - mixin in `presentation/<feature>/mixin/`
    - widgets in `presentation/<feature>/widgets/`
4. integration
    - DI update in `<module>_injection.dart`
    - route update in `<module>_router.dart`

## 7. Communication Rules

Modules communicate by:

- shared packages (`core`, `components`, `navigation`, `base_dependencies`)
- route navigation (`context.pushNamed`, `context.goNamed`)
- explicit interfaces when cross-module business access is required

Avoid direct tight coupling across modules.

## 8. New Module Checklist

- [ ] module folder and entry files created with `<module>_*` naming
- [ ] presentation/domain/data folders added for business features
- [ ] DI file registers module dependencies
- [ ] router file exposes module routes
- [ ] module container wired to injection + router
- [ ] `lib/<module>.dart` exports module container
