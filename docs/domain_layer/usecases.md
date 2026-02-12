# Domain Use Cases

This document explains how use cases are structured and used to encapsulate business logic.

## What are Use Cases?

**Use cases** are classes that encapsulate a single business operation. They:

- Live in the **Domain Layer** (no framework dependencies)
- Execute a **single business operation**
- Depend on repository interfaces (not implementations)
- Return `ResultFuture<T>` (Either pattern)

## Use Case Structure

### Use Case with Parameters

```
import 'package:core/core.dart';
import 'package:auth/src/domain/entities/login_entity.dart';
import 'package:auth/src/domain/repos/auth_repo.dart';

final class Login extends UsecaseWithParams<LoginEntity, LoginParams> {
  const Login(this._repo);
  final AuthRepo _repo;
  
  @override
  ResultFuture<LoginEntity> call(LoginParams params) => _repo.login(
    username: params.username,
    password: params.password,
  );
}

class LoginParams {
  const LoginParams({
    required this.username,
    required this.password,
  });
  final String username;
  final String password;
}
```

### Use Case Without Parameters

```
import 'package:core/core.dart';
import 'package:more/src/domain/repository/more_repository.dart';

final class GetMoreData extends UsecaseWithoutParams<void> {
  const GetMoreData(this._repo);
  final MoreRepository _repo;
  
  @override
  ResultFuture<void> call() => _repo.getMoreData();
}
```

## Use Case Base Classes

The `core` package provides two base classes:

### UsecaseWithParams

For use cases that need parameters:

```
abstract class UsecaseWithParams<Types, Params> {
  const UsecaseWithParams();
  ResultFuture<Types> call(Params params);
}
```

### UsecaseWithoutParams

For use cases without parameters:

```
abstract class UsecaseWithoutParams<Types> {
  const UsecaseWithoutParams();
  ResultFuture<Types> call();
}
```

## Use Case Rules

### 1. Single Responsibility

Each use case does **one thing**:

```
// ✅ Correct
final class Login extends UsecaseWithParams<LoginEntity, LoginParams> {
  // Only handles login
}

// ❌ Wrong
final class LoginAndGetProfile extends UsecaseWithParams<...> {
  // Two operations - wrong!
}
```

### 2. Depend on Repository Interfaces

Use cases depend on repository **interfaces**, not implementations:

```
// ✅ Correct
final class Login extends UsecaseWithParams<LoginEntity, LoginParams> {
  const Login(this._repo);
  final AuthRepo _repo; // Interface
}

// ❌ Wrong
final class Login extends UsecaseWithParams<LoginEntity, LoginParams> {
  const Login(this._repo);
  final AuthRepoImpl _repo; // Implementation - wrong!
}
```

### 3. Return ResultFuture

All use cases return `ResultFuture<T>`:

```
// ✅ Correct
ResultFuture<LoginEntity> call(LoginParams params);

// ❌ Wrong
Future<LoginEntity> call(LoginParams params); // Missing Either
```

### 4. No Framework Dependencies

Pure Dart, no Flutter dependencies:

```
// ✅ Correct
import 'package:core/core.dart';

// ❌ Wrong
import 'package:flutter/material.dart';
```

### 5. Immutable

Use cases are `final` classes:

```
// ✅ Correct
final class Login extends UsecaseWithParams<...> { ... }

// ❌ Wrong
class Login extends UsecaseWithParams<...> { ... } // Not final
```

## Use Case Location

Use cases are located in:

```
module_name/src/domain/usecases/
  └── use_case_name.dart
```

## Use Case Patterns

### Simple Use Case

Delegates directly to repository:

```
final class GetProfile extends UsecaseWithoutParams<ProfileEntity> {
  const GetProfile(this._repo);
  final ProfileRepository _repo;
  
  @override
  ResultFuture<ProfileEntity> call() => _repo.getProfile();
}
```

### Use Case with Business Logic

Adds business logic before/after repository call:

```
final class Login extends UsecaseWithParams<LoginEntity, LoginParams> {
  const Login(this._repo);
  final AuthRepo _repo;
  
  @override
  ResultFuture<LoginEntity> call(LoginParams params) async {
    // Validate input
    if (params.username.isEmpty || params.password.isEmpty) {
      return Left(ValidationFailure(message: 'Invalid input'));
    }
    
    // Call repository
    return _repo.login(
      username: params.username,
      password: params.password,
    );
  }
}
```

### Use Case with Multiple Repositories

Coordinates multiple repositories:

