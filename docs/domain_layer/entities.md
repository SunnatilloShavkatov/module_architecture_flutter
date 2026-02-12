# Domain Entities

This document explains how domain entities are structured and used in the Clean Architecture pattern.

## What are Entities?

**Entities** are immutable business objects that represent core concepts in your domain. They:

- Live in the **Domain Layer** (no framework dependencies)
- Are **pure Dart classes**
- Extend `Equatable` for value equality
- Are **immutable** (all fields are `final`)

## Entity Structure

### Mandatory API Entity Contract (Project Standard)

For API-driven entities in this repository:

- scalar/object fields are nullable (`String?`, `int?`, `double?`, nested entity nullable);
- list fields are non-null and must be `required`;
- entities remain immutable and extend `Equatable`;
- entities must not contain `fromMap` / `toMap`.

Reference shape:

```dart
class Survey extends Equatable {
  const Survey({
    required this.id,
    required this.title,
    required this.questions,
    required this.coin,
    required this.point,
  });

  final String? id;
  final String? title;
  final int? coin;
  final int? point;
  final List<SurveyQuestion> questions;

  @override
  List<Object?> get props => [id, title, coin, point, questions];
}

class SurveyQuestion extends Equatable {
  const SurveyQuestion({
    required this.id,
    required this.text,
    required this.type,
    required this.answers,
    required this.fileUrl,
  });

  final int? id;
  final int? type;
  final String? text;
  final String? fileUrl;
  final List<SurveyOption> answers;

  @override
  List<Object?> get props => [id, text, type, fileUrl, answers];
}

class SurveyOption extends Equatable {
  const SurveyOption({this.id, this.text});

  final int? id;
  final String? text;

  @override
  List<Object?> get props => [id, text];
}
```

### Basic Entity

```
import 'package:core/core.dart' show Equatable;

class LoginEntity extends Equatable {
  const LoginEntity({
    required this.uuid,
    required this.token,
    required this.level,
    required this.profile,
  });

  final String? uuid;
  final String? token;
  final String? level;
  final ProfileEntity? profile;

  @override
  List<Object?> get props => [uuid, token, level, profile];
}
```

### Entity with Nested Entities

```
class ProfileEntity extends Equatable {
  const ProfileEntity({
    this.userId,
    this.username,
    this.firstname,
    this.lastname,
  });

  final int? userId;
  final String? username;
  final String? firstname;
  final String? lastname;

  @override
  List<Object?> get props => [userId, username, firstname, lastname];
}
```

## Entity Rules

### 1. Immutability

All fields must be `final`:

```
// ✅ Correct
final String token;

// ❌ Wrong
String token; // Mutable
```

### 2. Equatable Implementation

Entities must extend `Equatable` and implement `props`:

```
class LoginEntity extends Equatable {
  @override
  List<Object?> get props => [uuid, token, level];
}
```

**Purpose**: Value equality (two entities with same values are equal)

### 3. No Framework Dependencies

Entities are pure Dart:

```
// ✅ Correct
import 'package:core/core.dart' show Equatable;

// ❌ Wrong
import 'package:flutter/material.dart'; // No Flutter in domain
```

### 4. No JSON Serialization

Entities don't have `fromMap()` or `toMap()`:

```
// ✅ Correct - Entity
class LoginEntity extends Equatable {
  const LoginEntity({required this.token});
  final String? token;
  @override
  List<Object?> get props => [token];
}

// ✅ Correct - Model (in data layer)
class LoginModel extends LoginEntity {
  factory LoginModel.fromMap(Map<String, dynamic> map) { ... }
}
```

## Entity Location

Entities are located in:

```
module_name/src/domain/entities/
  └── entity_name_entity.dart
```

## Entity Usage

### In Use Cases

Use cases return entities:

```
final class GetProfile extends UsecaseWithoutParams<ProfileEntity> {
  const GetProfile(this._repo);
  final ProfileRepository _repo;
  
  @override
  ResultFuture<ProfileEntity> call() => _repo.getProfile();
}
```

### In Repositories

Repository interfaces use entities:

```
abstract interface class AuthRepo {
  ResultFuture<LoginEntity> login({
    required String username,
    required String password,
  });
}
```

### In BLoCs

BLoCs use entities in states:

```
final class LoginSuccess extends LoginState {
  const LoginSuccess(this.user);
  final LoginEntity user;
  @override
  List<Object?> get props => [user];
}
```

## Model-Entity Relationship

**Models** (Data Layer) extend entities:

```
// Domain Entity
class LoginEntity extends Equatable {
  const LoginEntity({required this.token});
  final String? token;
  @override
  List<Object?> get props => [token];
}

// Data Model
class LoginModel extends LoginEntity {
  const LoginModel({required super.token});
  
  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(token: map['token'] as String?);
  }
}
```

**Why**: Models handle JSON serialization, entities represent business concepts.

## Entity Best Practices

### 1. Use Nullable Scalars by Default (API Entities)

```
class ProfileEntity extends Equatable {
  const ProfileEntity({
    required this.userId,
    required this.username,
  });
  
  final int? userId;
  final String? username;
}
```

### 2. Group Related Entities

```
// In same file if closely related
class LoginEntity extends Equatable { ... }
class ProfileEntity extends Equatable { ... }
```

### 3. Use Descriptive Names

```
// ✅ Correct
class UserProfileEntity extends Equatable { ... }

// ❌ Wrong
class Profile extends Equatable { ... } // Missing Entity suffix
```

### 4. Include All Relevant Fields

Entities should represent complete business concepts:

```
class OrderEntity extends Equatable {
  const OrderEntity({
    required this.id,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
  });
  
  final String? id;
  final List<OrderItemEntity> items;
  final double? total;
  final OrderStatus? status;
  final DateTime? createdAt;
}
```

## Common Patterns

### Entity with Enum

```
enum OrderStatus { pending, completed, cancelled }

class OrderEntity extends Equatable {
  const OrderEntity({required this.status});
  final OrderStatus? status;
  @override
  List<Object?> get props => [status];
}
```

### Entity with List

```
class OrderEntity extends Equatable {
  const OrderEntity({required this.items});
  final List<OrderItemEntity> items;
  @override
  List<Object?> get props => [items];
}
```

### Entity with Optional Nested Entity

```
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    this.profile, // Optional
  });
  
  final String? id;
  final ProfileEntity? profile;
  
  @override
  List<Object?> get props => [id, profile];
}
```

## Testing Entities

Entities are easy to test (no dependencies):

```
test('LoginEntity equality', () {
  const entity1 = LoginEntity(token: 'token1', uuid: 'uuid1');
  const entity2 = LoginEntity(token: 'token1', uuid: 'uuid1');
  expect(entity1, equals(entity2));
});
```

## Next Steps

- [Repositories](repositories.md)
- [Use Cases](usecases.md)
