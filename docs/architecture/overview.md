# Architecture Overview

This document provides a high-level overview of the application architecture, design principles, and structural decisions.

## Architecture Pattern

The project follows **Clean Architecture** principles, organizing code into three distinct layers:

1. **Presentation Layer**: UI, user interactions, state management
2. **Domain Layer**: Business logic, entities, use cases
3. **Data Layer**: API communication, local storage, data transformation

## Design Principles

### 1. Dependency Rule

Dependencies point **inward**:

```
Presentation → Domain ← Data
```

- Presentation depends on Domain
- Data depends on Domain
- Domain has **no dependencies** on other layers

### 2. Module Isolation

Each feature module is **self-contained**:

- Own data sources, repositories, use cases, BLoCs
- Own routing configuration
- Own dependency injection setup
- Communicates with other modules via interfaces only

### 3. Single Responsibility

Each component has one clear purpose:

- **Data Sources**: Fetch data from a single source (remote or local)
- **Repositories**: Coordinate data sources, transform data
- **Use Cases**: Execute a single business operation
- **BLoCs**: Manage state for a single page/feature

### 4. Testability

Business logic is **framework-independent**:

- Domain layer has no Flutter dependencies
- Use cases are pure Dart functions
- Entities are immutable data classes
- Easy to unit test without UI framework

### 5. Monorepo Boundaries

This codebase is a **modular monorepo**. Keep boundaries strict:

- Feature implementation stays inside the target module.
- Shared reusable logic goes to `packages/`.
- Avoid direct cross-module coupling unless explicitly required by interface contracts.
- Keep module-local naming conventions consistent (`repo`/`repository`, `repos`/`repository` based on the module style).

### 6. Quality Gates

Before finalizing code changes in a touched scope:

1. run `dart fix --apply`
2. run `dart format ./`
3. run analyzer (`flutter analyze` or `dart analyze`)

Lint baseline:

- `analysis_lints: any` (latest strategy)
- `analysis_options.yaml` should include `package:analysis_lints/analysis_options.yaml`

## Project Structure

### Root Level

```
module_architecture_mobile/
├── lib/              # Application entry point
├── modules/          # Feature modules
├── packages/         # Shared packages
└── docs/             # Documentation
```

### Module Structure

Each module follows the same Clean Architecture structure:

```
module_name/
├── lib/
│   ├── module_name.dart              # Public API
│   └── src/
│       ├── module_name_container.dart
│       ├── data/                    # Data Layer
│       ├── domain/                   # Domain Layer
│       ├── presentation/              # Presentation Layer
│       ├── router/                   # Routing
│       └── di/                       # Dependency Injection
└── pubspec.yaml
```

### Package Structure

Shared packages provide reusable functionality:

- **core**: Network, error handling, DI abstractions, extensions
- **components**: UI components, theme, dimensions
- **navigation**: Route definitions, navigation utilities
- **merge_dependencies**: Dependency aggregator (app entry only)

## Layer Responsibilities

### Presentation Layer

**Purpose**: Handle user interface and user interactions

**Contains**:
- Pages (full screens)
- Widgets (reusable UI components)
- BLoCs (state management)
- Mixins (shared page behavior)

**Rules**:
- BLoC calls use cases only (never repositories)
- Pages are stateless when possible
- UI logic stays in presentation layer

### Domain Layer

**Purpose**: Business logic and rules

**Contains**:
- Entities (immutable business objects)
- Repository abstractions (interfaces)
- Use cases (business operations)

**Rules**:
- No framework dependencies
- Pure Dart code only
- Entities extend `Equatable`
- Use cases return `ResultFuture<T>`

### Data Layer

**Purpose**: Data fetching and persistence

**Contains**:
- Data sources (remote, local)
- Models (JSON serialization)
- Repository implementations

**Rules**:
- Data sources are abstract interfaces
- Models extend entities
- API mapping contract: list fields non-null, scalar/object fields nullable by default
- Repository implementations convert exceptions to `Failure`

## Dependency Flow

### Within a Module

```
Presentation (BLoC)
    ↓ calls
Domain (UseCase)
    ↓ calls
Domain (Repository interface)
    ↑ implements
Data (Repository implementation)
    ↓ uses
Data (Data Sources)
```

### Between Modules

Modules communicate via:

1. **Shared packages** (`core`, `components`, `navigation`)
2. **Repository interfaces** (if cross-module data access needed)
3. **Navigation** (route-based communication)

## State Management

**Pattern**: BLoC with sealed classes

- Events: Sealed classes extending `Equatable`
- States: Sealed classes extending `Equatable`
- BLoC: Manages state transitions, calls use cases

**Flow**:
```
UI Event → BLoC Event → UseCase → Repository → Data Source
                                                      ↓
UI State ← BLoC State ← Either<Failure, T> ← Repository ←
```

## Error Handling

**Pattern**: Either monad

- `ResultFuture<T> = Future<Either<Failure, T>>`
- `Left<Failure>`: Error case
- `Right<T>`: Success case
- Exceptions converted to `Failure` in data layer

## Dependency Injection

**Pattern**: GetIt via `merge_dependencies`

- Each module defines its own `Injection` class
- Modules register dependencies in `registerDependencies()`
- `merge_dependencies` aggregates all module registrations
- Registration happens once at app startup

## Navigation

**Pattern**: GoRouter with module-based routing

- Each module defines routes via `AppRouter<RouteBase>`
- Routes aggregated in `merge_dependencies`
- Route names centralized in `Routes` class
- Deep linking and navigation state handled by GoRouter

## Key Benefits

1. **Maintainability**: Clear separation of concerns
2. **Testability**: Business logic independent of UI
3. **Scalability**: Easy to add new features as modules
4. **Team Collaboration**: Teams can work on different modules independently
5. **Code Reusability**: Shared packages provide common functionality

## Next Steps

- [Clean Architecture Details](clean_architecture.md)
- [Module Structure](module_structure.md)
- [Module Selection](module_selection.md)
- [New Module Creation](new_module_creation.md)
- [Dependency Injection](dependency_injection.md)
- [Project Map](project_map.md)
- [Presentation Plan](../presentation_layer/page_bloc_widget_mixin_plan.md)
- [Reference Best Practices](../presentation_layer/reference_best_practices.md)
