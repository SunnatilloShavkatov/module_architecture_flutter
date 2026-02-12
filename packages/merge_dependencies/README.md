# Merge Dependencies Package

Dependency aggregator and app entry point package for Module Architecture Mobile.

## Overview

The `merge_dependencies` package serves as the central aggregator for all packages and modules. It provides a single entry point for dependency injection and route generation in the main app.

## Purpose

- **Aggregates all packages**: Re-exports `core`, `components`, `navigation`
- **Module registration**: Collects and registers all feature modules
- **Route generation**: Aggregates routes from all modules
- **Environment initialization**: Sets up app environment (dev, prod)

## Installation

**IMPORTANT**: This package should ONLY be used in `main.dart` (app entry point).

In `pubspec.yaml`:

```yaml
dependencies:
  merge_dependencies:
    path: packages/merge_dependencies
```

## Usage

### In main.dart

```
import 'package:merge_dependencies/merge_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize environment
  MergeDependencies.initEnvironment(env: Environment.prod);
  
  // Register all modules and dependencies
  await MergeDependencies.instance.registerModules();
  
  runApp(const App());
}
```

### Route Generation

```
MaterialApp.router(
  routerConfig: MergeDependencies.instance.generateRoutes(),
);
```

## Features

### Module Registration

Automatically registers all feature modules:

```
static const List<ModuleContainer> _allContainer = [
  CoreContainer(),
  AuthContainer(),
  HomeContainer(),
  InitialContainer(),
  MainContainer(),
  MoreContainer(),
  SystemContainer(),
];
```

### Environment Configuration

```
// Development environment
MergeDependencies.initEnvironment(env: Environment.dev);

// Production environment
MergeDependencies.initEnvironment(env: Environment.prod);
```

### Dependency Injection

Aggregates and registers dependencies from all modules:

- Data sources
- Repositories
- Use cases
- BLocs
- Services

### Route Aggregation

Collects routes from all module routers and generates GoRouter configuration.

## Rules

### When to Use

✅ **MUST** use:
- ONLY in `main.dart` (app entry point)
- For module registration
- For route generation
- For environment initialization

### When NOT to Use

❌ **NEVER** use in:
- Feature modules (use `core`, `components`, `navigation` directly)
- Shared packages
- Any file other than `main.dart`

## Import Rules

```
// ✅ Correct - In main.dart
import 'package:merge_dependencies/merge_dependencies.dart';

// ❌ Wrong - In modules
import 'package:merge_dependencies/merge_dependencies.dart';
// Use core, components, navigation directly instead
```

## Package Structure

```
merge_dependencies/
├── lib/
│   ├── merge_dependencies.dart       # Public API
│   └── src/
│       ├── merge_dependencies.dart   # Main implementation
│       └── core_container.dart       # Core package container
└── pubspec.yaml
```

## Adding a New Module

1. Create module container in the module
2. Add to `_allContainer` list in `merge_dependencies.dart`:

```
static const List<ModuleContainer> _allContainer = [
  // ... existing modules
  NewModuleContainer(),
];
```

## Dependencies

This package depends on:
- All shared packages (`core`, `components`, `navigation`)
- All feature modules

## Best Practices

1. **App entry only**: Only import in `main.dart`
2. **Module isolation**: Modules should not depend on this package
3. **Single responsibility**: Use only for aggregation and initialization
4. **Environment setup**: Always initialize environment before registration

## Related Documentation

- [Module Structure](../../docs/architecture/module_structure.md)
- [Dependency Injection](../../docs/architecture/dependency_injection.md)
- [Flutter Rules - Package Usage](../../flutter-rules.md)

## License

[Add your license here]
