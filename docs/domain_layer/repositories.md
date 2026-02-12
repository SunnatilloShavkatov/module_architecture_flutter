# Domain Repositories

This document explains how repository interfaces are defined in the Domain Layer.

## What are Repository Interfaces?

**Repository interfaces** are abstract contracts defined in the Domain Layer that specify how data should be accessed. They:

- Live in the **Domain Layer** (no implementation details)
- Are **abstract interfaces** (no implementation)
- Return `ResultFuture<T>` (Either pattern)
- Use **entities** (not models)

## Repository Structure

### Basic Repository

```
import 'package:auth/src/domain/entities/login_entity.dart';
import 'package:core/core.dart';

abstract interface class AuthRepo {
  const AuthRepo();

  ResultFuture<LoginEntity> login({
    required String username,
    required String password,
  });
}
```

### Repository with Multiple Methods

```
abstract interface class ProfileRepository {
  const ProfileRepository();

  ResultFuture<ProfileEntity> getProfile();
  ResultFuture<void> updateProfile({required ProfileEntity profile});
  ResultFuture<void> deleteProfile();
}
```

## Repository Rules

### 1. Abstract Interface

Repositories are abstract interfaces:

```
// ✅ Correct
abstract interface class AuthRepo { ... }

// ❌ Wrong
abstract class AuthRepo { ... } // Use interface keyword
class AuthRepo { ... } // Not abstract
```

### 2. Return ResultFuture

All methods return `ResultFuture<T>`:

```
// ✅ Correct
ResultFuture<LoginEntity> login(...);

// ❌ Wrong
Future<LoginEntity> login(...); // Missing Either wrapper
Future<Either<Failure, LoginEntity>> login(...); // Use typedef
```

### 3. Use Entities, Not Models

Repositories work with domain entities:

```
// ✅ Correct
ResultFuture<LoginEntity> login(...);

// ❌ Wrong
ResultFuture<LoginModel> login(...); // Model is data layer
```

### 4. No Implementation Details

No implementation code in repository interface:

```
// ✅ Correct
abstract interface class AuthRepo {
  ResultFuture<LoginEntity> login(...);
}

// ❌ Wrong
abstract interface class AuthRepo {
  ResultFuture<LoginEntity> login(...) {
    // Implementation code - wrong!
  }
}
```

### 5. No Framework Dependencies

Pure Dart, no Flutter dependencies:

```
// ✅ Correct
import 'package:core/core.dart';

// ❌ Wrong
import 'package:flutter/material.dart';
```

## Repository Location

Repository interfaces are located in:

```
module_name/src/domain/repos/ or module_name/src/domain/repository/
  └── module_name_repo.dart or module_name_repository.dart
```

Use the existing naming style of the target module and keep it consistent inside that module.

## Repository Implementation

Repository interfaces are **implemented** in the Data Layer:

```
// Domain Layer (interface)
abstract interface class AuthRepo {
  ResultFuture<LoginEntity> login(...);
}

// Data Layer (implementation)
final class AuthRepoImpl implements AuthRepo {
  @override
  ResultFuture<LoginEntity> login(...) {
    // Implementation
  }
}
```

Implementations should be in the Data Layer (see `flutter-rules.md` for implementation patterns).

## Repository Usage

### In Use Cases

Use cases depend on repository interfaces:

```
final class Login extends UsecaseWithParams<LoginEntity, LoginParams> {
  const Login(this._repo);
  final AuthRepo _repo; // Interface, not implementation
  
  @override
  ResultFuture<LoginEntity> call(LoginParams params) => _repo.login(
    username: params.username,
    password: params.password,
  );
}
```

### In Dependency Injection

Register repository interface with implementation:

```
di.registerLazySingleton<AuthRepo>(
  () => AuthRepoImpl(di.get(), di.get())
);
```

## Repository Patterns

### Single Entity Repository

```
abstract interface class UserRepository {
  ResultFuture<UserEntity> getUser(String userId);
  ResultFuture<void> updateUser(UserEntity user);
  ResultFuture<void> deleteUser(String userId);
}
```

### List Repository

```
abstract interface class ProductsRepository {
  ResultFuture<List<ProductEntity>> getProducts();
  ResultFuture<ProductEntity> getProduct(String productId);
}
```

### Pagination Repository

```
abstract interface class ProductsRepository {
  ResultFuture<List<ProductEntity>> getProducts({
    int page = 1,
    int limit = 20,
  });
}
```

### Search Repository

```
abstract interface class ProductsRepository {
  ResultFuture<List<ProductEntity>> searchProducts(String query);
}
```

## Error Handling

Repositories return `Either<Failure, T>`, but the interface doesn't specify how errors are handled - that's the implementation's responsibility.

```
abstract interface class AuthRepo {
  // Interface doesn't specify error handling
  ResultFuture<LoginEntity> login(...);
}

// Implementation handles errors
final class AuthRepoImpl implements AuthRepo {
  @override
  ResultFuture<LoginEntity> login(...) async {
    try {
      // Success
      return Right(entity);
    } on ServerException catch (error, _) {
      return Left(error.failure);
    }
  }
}
```

## Repository Best Practices

### 1. Keep Methods Focused

Each method should do one thing:

```
// ✅ Correct
ResultFuture<LoginEntity> login(...);
ResultFuture<void> logout();

// ❌ Wrong
ResultFuture<LoginEntity> loginAndLogout(...); // Two operations
```

### 2. Use Descriptive Names

```
// ✅ Correct
ResultFuture<ProfileEntity> getProfile();
ResultFuture<void> updateProfile(...);

// ❌ Wrong
ResultFuture<ProfileEntity> get();
ResultFuture<void> update(...);
```

### 3. Group Related Operations

```
abstract interface class AuthRepo {
  // Authentication operations
  ResultFuture<LoginEntity> login(...);
  ResultFuture<void> logout();
  ResultFuture<void> refreshToken();
}
```

### 4. Use Parameters Object for Complex Methods

```
// ✅ Correct - Simple
ResultFuture<LoginEntity> login({
  required String username,
  required String password,
});

// ✅ Correct - Complex (use params object)
ResultFuture<OrderEntity> createOrder(CreateOrderParams params);
```

## Part/Part Of Pattern

Some repositories use the `part`/`part of` pattern to keep interface and implementation together:

```
// domain/repos/auth_repo.dart
part '../../data/repo/auth_repo_impl.dart';

abstract interface class AuthRepo {
  ResultFuture<LoginEntity> login(...);
}

// data/repo/auth_repo_impl.dart
part of 'package:auth/src/domain/repos/auth_repo.dart';

final class AuthRepoImpl implements AuthRepo {
  // Implementation
}
```

**Note**: This pattern is optional. Most modules keep interfaces and implementations separate.

## Testing Repositories

Repository interfaces are tested via implementations:

```
// Test implementation
class MockAuthRepo implements AuthRepo {
  @override
  ResultFuture<LoginEntity> login(...) {
    return Right(LoginEntity(...));
  }
}
```

## Next Steps

- [Use Cases](usecases.md)
- [Entities](entities.md)
- See `flutter-rules.md` for repository implementation patterns
