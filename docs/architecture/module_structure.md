# Module Structure

This document explains the structure of feature modules, their organization, and how they integrate with the application.

## Module Concept

A **module** is a self-contained feature that follows Clean Architecture principles. Each module:

- Has its own data, domain, and presentation layers
- Defines its own routes
- Registers its own dependencies
- Can be developed and tested independently

## Module Directory Structure

```
module_name/
├── lib/
│   ├── module_name.dart                    # Public API export
│   └── src/
│       ├── module_name_container.dart      # Module registration
│       │
│       ├── data/                           # Data Layer
│       │   ├── datasource/
│       │   │   ├── module_name_remote_data_source.dart
│       │   │   ├── module_name_remote_data_source_impl.dart
│       │   │   ├── module_name_local_data_source.dart
│       │   │   └── module_name_local_data_source_impl.dart
│       │   ├── models/
│       │   │   └── module_name_model.dart
│       │   └── repo/                       # or repository/
│       │       └── module_name_repo_impl.dart
│       │
│       ├── domain/                         # Domain Layer
│       │   ├── entities/
│       │   │   └── module_name_entity.dart
│       │   ├── repo/                       # or repository/
│       │   │   └── module_name_repo.dart
│       │   └── usecases/
│       │       └── get_module_data.dart
│       │
│       ├── presentation/                   # Presentation Layer
│       │   └── feature_name/
│       │       ├── bloc/
│       │       │   ├── feature_name_bloc.dart
│       │       │   ├── feature_name_event.dart
│       │       │   └── feature_name_state.dart
│       │       ├── widgets/
│       │       │   └── feature_widget.dart
│       │       └── feature_name_page.dart
│       │
│       ├── router/
│       │   └── module_name_router.dart
│       │
│       └── di/
│           └── module_name_injection.dart
│
└── pubspec.yaml
```

## Module Public API

### module_name.dart

The main export file that exposes the module's public API:

```dart
export 'src/module_name_container.dart' show ModuleNameContainer;
```

**Purpose**: Other parts of the app only need to import the container to register the module.

**Example** (`modules/auth/lib/auth.dart`):
```dart
export 'src/auth_container.dart' show AuthContainer;
```

## Module Container

### module_name_container.dart

The container implements `ModuleContainer` and provides:

1. **Injection**: Dependency registration
2. **Router**: Route definitions

```dart
final class AuthContainer implements ModuleContainer {
  const AuthContainer();

  @override
  Injection? get injection => const AuthInjection();

  @override
  AppRouter<RouteBase>? get router => const AuthRouter();
}
```

**Purpose**: Allows `merge_dependencies` to discover and register all modules automatically.

## Dependency Injection

### di/module_name_injection.dart

Registers all module dependencies:

```dart
final class AuthInjection implements Injection {
  const AuthInjection();

  @override
  FutureOr<void> registerDependencies({required Injector di}) {
    di
      // Data sources
      ..registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(di.get())
      )
      ..registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(di.get())
      )
      // Repositories
      ..registerLazySingleton<AuthRepo>(
        () => AuthRepoImpl(di.get(), di.get())
      )
      // Use cases
      ..registerLazySingleton<Login>(() => Login(di.get()))
      // BLoCs
      ..registerFactory(() => LoginBloc(di.get()));
  }
}
```

**Registration Order**:
1. Data sources (lowest level)
2. Repositories
3. Use cases
4. BLoCs (highest level)

**Registration Types**:
- `registerLazySingleton`: Data sources, repositories, use cases
- `registerFactory`: BLoCs, pages (created on demand)

## Routing

### router/module_name_router.dart

Defines module routes:

```dart
final class AuthRouter implements AppRouter<RouteBase> {
  const AuthRouter();

  @override
  List<GoRoute> getRouters(Injector di) => [
    GoRoute(
      path: Routes.login,
      name: Routes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: Routes.forgotPassword,
      name: Routes.forgotPassword,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
  ];
}
```

**Rules**:
- Use `Routes` constants from `navigation` package
- Routes are aggregated by `merge_dependencies`
- Each module defines its own routes independently

## Module Registration

Modules are registered in `merge_dependencies`:

```dart
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

**Process**:
1. `merge_dependencies` collects all containers
2. Extracts injections and routers
3. Registers dependencies at app startup
4. Aggregates routes for GoRouter

## Module Dependencies

### pubspec.yaml

Each module declares its dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  # Shared packages
  core:
    path: ../../packages/core
  components:
    path: ../../packages/components
  navigation:
    path: ../../packages/navigation
  # Other modules (only if needed)
  other_module:
    path: ../../modules/other_module
```

**Rules**:
- ✅ Always depend on `core`, `components`, `navigation`
- ✅ Can depend on other modules if needed
- ❌ Never depend on `merge_dependencies` (app entry only)