```
final class GetUserWithProfile extends UsecaseWithoutParams<UserWithProfileEntity> {
  const GetUserWithProfile(this._userRepo, this._profileRepo);
  final UserRepository _userRepo;
  final ProfileRepository _profileRepo;
  
  @override
  ResultFuture<UserWithProfileEntity> call() async {
    final userResult = await _userRepo.getUser();
    return userResult.fold(
      (failure) => Left(failure),
      (user) async {
        final profileResult = await _profileRepo.getProfile(user.id);
        return profileResult.fold(
          (failure) => Left(failure),
          (profile) => Right(UserWithProfileEntity(user: user, profile: profile)),
        );
      },
    );
  }
}
```

### Use Case with Transformation

Transforms data before returning:

```
final class GetProducts extends UsecaseWithoutParams<List<ProductEntity>> {
  const GetProducts(this._repo);
  final ProductsRepository _repo;
  
  @override
  ResultFuture<List<ProductEntity>> call() async {
    final result = await _repo.getProducts();
    return result.map((products) {
      // Filter or transform products
      return products.where((p) => p.isActive).toList();
    });
  }
}
```

## Use Case Usage

### In Blocs

Blocs call use cases:

```
final class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._loginUseCase) : super(LoginInitial());
  final Login _loginUseCase;
  
  Future<void> _loginSubmittedHandler(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    final result = await _loginUseCase.call(LoginParams(
      username: event.username,
      password: event.password,
    ));
    result.fold(
      (failure) => emit(LoginFailure(failure.message)),
      (user) => emit(LoginSuccess(user)),
    );
  }
}
```

### In Dependency Injection

Register use cases:

```
di.registerLazySingleton<Login>(() => Login(di.get<AuthRepo>()));
```

## Parameters Object

For complex use cases, use a parameters object:

```
class CreateOrderParams {
  const CreateOrderParams({
    required this.items,
    required this.shippingAddress,
    this.couponCode,
  });
  
  final List<OrderItemEntity> items;
  final AddressEntity shippingAddress;
  final String? couponCode;
}

final class CreateOrder extends UsecaseWithParams<OrderEntity, CreateOrderParams> {
  const CreateOrder(this._repo);
  final OrderRepository _repo;
  
  @override
  ResultFuture<OrderEntity> call(CreateOrderParams params) => _repo.createOrder(
    items: params.items,
    shippingAddress: params.shippingAddress,
    couponCode: params.couponCode,
  );
}
```

## Use Case Best Practices

### 1. Keep Use Cases Simple

Prefer delegation to complex logic:

```
// ✅ Correct - Simple delegation
final class GetProfile extends UsecaseWithoutParams<ProfileEntity> {
  @override
  ResultFuture<ProfileEntity> call() => _repo.getProfile();
}

// ✅ Correct - Business logic when needed
final class Login extends UsecaseWithParams<LoginEntity, LoginParams> {
  @override
  ResultFuture<LoginEntity> call(LoginParams params) {
    // Validate, then delegate
    if (params.username.isEmpty) {
      return Left(ValidationFailure(message: 'Username required'));
    }
    return _repo.login(...);
  }
}
```

### 2. One Use Case Per Operation

```
// ✅ Correct
final class Login extends UsecaseWithParams<...> { ... }
final class Logout extends UsecaseWithoutParams<void> { ... }

// ❌ Wrong
final class AuthOperations extends UsecaseWithParams<...> {
  ResultFuture<LoginEntity> login(...);
  ResultFuture<void> logout();
}
```

### 3. Use Descriptive Names

```
// ✅ Correct
final class GetUserProfile extends UsecaseWithoutParams<ProfileEntity> { ... }
final class UpdateUserProfile extends UsecaseWithParams<void, UpdateProfileParams> { ... }

// ❌ Wrong
final class Get extends UsecaseWithoutParams<ProfileEntity> { ... }
final class Update extends UsecaseWithParams<void, UpdateProfileParams> { ... }
```

### 4. Handle Errors Appropriately

Use cases can transform errors:

```
final class Login extends UsecaseWithParams<LoginEntity, LoginParams> {
  @override
  ResultFuture<LoginEntity> call(LoginParams params) async {
    final result = await _repo.login(...);
    return result.mapLeft((failure) {
      // Transform error if needed
      if (failure is ServerFailure && failure.statusCode == 401) {
        return AuthFailure(message: 'Invalid credentials');
      }
      return failure;
    });
  }
}
```

## Testing Use Cases

Use cases are easy to test (mock repositories):

```
test('Login use case success', () async {
  final mockRepo = MockAuthRepo();
  when(mockRepo.login(...)).thenAnswer((_) async => Right(LoginEntity(...)));
  
  final useCase = Login(mockRepo);
  final result = await useCase.call(LoginParams(...));
  
  expect(result.isRight, true);
});
```

## Next Steps

- [Repositories](repositories.md)
- [Entities](entities.md)
- See `flutter-rules.md` for Bloc patterns
