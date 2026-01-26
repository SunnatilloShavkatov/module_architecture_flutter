# Core Package

Core functionality and abstractions for the Module Architecture Mobile project.

## Overview

The `core` package provides essential functionality used across all feature modules, including network operations, error handling, dependency injection abstractions, and common utilities.

## Features

### Network Provider
- HTTP client wrapper using Dio
- Automatic error handling and retries
- Token-based authentication support
- Request/response interceptors
- Multi-language support (uz, ru, en)

### Error Handling
- **Either Pattern**: `ResultFuture<T>` for error handling
- **Failure Hierarchy**: Structured error types
- **Exception Handling**: Comprehensive exception catching
- Type-safe error propagation

### Dependency Injection
- **Abstractions**: `Injection`, `Injector`, `ModuleContainer`
- **GetIt Integration**: Service locator pattern
- Module-based dependency registration

### Extensions
- **Localization**: `context.localizations` - Access translations
- **Theme Colors**: `context.color` - Access theme colors
- **Text Styles**: `context.textStyle` - Access text styles
- **Platform**: Platform detection utilities
- **Date Parsing**: Date formatting and parsing
- **Money Format**: Currency formatting
- **Size**: Responsive sizing utilities

### Localization
- **Languages**: Uzbek (uz), Russian (ru), English (en)
- **Default**: Uzbek
- **ARB Files**: `intl_uz.arb`, `intl_ru.arb`, `intl_en.arb`
- **Generated**: Type-safe localization classes

### Constants
- **API Paths**: Centralized API endpoint definitions
- **Storage Keys**: Local storage key constants
- **Environment**: Environment configuration (dev, prod)

### Utilities
- **Logging**: `logMessage()` utility
- **Type Definitions**: Common typedefs (`ResultFuture`, `DataMap`)
- **Use Case Base**: Abstract use case classes

## Installation

This package is part of the Module Architecture Mobile monorepo and is not published to pub.dev.

Add to your module's `pubspec.yaml`:

```yaml
dependencies:
  core:
    path: ../../packages/core
```

## Usage

### Import

```
import 'package:core/core.dart';
```

### Network Operations

```
// In data source
final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._networkProvider);
  final NetworkProvider _networkProvider;

  @override
  Future<LoginModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final result = await _networkProvider.fetchMethod<DataMap>(
        ApiPaths.login,
        methodType: RMethodTypes.post,
        headers: _networkProvider.tokenHeaders,
        data: {
          'username': username,
          'password': password,
        },
      );
      return LoginModel.fromMap(result.data ?? {});
    } on ServerException {
      rethrow;
    } catch (error) {
      throw ServerException.unknownError(
        locale: _networkProvider.locale,
      );
    }
  }
}
```

### Error Handling

```
// In repository
@override
ResultFuture<LoginEntity> login({
  required String username,
  required String password,
}) async {
  try {
    final result = await _remoteDataSource.login(
      username: username,
      password: password,
    );
    return Right(result.toEntity());
  } on ServerException catch (error) {
    return Left(error.failure);
  } catch (e) {
    return Left(ServerFailure(message: e.toString()));
  }
}
```

### Localization

```
// In widgets
Text(context.localizations.appName)
Text(context.localizations.loginButton)
```

### Theme Colors

```
// Access theme colors
Container(
  color: context.color.primary,
  child: Text(
    'Hello',
    style: context.textStyle.defaultW700x24.copyWith(
      color: context.color.textPrimary,
    ),
  ),
)
```

### Dependency Injection

```
final class AuthInjection implements Injection {
  const AuthInjection();

  @override
  FutureOr<void> registerDependencies({required Injector di}) {
    // Register data sources
    di.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(di.get()),
    );

    // Register repositories
    di.registerLazySingleton<AuthRepo>(
      () => AuthRepoImpl(di.get()),
    );

    // Register use cases
    di.registerLazySingleton<Login>(
      () => Login(di.get()),
    );
  }
}
```

## Package Contents

### Network
- `NetworkProvider` - HTTP client wrapper
- `RMethodTypes` - HTTP method enumeration
- Response handling utilities

### Error Handling
- `Failure` - Base failure class
- `ServerFailure` - Server error failures
- `CacheFailure` - Cache error failures
- `ServerException` - Server exceptions
- `CacheException` - Cache exceptions
- `Either<L, R>` - Functional error handling

### DI Abstractions
- `Injection` - Dependency registration interface
- `Injector` - Service locator abstraction
- `ModuleContainer` - Module registration interface

### Extensions
- `BuildContextExtension` - `context.localizations`, `context.color`, `context.textStyle`
- `PlatformExtension` - Platform detection
- `DateParseExtension` - Date utilities
- `MoneyFormatExtension` - Currency formatting
- `SizeExtension` - Responsive sizing

### Base Classes
- `UseCase` - Base use case without parameters
- `UsecaseWithParams<Type, Params>` - Use case with parameters

## Rules

### When to Use

✅ **MUST** use for:
- Network operations
- Error handling (Either pattern)
- DI abstractions
- Extensions (localizations, color, textStyle)
- Constants and environment configuration
- Use case base classes

✅ **MUST** use in:
- All feature modules
- Data sources for network calls
- Repositories for error handling
- Presentation layer for localization and theming

### When NOT to Use

❌ **NEVER** put:
- UI components (use `components` package)
- Navigation utilities (use `navigation` package)
- Feature-specific logic (belongs in modules)

## Dependencies

### Core Dependencies
- `dio` - HTTP client
- `get_it` - Dependency injection
- `equatable` - Value equality
- `hive` - Local storage
- `connectivity_plus` - Network connectivity
- `intl` - Internationalization

### Development Dependencies
- `flutter_test` - Testing framework
- `analysis_lints` - Linting rules

## Best Practices

1. **Always use Either pattern**: Never throw exceptions from repositories
2. **Use extensions**: Access localizations, colors, and text styles via extensions
3. **Centralize constants**: Add API paths and storage keys to constants
4. **Type-safe errors**: Use structured Failure classes instead of strings
5. **Dependency abstraction**: Depend on interfaces, not implementations

## Related Documentation

- [Architecture Overview](../../docs/architecture/overview.md)
- [Dependency Injection](../../docs/architecture/dependency_injection.md)
- [Flutter Rules](../../flutter-rules.md#14-package-usage-rules)

## License

[Add your license here]
