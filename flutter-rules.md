# Flutter Development Rules

> [!IMPORTANT]
> **AI Assistant Instructions:** 
> - This file contains the project's coding standards and architecture rules
> - ALWAYS follow these rules when generating code, refactoring, or creating new features
> - Reference this file in your prompts: `@flutter-rules.md` or `Make sure to follow flutter-rules.md`
> - When generating code, ensure it matches the patterns and conventions defined here

## Quick Reference for AI

**Architecture:** Clean Architecture with 3 layers (Data, Domain, Presentation)  
**State Management:** BLoC pattern with sealed classes  
**DI:** GetIt via `merge_dependencies` package  
**Naming:** `snake_case.dart` files, `PascalCase` classes, `camelCase` variables  
**Error Handling:** Either pattern with Failure/Exception hierarchy  

---

## 1. Project Structure

```
mobile_nasiya_business/
├── lib/                    # App entry point
├── modules/               # Feature modules (Clean Architecture)
│   ├── auth/
│   ├── calculator/
│   ├── cards/
│   ├── clients/
│   ├── credits/
│   ├── initial/
│   ├── main/
│   ├── notifications/
│   ├── profile/
│   └── system/
├── packages/              # Shared packages
│   ├── base_dependencies/ # External dependencies
│   ├── components/        # Reusable UI components
│   ├── core/             # Core functionality
│   ├── merge_dependencies/# Dependency aggregator
│   ├── navigation/       # Routing & navigation
│   └── platform_methods/ # Platform-specific code
└── assets/               # Images, fonts, icons
```

### Module Structure (Clean Architecture)

```
module_name/
├── lib/
│   ├── module_name.dart          # Public API exports
│   └── src/
│       ├── data/                 # Data Layer
│       │   ├── datasource/       # Remote & Local data sources
│       │   ├── models/           # Data models (JSON serialization)
│       │   └── repos/            # Repository implementations
│       ├── di/                   # Dependency Injection
│       ├── domain/               # Domain Layer
│       │   ├── entities/         # Business entities (pure Dart)
│       │   ├── repos/            # Repository abstractions
│       │   └── usecases/         # Business logic use cases
│       ├── presentation/         # Presentation Layer
│       │   └── feature_name/
│       │       ├── bloc/         # BLoC files
│       │       ├── widgets/      # Feature-specific widgets
│       │       └── feature_page.dart
│       └── router/               # Module routing
└── pubspec.yaml
```

---

## 2. Clean Architecture Layers

### Data Layer
- **Purpose:** API communication, local storage, data transformation
- **Rules:**
  - Data sources MUST be abstract interfaces
  - Implementation in `*_impl.dart` files
  - Models MUST have `fromMap()` and `toMap()` methods
  - Repository implementations in data layer

### Domain Layer
- **Purpose:** Business logic, entities, repository contracts
- **Rules:**
  - NO framework dependencies
  - Pure Dart code only
  - Entities have no dependencies
  - Repositories are abstract classes only
  - Use cases follow single responsibility principle

### Presentation Layer
- **Purpose:** UI rendering, user interaction, state management
- **Rules:**
  - One BLoC per page
  - UI logic stays in presentation layer
  - BLoC calls use cases only (never directly calls repositories)

---

## 3. Naming Conventions

| Item | Convention | Example |
|------|-----------|---------|
| Files | `snake_case.dart` | `login_page.dart` |
| Directories | `snake_case` | `data`, `presentation` |
| Classes | `PascalCase` | `LoginPage`, `AuthBloc` |
| Abstract classes | `PascalCase` | `AuthRepo` |
| Final classes | `final class` | `final class AuthRepoImpl` |
| Variables | `camelCase` | `userName` |
| Private members | `_camelCase` | `_networkProvider` |
| Enums | `PascalCase` | `RMethodTypes` |
| Enum values | `camelCase` | `get`, `post` |

### Suffixes
- `Bloc` - Business Logic Component
- `Event` - BLoC events
- `State` - BLoC states  
- `Entity` - Domain entities
- `Model` - Data models
- `Repo` - Repositories
- `DataSource` - Data sources
- `UseCase` - Use cases
- `Impl` - Implementations
- `Page` - Full screens
- `Widget` - Reusable widgets

---

## 4. BLoC Pattern

### Structure

```dart
// Events - MUST use sealed class
sealed class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object?> get props => [];
}

final class LoginSubmitted extends LoginEvent {
  const LoginSubmitted({required this.username, required this.password});
  final String username;
  final String password;
  @override
  List<Object?> get props => [username, password];
}

// States - MUST use sealed class
sealed class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object?> get props => [];
}

final class LoginInitial extends LoginState {}
final class LoginLoading extends LoginState {}
final class LoginSuccess extends LoginState {
  const LoginSuccess(this.user);
  final LoginEntity user;
  @override
  List<Object?> get props => [user];
}

// Bloc
final class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._loginUseCase) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }
  
  final LoginUseCase _loginUseCase;
  
  Future<void> _onLoginSubmitted(
    LoginSubmitted event, 
    Emitter<LoginState> emit
  ) async {
    emit(LoginLoading());
    final result = await _loginUseCase(...);
    result.fold(
      (failure) => emit(LoginFailure(failure.message)),
      (user) => emit(LoginSuccess(user)),
    );
  }
}
```