## Module Communication

Modules communicate via:

### 1. Shared Packages

All modules use shared packages (`core`, `components`, `navigation`):

```dart
import 'package:core/core.dart';
import 'package:components/components.dart';
import 'package:navigation/navigation.dart';
```

### 2. Navigation

Modules navigate to each other via routes:

```dart
// In AuthModule
Navigator.pushNamed(context, Routes.mainHome);
```

### 3. Repository Interfaces (if needed)

If modules need to share data:

```dart
// Module A exposes repository interface
abstract interface class SharedRepo {
  ResultFuture<SharedData> getData();
}

// Module B implements it
final class SharedRepoImpl implements SharedRepo {
  // Implementation
}
```

**Note**: Cross-module data access should be minimal. Prefer navigation-based communication.

## Module Isolation

Each module is **isolated**:

- ✅ Own data sources, repositories, use cases
- ✅ Own BLoCs and pages
- ✅ Own routing configuration
- ✅ Own dependency injection

**Benefits**:
- Teams can work independently
- Easy to test in isolation
- Easy to remove or refactor modules
- Clear feature boundaries

## Existing Modules

### auth
Authentication module (login, forgot password, confirm code)

### home
Home feature module

### initial
Initial screens (splash, welcome)

### main
Main navigation shell with bottom navigation

### more
More/Settings module

### system
System pages (404, no internet)

## Creating a New Module

Follow these step-by-step instructions:

### Step 1: Create Module Structure

Create the module directory and basic structure:

```bash
mkdir -p modules/new_module/lib/src/{data/{datasource,models,repo},domain/{entities,repo,usecases},presentation,router}
```

### Step 2: Create pubspec.yaml

```yaml
name: new_module
publish_to: 'none'

environment:
  sdk: '>=3.10.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  core:
    path: ../../packages/core
  components:
    path: ../../packages/components
  navigation:
    path: ../../packages/navigation
```

### Step 3: Implement Domain Layer

1. Create entities in `domain/entities/`
2. Define repository abstracts in `domain/repo/`
3. Implement use cases in `domain/usecases/`

### Step 4: Implement Data Layer

1. Create data sources in `data/datasource/`
2. Create models in `data/models/`
3. Implement repositories in `data/repo/`

### Step 5: Implement Presentation Layer

1. Create BLoC files in `presentation/feature_name/bloc/`
2. Create pages and widgets

### Step 6: Setup Dependency Injection

Create `di/new_module_injection.dart`:

```dart
final class NewModuleInjection implements Injection {
  const NewModuleInjection();

  @override
  FutureOr<void> registerDependencies({required Injector di}) {
    // Register data sources
    di.registerLazySingleton<NewModuleRemoteDataSource>(
      () => NewModuleRemoteDataSourceImpl(di.get()),
    );
    
    // Register repositories
    di.registerLazySingleton<NewModuleRepo>(
      () => NewModuleRepoImpl(di.get()),
    );
    
    // Register use cases
    di.registerLazySingleton<GetNewModuleData>(
      () => GetNewModuleData(di.get()),
    );
    
    // Register BLoCs
    di.registerFactory(
      () => NewModuleBloc(di.get()),
    );
  }
}
```

### Step 7: Create Router

Create `router/new_module_router.dart`:

```dart
final class NewModuleRouter implements AppRouter<RouteBase> {
  const NewModuleRouter();

  @override
  List<GoRoute> getRouters(Injector di) => [
    GoRoute(
      path: Routes.newModule,
      name: Routes.newModule,
      builder: (context, state) => const NewModulePage(),
    ),
  ];
}
```

### Step 8: Create Module Container

Create `lib/src/new_module_container.dart`:

```dart
final class NewModuleContainer implements ModuleContainer {
  const NewModuleContainer();

  @override
  Injection? get injection => const NewModuleInjection();

  @override
  AppRouter<RouteBase>? get router => const NewModuleRouter();
}
```

### Step 9: Export Public API

Create `lib/new_module.dart`:

```dart
library new_module;

export 'src/new_module_container.dart';
```

### Step 10: Register in merge_dependencies

Add to `merge_dependencies/lib/src/merge_dependencies.dart`:

```dart
static const List<ModuleContainer> _allContainer = [
  // ... existing containers
  NewModuleContainer(),
];
```

## Best Practices

1. **Keep modules focused**: One feature per module
2. **Minimize cross-module dependencies**: Prefer navigation over direct imports
3. **Follow naming conventions**: `snake_case` for files, `PascalCase` for classes
4. **Export only container**: Public API should be minimal
5. **Register in merge_dependencies**: Add container to `_allContainer` list

## Next Steps

- [Dependency Injection](dependency_injection.md)
- [Domain Layer](../domain_layer/entities.md)
