# Dependency Injection

This document explains how dependency injection is implemented using GetIt via the `merge_dependencies` package.

## Overview

The project uses **GetIt** for dependency injection, orchestrated through the `merge_dependencies` package. Each module registers its own dependencies, and `merge_dependencies` aggregates them at app startup.

## Injection Pattern

### Core Abstractions

The `core` package provides DI abstractions:

- **`Injection`**: Interface for registering dependencies
- **`Injector`**: Interface for GetIt (dependency container)
- **`ModuleContainer`**: Interface for module registration

### Module Injection

Each module implements `Injection`:

```
final class AuthInjection implements Injection {
  const AuthInjection();

  @override
  FutureOr<void> registerDependencies({required Injector di}) {
    di
      // Data sources
      ..registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(di.get())
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

## Registration Types

### registerLazySingleton

**Use for**: Data sources, repositories, use cases

**Behavior**: Created once on first access, reused afterward

```
di.registerLazySingleton<AuthRepo>(
  () => AuthRepoImpl(di.get(), di.get())
);
```

**When to use**:
- Stateless services
- Expensive to create
- Shared across app lifecycle

### registerFactory

**Use for**: BLoCs

**Behavior**: New instance created each time

```
di.registerFactory(() => LoginBloc(di.get()));
```

**When to use**:
- Stateful components (BLoCs)
- Created on demand
- Different instances needed

### registerSingleton

**Use for**: App lifecycle services

**Behavior**: Created immediately, single instance

```
di.registerSingleton<AppNavigationService>(
  AppNavigationServiceImpl()
);
```

**When to use**:
- Services needed immediately
- App-level singletons
- Global state management

## Registration Order

Dependencies should be registered in **dependency order**:

1. **Data Sources** (lowest level, no dependencies)
2. **Repositories** (depend on data sources)
3. **Use Cases** (depend on repositories)
4. **BLoCs** (depend on use cases)

```
di
  // 1. Data sources
  ..registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(di.get())
  )
  // 2. Repositories
  ..registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(di.get(), di.get())
  )
  // 3. Use cases
  ..registerLazySingleton<Login>(() => Login(di.get()))
  // 4. BLoCs
  ..registerFactory(() => LoginBloc(di.get()));
```

## Dependency Resolution

### Getting Dependencies

Use `di.get<T>()` to resolve dependencies:

```
final authRepo = di.get<AuthRepo>();
```

### Getting with Instance Name

For multiple implementations of the same type:

```
di.get<PageFactory>(instanceName: InstanceNameKeys.homeFactory);
```

### Getting Async Dependencies

For dependencies that need async initialization:

```
final packageInfo = await di.getAsync<PackageInfo>();
```

## Module Container Pattern

Each module exposes a container:

```
final class AuthContainer implements ModuleContainer {
  const AuthContainer();

  @override
  Injection? get injection => const AuthInjection();

  @override
  AppRouter<RouteBase>? get router => const AuthRouter();
}
```

**Purpose**: Allows `merge_dependencies` to discover and register modules automatically.

## Merge Dependencies

The `merge_dependencies` package aggregates all modules:

```
static const List<ModuleContainer> _allContainer = [
  CoreContainer(),
  AuthContainer(),
  HomeContainer(),
  // ... other modules
];

static final List<Injection> _injections = _allContainer
    .where((c) => c.injection != null)
    .map((c) => c.injection!)
    .toList();
```

### Registration Process

At app startup (`main.dart`):

```
await MergeDependencies.instance.registerModules();
```

**Process**:
1. Collects all module containers
2. Extracts injections
3. Registers dependencies in order
4. Sets up global services

## App Injector

The `AppInjector` is the global GetIt instance:

```
// In core package
final class AppInjector {
  static final GetIt instance = GetIt.instance;
}
```

**Usage**:
- Accessible globally via `AppInjector.instance`
- Used by modules to register dependencies
- Used by pages to resolve dependencies

## Dependency Injection in Pages

### Using BlocProvider

```
BlocProvider(
  create: (_) => di.get<LoginBloc>(),
  child: const LoginPage(),
)
```

### Using MultiBlocProvider

```
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => di.get<AuthBloc>()),
    BlocProvider(create: (_) => di.get<ProfileBloc>()),
  ],
  child: const ProfilePage(),
)
```

### Getting from Context

```
final bloc = context.read<LoginBloc>();
```

## Core Package Dependencies

The `core` package registers its own dependencies:

```
final class CoreInjection implements Injection {
  @override
  FutureOr<void> registerDependencies({required Injector di}) {
    di
      ..registerLazySingleton<NetworkProvider>(NetworkProviderImpl.new)
      ..registerLazySingleton<LocalSource>(LocalSourceImpl.new)
      // ... other core services
  }
}
```

**Registered in**: `CoreContainer`

## Common Patterns

### Repository with Multiple Data Sources

```
di.registerLazySingleton<AuthRepo>(
  () => AuthRepoImpl(
    di.get<AuthRemoteDataSource>(),
    di.get<AuthLocalDataSource>(),
  )
);
```

### Use Case with Repository

```
di.registerLazySingleton<Login>(
  () => Login(di.get<AuthRepo>())
);
```

### BLoC with Use Case

```
di.registerFactory(
  () => LoginBloc(di.get<Login>())
);
```

### BLoC with Multiple Dependencies

```
di.registerFactory(
  () => ProfileBloc(
    di.get<GetProfile>(),
    di.get<UpdateProfile>(),
  )
);
```

## Testing with DI

### Mock Dependencies

```
// In test
final mockRepo = MockAuthRepo();
di.registerLazySingleton<AuthRepo>(() => mockRepo);
```

### Reset Container

```
// In test setup
AppInjector.instance.reset();
```

## Best Practices

1. **Register in dependency order**: Data sources → Repositories → Use cases → BLoCs
2. **Use lazy singletons for stateless services**: Better performance
3. **Use factories for stateful components**: BLoCs need new instances
4. **Keep injection classes focused**: One injection class per module
5. **Don't register in constructors**: Register at app startup only

## Common Mistakes

❌ **Registering BLoC as singleton**
```
// Wrong
di.registerLazySingleton(() => LoginBloc(di.get())); // ❌
```

✅ **Registering BLoC as factory**
```
// Correct
di.registerFactory(() => LoginBloc(di.get())); // ✅
```

❌ **Circular dependencies**
```
// Wrong - A depends on B, B depends on A
di.registerLazySingleton<A>(() => A(di.get<B>()));
di.registerLazySingleton<B>(() => B(di.get<A>())); // ❌
```

✅ **Dependency hierarchy**
```
// Correct - A depends on B, B has no dependencies
di.registerLazySingleton<B>(() => B());
di.registerLazySingleton<A>(() => A(di.get<B>())); // ✅
```

## Next Steps

- [Module Structure](module_structure.md)
- [Domain Layer](../domain_layer/repositories.md)
- See `flutter-rules.md` for BLoC and presentation patterns
