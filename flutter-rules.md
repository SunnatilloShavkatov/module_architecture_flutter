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
**UI Components:** `SafeAreaWithMinimum`, `CustomLoadingButton`, `Dimensions`, `ThemeColors`, `ThemeTextStyles`  

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
  const SearchClientsEvent({required this.query});
  final String query;
}
```

### Form Validation
```dart
final class UsernameChanged extends LoginEvent {
  const UsernameChanged({required this.username});
  final String username;
}
```

---

## 13. UI Components & Styling

### Safe Area
- ✅ **MUST** use `SafeAreaWithMinimum` instead of `SafeArea`
- ✅ Use `Dimensions.kPaddingAll16` or other predefined padding constants

```dart
// ✅ Correct
SafeAreaWithMinimum(
  minimum: Dimensions.kPaddingAll16,
  child: Column(...),
)

// ❌ Wrong
SafeArea(child: Column(...))
```

### Buttons
- ✅ **MUST** use `CustomLoadingButton` for primary buttons instead of `ElevatedButton`
- ✅ `CustomLoadingButton` automatically handles throttling and loading states
- ✅ `CustomLoadingButton` uses default `ThemeData` from context (no need to wrap with `Theme` widget)

```dart
// ✅ Correct
CustomLoadingButton(
  onPressed: () {},
  child: Text('Button', style: context.textStyle.buttonStyle),
)

// ❌ Wrong
ElevatedButton(
  onPressed: () {},
  child: Text('Button'),
)

// ❌ Wrong - Theme wrapper not needed
Theme(
  data: Theme.of(context).copyWith(...),
  child: CustomLoadingButton(...),
)
```
<｜tool▁calls▁begin｜><｜tool▁call▁begin｜>
read_file

### Dimensions
- ✅ **MUST** use `Dimensions` constants for all spacing, padding, gaps, and border radius
- ✅ If a dimension doesn't exist, add it to `Dimensions` class first

```dart
// ✅ Correct
Dimensions.kZeroBox
Dimensions.kGap12
Dimensions.kGap16
Dimensions.kGap32
Dimensions.kDivider
Dimensions.kSpacer
Dimensions.kPaddingAll16
Dimensions.kShapeZero
Dimensions.kBorderRadius12

// ❌ Wrong
const Gap(12)
const Gap(16)
EdgeInsets.all(16)
BorderRadius.circular(12)
```

### Colors
- ✅ **MUST** use `ThemeColors` from `context.color` extension
- ✅ If color doesn't exist in `ThemeColors`, use `context.colorScheme.primary` as fallback
- ✅ **NEVER** use hardcoded colors like `Colors.blue`, `Colors.black`, etc.

```dart
// ✅ Correct
context.color.primary
context.color.textPrimary
context.color.textSecondary
context.colorScheme.primary // fallback if not in ThemeColors

// ❌ Wrong
Colors.blue
Colors.black
Colors.grey
Color(0xFF000000)
```

### Text Styles
- ✅ **MUST** use `ThemeTextStyles` from `context.textStyle` extension
- ✅ Use appropriate style from `ThemeTextStyles` (e.g., `defaultW700x24`, `defaultW400x14`, `buttonStyle`)
- ✅ **NEVER** create inline `TextStyle` objects

```dart
// ✅ Correct
context.textStyle.defaultW700x24
context.textStyle.defaultW400x14
context.textStyle.buttonStyle
context.textStyle.defaultW600x16.copyWith(color: context.color.primary)

// ❌ Wrong
TextStyle(fontSize: 24, fontWeight: FontWeight.w700)
const TextStyle(color: Colors.white, fontSize: 16)
```

### Analysis Options
- ✅ **MUST** use `analysis_lints: ^1.0.5` in `pubspec.yaml` dev_dependencies
- ✅ **MUST** include `package:analysis_lints/analysis_options.yaml` in `analysis_options.yaml`

```yaml
# pubspec.yaml
dev_dependencies:
  analysis_lints: ^1.0.5

# analysis_options.yaml
include: package:analysis_lints/analysis_options.yaml
```

### Complete Example

```dart
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        body: SafeAreaWithMinimum(
          minimum: Dimensions.kPaddingAll16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                context.localizations.handbookTitle,
                style: context.textStyle.defaultW700x24.copyWith(
                  color: context.color.primary,
                ),
              ),
              Dimensions.kGap16,
              Text(
                context.localizations.welcomeSubtitle,
                style: context.textStyle.defaultW700x24.copyWith(
                  color: context.color.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              Dimensions.kGap12,
              Text(
                context.localizations.welcomeDescription,
                style: context.textStyle.defaultW400x14.copyWith(
                  color: context.color.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: CustomLoadingButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.main);
                  },
                  child: Text(
                      context.localizations.proceedButton
                  ),
                ),
              ),
              Dimensions.kGap16,
              TextButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.headset_mic,
                  color: context.color.primary,
                  size: 20,
                ),
                label: Text(
                  context.localizations.getHelp,
                  style: context.textStyle.defaultW400x14.copyWith(
                    color: context.color.primary,
                  ),
                ),
              ),
              Dimensions.kGap32,
            ],
          ),
        ),
      );
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
- [ ] Uses `SafeAreaWithMinimum` instead of `SafeArea`
- [ ] Uses `CustomLoadingButton` for primary buttons
- [ ] Uses `Dimensions` constants for spacing, padding, gaps, and border radius
- [ ] Uses `ThemeColors` from `context.color` extension
- [ ] Uses `ThemeTextStyles` from `context.textStyle` extension
- [ ] No hardcoded colors or text styles
- [ ] `analysis_lints: ^1.0.5` configured in `analysis_options.yaml`

---

**Reference:** See `docs/flutter-rules.md` for detailed examples and `docs/architecture.md` for full architecture documentation.
