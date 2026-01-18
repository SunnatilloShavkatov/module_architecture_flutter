# Module Architecture Mobile

A production-ready Flutter application built with Clean Architecture, modular monorepo structure, and feature-first design principles.

## Overview

This project demonstrates a scalable Flutter architecture that separates concerns across three distinct layers (Data, Domain, Presentation) while maintaining strict module boundaries. Each feature module is self-contained and can be developed, tested, and maintained independently.

## Architecture

The project follows **Clean Architecture** principles with a modular monorepo structure:

- **3-Layer Architecture**: Data → Domain → Presentation
- **Feature Modules**: Self-contained modules (auth, home, main, more, etc.)
- **Shared Packages**: Reusable components and core functionality
- **Dependency Injection**: GetIt via `merge_dependencies` package
- **State Management**: BLoC pattern with sealed classes
- **Navigation**: GoRouter with module-based routing

For detailed architecture documentation, see [docs/architecture/overview.md](docs/architecture/overview.md).

## Project Structure

```
module_architecture_mobile/
├── lib/                    # App entry point
│   ├── main.dart          # Application bootstrap
│   └── app.dart           # MaterialApp configuration
│
├── modules/               # Feature modules (Clean Architecture)
│   ├── auth/             # Authentication module
│   ├── home/             # Home feature module
│   ├── initial/         # Initial screens (splash, welcome)
│   ├── main/             # Main navigation shell
│   ├── more/             # More/Settings module
│   └── system/           # System pages (404, no internet)
│
├── packages/              # Shared packages
│   ├── components/       # Reusable UI components
│   ├── core/             # Core functionality (network, DI, errors)
│   ├── merge_dependencies/# Dependency aggregator (app entry only)
│   ├── navigation/       # Routing & navigation utilities
│   └── platform_methods/ # Platform-specific implementations
│
└── docs/                  # Project documentation
```

## Stack & Dependencies

### Core Dependencies
- **flutter_bloc**: State management
- **get_it**: Dependency injection
- **go_router**: Declarative routing
- **dio**: HTTP client
- **equatable**: Value equality
- **hive**: Local storage

### Architecture Packages
- **core**: Network provider, error handling, DI abstractions, extensions
- **components**: UI components, theme, dimensions
- **navigation**: Route definitions, navigation utilities
- **merge_dependencies**: Dependency aggregator (used only in `main.dart`)

## Module Structure

Each module follows Clean Architecture with three layers:

```
module_name/
├── lib/
│   ├── module_name.dart          # Public API (exports Container)
│   └── src/
│       ├── module_name_container.dart  # Module registration
│       ├── data/                 # Data Layer
│       │   ├── datasource/       # Remote & Local data sources
│       │   ├── models/           # Data models (JSON serialization)
│       │   └── repo/             # Repository implementations
│       ├── di/                   # Dependency Injection
│       │   └── module_name_injection.dart
│       ├── domain/               # Domain Layer
│       │   ├── entities/         # Business entities (pure Dart)
│       │   ├── repo/             # Repository abstractions
│       │   └── usecases/         # Business logic use cases
│       ├── presentation/         # Presentation Layer
│       │   └── feature_name/
│       │       ├── bloc/         # BLoC files (events, states, bloc)
│       │       ├── widgets/      # Feature-specific widgets
│       │       └── feature_page.dart
│       └── router/               # Module routing
│           └── module_name_router.dart
└── pubspec.yaml
```

## Dependency Rules

### Package Dependency Hierarchy

```
main.dart (app entry point)
  └── merge_dependencies (aggregates all)
      ├── core (core functionality)
      ├── components (UI components)
      ├── navigation (routing)
      └── modules (feature modules)
```

### Import Rules

- **In `main.dart`**: Use `merge_dependencies` package
- **In modules**: Import packages directly (`core`, `components`, `navigation`)
- **Never**: Import `merge_dependencies` in modules

See [docs/architecture/dependency_injection.md](docs/architecture/dependency_injection.md) for details.

## State Management

The project uses **BLoC pattern** with sealed classes:

- **Events**: Sealed classes extending `Equatable`
- **States**: Sealed classes extending `Equatable`
- **BLoC**: Calls use cases only (never repositories directly)
- **Error Handling**: Either pattern (`ResultFuture<T>`)