### Rules
- ✅ Events and States MUST be `sealed class`
- ✅ MUST use `Equatable` mixin
- ✅ BLoC constructor injects use cases only
- ✅ Event handlers MUST be private (`_onEventName`)
- ✅ `emit` used only in event handlers

---

## 5. Dependency Injection

### Pattern

```dart
final class AuthInjection implements Injection {
  const AuthInjection();

  @override
  FutureOr<void> registerDependencies({required Injector di}) {
    di
      /// data sources
      ..registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(di.get())
      )
      /// repositories
      ..registerLazySingleton<AuthRepo>(
        () => AuthRepoImpl(di.get(), di.get())
      )
      /// use cases
      ..registerLazySingleton<Login>(() => Login(di.get()))
      /// bloc
      ..registerFactory(() => LoginBloc(di.get(), di.get()));
  }
}
```

### Registration Types
- `registerLazySingleton` - Repos, Data Sources, Use Cases
- `registerFactory` - BLoCs, Pages (created on demand)
- `registerSingleton` - App lifecycle services

---

## 6. Error Handling

### Pattern: Either

```dart
typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef ResultVoid = ResultFuture<void>;
typedef DataMap = Map<String, dynamic>;
```

### Exception Handling

```dart
// In Data Source
try {
  final result = await _networkProvider.fetchMethod(...);
  return Model.fromMap(result.data ?? {});
} on FormatException {
  throw ServerException.formatException(locale: _networkProvider.locale);
} on ServerException {
  rethrow;
} on Error catch (error, stackTrace) {
  logMessage('ERROR: ', error: error, stackTrace: stackTrace);
  if (error is TypeError) {
    throw ServerException.typeError(locale: _networkProvider.locale);
  } else {
    throw ServerException.unknownError(locale: _networkProvider.locale);
  }
}

// In Repository
try {
  final result = await _remoteSource.login(...);
  return Right(result);
} on ServerException catch (error, _) {
  return Left(error.failure);
} on Exception catch (e) {
  return Left(ServerFailure(message: e.toString()));
}
```

---

## 7. Code Style

### Import Ordering
1. Dart SDK imports
2. Flutter imports  
3. Package imports
4. Relative imports

```dart
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:core/core.dart';
import 'package:base_dependencies/base_dependencies.dart';

import 'auth_bloc.dart';
```

### Rules
- ✅ Prefer `final` for immutable variables
- ✅ Prefer `const` for compile-time constants
- ✅ Use `sealed class` for Events and States
- ✅ Use `final class` for implementations
- ✅ Single quotes for strings
- ✅ Named parameters for 3+ parameters

---

## 8. API Integration

### Base URLs
- Dev: `https://mapitest.mobilnasiya.uz`
- Prod: `https://mapi.mobilnasiya.uz`

### Authentication
```dart
headers: {
  'Authorization': 'Bearer {access_token}',
  'Lang': 'uz' | 'ru',
  'Content-Type': 'application/json'
}
```

### Response Format
```json
{
  "success": true,
  "data": { /* response data */ },
  "message": "Success message"
}
```

### Network Provider Pattern
```dart
final result = await _networkProvider.fetchMethod<DataMap>(
  ApiPaths.endpoint,
  methodType: RMethodTypes.post,
  headers: _networkProvider.tokenHeaders,
  data: data,
);
```

---

## 9. Localization

### Setup
- ARB files: `intl_uz.arb`, `intl_ru.arb`
- Default locale: `uz`
- Supported: `uz`, `ru`

### Usage
```dart
context.localizations.appName
context.localizations.login
```

---

## 10. File Organization

### Repository Pattern (Part/Part Of)

```dart
// domain/repos/auth_repo.dart
part '../../data/repos/auth_repo_impl.dart';

abstract class AuthRepo {
  ResultFuture<LoginEntity> login({...});
}

// data/repos/auth_repo_impl.dart
part of 'package:auth/src/domain/repos/auth_repo.dart';

final class AuthRepoImpl implements AuthRepo { ... }
```

---

## 11. Performance

- ✅ Use `registerLazySingleton` for dependencies
- ✅ Mark widgets as `const` where possible
- ✅ Use keys for list items
- ✅ Use `CachedNetworkImage` for remote images
- ✅ Use `ListView.builder` for long lists
- ✅ Debounce search inputs (500ms)

---

## 12. Common Patterns

### Pagination
```dart
final class FetchCreditsEvent extends CreditsEvent {
  const FetchCreditsEvent({this.page = 1});
  final int page;
}
```

### Search/Filter
```dart
final class SearchClientsEvent extends ClientsEvent {
  const SearchClientsEvent(this.query);
  final String query;
}
```

### Form Validation
```dart
final class UsernameChanged extends LoginEvent {
  const UsernameChanged(this.username);
  final String username;
}
```

---

## AI Assistant Checklist

When generating code, ensure:
- [ ] Follows Clean Architecture (3 layers)
- [ ] Uses correct naming conventions
- [ ] BLoC uses sealed classes with Equatable
- [ ] Error handling uses Either pattern
- [ ] Dependencies registered in Injection class
- [ ] Imports ordered correctly
- [ ] Localization used for user-facing text
- [ ] Code style matches project conventions
- [ ] Performance optimizations applied
- [ ] Matches existing code patterns

---

**Reference:** See `docs/flutter-rules.md` for detailed examples and `docs/architecture.md` for full architecture documentation.