Example:

```dart
sealed class LoginEvent extends Equatable {
  const LoginEvent();
}

final class LoginSubmitted extends LoginEvent {
  const LoginSubmitted({required this.username, required this.password});
  final String username;
  final String password;
  @override
  List<Object?> get props => [username, password];
}
```

See `flutter-rules.md` for complete BLoC patterns (TODO: add docs/presentation_layer/bloc.md).

## Navigation

Navigation is handled by **GoRouter** with module-based routing:

- Each module defines its routes via `AppRouter<RouteBase>` interface
- Routes are aggregated in `merge_dependencies`
- Route names are centralized in `Routes` class (`navigation` package)

Example:

```dart
final class AuthRouter implements AppRouter<RouteBase> {
  @override
  List<GoRoute> getRouters(Injector di) => [
    GoRoute(
      path: Routes.login,
      name: Routes.login,
      builder: (context, state) => const LoginPage(),
    ),
  ];
}
```

See `flutter-rules.md` for routing details (TODO: add docs/presentation_layer/navigation.md).

## Error Handling

The project uses **Either pattern** for error handling:

- `ResultFuture<T> = Future<Either<Failure, T>>`
- `Left<Failure>` represents errors
- `Right<T>` represents success
- Exceptions are converted to `Failure` objects in repositories

See `flutter-rules.md` for error handling patterns (TODO: add docs/conventions/error_handling.md).

## Adding a New Module

1. Create module directory: `modules/new_module/`
2. Create `pubspec.yaml` with dependencies:
   ```yaml
   dependencies:
     core:
       path: ../../packages/core
     components:
       path: ../../packages/components
     navigation:
       path: ../../packages/navigation
   ```
3. Implement Clean Architecture layers:
   - `data/`: Data sources, models, repository implementations
   - `domain/`: Entities, repository abstractions, use cases
   - `presentation/`: BLoC, pages, widgets
   - `router/`: Route definitions
4. Create `ModuleContainer` and `Injection`:
   ```dart
   final class NewModuleContainer implements ModuleContainer {
     @override
     Injection? get injection => const NewModuleInjection();
     @override
     AppRouter<RouteBase>? get router => const NewModuleRouter();
   }
   ```
5. Register in `merge_dependencies`:
   ```dart
   static const List<ModuleContainer> _allContainer = [
     // ... existing modules
     NewModuleContainer(),
   ];
   ```

See [docs/architecture/module_structure.md](docs/architecture/module_structure.md) for step-by-step guide.

## Development

### Prerequisites

- Flutter SDK >=3.38.0
- Dart SDK >=3.10.0 <4.0.0

### Running the App

```bash
flutter pub get
flutter run
```

### Code Style

The project follows strict code style rules defined in `flutter-rules.md`:

- File naming: `snake_case.dart`
- Class naming: `PascalCase`
- Variables: `camelCase`
- Use `analysis_lints: ^1.0.5` for linting

See `flutter-rules.md` for complete naming and code style conventions (TODO: add docs/conventions/).

## Documentation

Complete documentation is available in the `docs/` folder:

### Architecture Documentation
- [Architecture Overview](docs/architecture/overview.md)
- [Clean Architecture](docs/architecture/clean_architecture.md)
- [Module Structure](docs/architecture/module_structure.md)
- [Dependency Injection](docs/architecture/dependency_injection.md)

### Domain Layer
- [Entities](docs/domain_layer/entities.md)
- [Repositories](docs/domain_layer/repositories.md)
- [Use Cases](docs/domain_layer/usecases.md)

### Additional Documentation
For complete coding rules and conventions, see [flutter-rules.md](flutter-rules.md).

**TODO**: Additional documentation to be added:
- Data Layer (datasources, models, repository implementations)
- Presentation Layer (BLoC patterns, navigation, pages)
- Conventions (naming, code style, error handling)
- Getting Started guide
- FAQ

## Key Principles

1. **Separation of Concerns**: Each layer has a single responsibility
2. **Dependency Rule**: Dependencies point inward (Presentation → Domain → Data)
3. **Module Isolation**: Modules are self-contained and communicate via interfaces
4. **Testability**: Business logic is independent of frameworks
5. **Scalability**: New features are added as new modules

## License

[Add your license here]
