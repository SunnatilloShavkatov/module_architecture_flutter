# Clean Architecture

This document explains how Clean Architecture is implemented in this project, including layer boundaries, dependency rules, and data flow.

## Three-Layer Architecture

The project strictly follows Clean Architecture with three layers:

```
┌─────────────────────────────────────┐
│      Presentation Layer              │
│  (UI, BLoC, Pages, Widgets)         │
└──────────────┬──────────────────────┘
               │ depends on
┌──────────────▼──────────────────────┐
│         Domain Layer                 │
│  (Entities, Use Cases, Repos)       │
└──────────────┬──────────────────────┘
               │ implemented by
┌──────────────▼──────────────────────┐
│          Data Layer                 │
│  (Data Sources, Models, Repo Impl)  │
└─────────────────────────────────────┘
```

## Layer Details

### Presentation Layer

**Location**: `modules/*/src/presentation/`

**Responsibilities**:
- Render UI based on state
- Handle user interactions
- Manage UI state via BLoC
- Navigate between screens

**Dependencies**:
- ✅ Domain layer (use cases, entities)
- ✅ Shared packages (`core`, `components`, `navigation`)
- ❌ Data layer (never directly)

**Key Components**:
- **Pages**: Full-screen widgets (`*_page.dart`)
- **BLoCs**: State management (`*_bloc.dart`, `*_event.dart`, `*_state.dart`)
- **Widgets**: Feature-specific reusable components

**Example**:
```dart
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.get<LoginBloc>(),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          // Render UI based on state
        },
      ),
    );
  }
}
```

### Domain Layer

**Location**: `modules/*/src/domain/`

**Responsibilities**:
- Define business entities
- Define repository contracts (interfaces)
- Implement business logic via use cases
- Define business rules

**Dependencies**:
- ✅ None (pure Dart)
- ❌ No Flutter dependencies
- ❌ No data layer dependencies

**Key Components**:
- **Entities**: Immutable business objects (`*_entity.dart`)
- **Repositories**: Abstract interfaces (`*_repo.dart` or `*_repository.dart`)
- **Use Cases**: Business operations (`*_usecase.dart`)

**Example**:
```
// Entity
class LoginEntity extends Equatable {
  const LoginEntity({required this.token, required this.userId});
  final String token;
  final int userId;
  @override
  List<Object?> get props => [token, userId];
}

// Repository Interface
abstract interface class AuthRepo {
  ResultFuture<LoginEntity> login({required String username, required String password});
}

// Use Case
final class Login extends UsecaseWithParams<LoginEntity, LoginParams> {
  const Login(this._repo);
  final AuthRepo _repo;
  
  @override
  ResultFuture<LoginEntity> call(LoginParams params) => _repo.login(
    username: params.username,
    password: params.password,
  );
}
```

### Data Layer

**Location**: `modules/*/src/data/`

**Responsibilities**:
- Fetch data from remote APIs
- Store/retrieve data from local storage
- Transform data between formats (JSON ↔ Entity)
- Handle network errors and exceptions

**Dependencies**:
- ✅ Domain layer (implements repository interfaces, uses entities)
- ✅ Core package (network provider, error handling)
- ❌ Presentation layer (never)

**Key Components**:
- **Data Sources**: Remote and local data access (`*_data_source.dart`, `*_data_source_impl.dart`)
- **Models**: JSON serialization (`*_model.dart`)
- **Repository Implementations**: Coordinate data sources (`*_repo_impl.dart` or `*_repository_impl.dart`)

**Example**:
```
// Data Source Interface
abstract interface class AuthRemoteDataSource {
  Future<LoginModel> login({required String username, required String password});
}

// Data Source Implementation
final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._networkProvider);
  final NetworkProvider _networkProvider;
  
  @override
  Future<LoginModel> login({required String username, required String password}) async {
    try {
      final result = await _networkProvider.fetchMethod<DataMap>(
        ApiPaths.login,
        methodType: RMethodTypes.post,
        data: {'username': username, 'password': password},
      );
      return LoginModel.fromMap(result.data ?? {});
    } on ServerException {
      rethrow;
    } on Exception catch (e) {
      throw ServerException.unknownError(locale: _networkProvider.locale);
    }
  }
}

// Repository Implementation
final class AuthRepoImpl implements AuthRepo {
  const AuthRepoImpl(this._remoteSource, this._localSource);
  final AuthRemoteDataSource _remoteSource;
  final AuthLocalDataSource _localSource;
  
  @override
  ResultFuture<LoginEntity> login({required String username, required String password}) async {
    try {
      final model = await _remoteSource.login(username: username, password: password);
      await _localSource.saveUser(model);
      return Right(model); // Model extends Entity
    } on ServerException catch (error, _) {
      return Left(error.failure);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
```

## Dependency Rules

### Rule 1: Dependency Direction

Dependencies **always point inward**:

```
Presentation → Domain ← Data
```

- Presentation depends on Domain
- Data depends on Domain
- Domain depends on **nothing**

### Rule 2: No Circular Dependencies

- Presentation never imports from Data
- Data never imports from Presentation
- Domain never imports from either layer

### Rule 3: Interface Segregation

- Domain defines repository **interfaces**
- Data implements repository **implementations**
- Presentation uses domain interfaces only

### Rule 4: Dependency Inversion

- High-level modules (Presentation) depend on abstractions (Domain)
- Low-level modules (Data) implement abstractions (Domain interfaces)

## Data Flow

### Request Flow (User Action → Data)

```
1. User taps button
   ↓
2. UI dispatches BLoC event
   ↓
3. BLoC calls use case
   ↓
4. Use case calls repository interface
   ↓
5. Repository implementation coordinates data sources
   ↓
6. Data source fetches from API/storage
   ↓
7. Data transformed to model
   ↓
8. Model converted to entity
   ↓
9. Entity returned via Either<Failure, Entity>
```

### Response Flow (Data → UI Update)

```
1. Repository returns Either<Failure, Entity>
   ↓
2. Use case returns Either<Failure, Entity>
   ↓
3. BLoC receives Either
   ↓
4. BLoC emits state (Success or Failure)
   ↓
5. UI rebuilds based on state
```

## Model-Entity Relationship

**Models** (Data Layer):
- Extend entities
- Have `fromMap()` and `toMap()` methods
- Handle JSON serialization
- May have additional fields for API response
- Keep list fields non-null and scalar/object fields nullable for API-driven contracts

**Entities** (Domain Layer):
- Pure Dart classes
- Extend `Equatable`
- Immutable
- No JSON serialization logic
- For API responses: list fields non-null, other fields nullable

**Pattern**:
```
class SurveyEntity extends Equatable {
  const SurveyEntity({
    required this.id,
    required this.title,
    required this.questions,
  });

  final String? id;
  final String? title;
  final List<SurveyQuestionEntity> questions;

  @override
  List<Object?> get props => [id, title, questions];
}

class SurveyModel extends SurveyEntity {
  const SurveyModel({
    required super.id,
    required super.title,
    required super.questions,
  });

  factory SurveyModel.fromMap(Map<String, dynamic> map) {
    final Map<String, dynamic> data =
        map['result'] is Map<String, dynamic> ? map['result'] as Map<String, dynamic> : <String, dynamic>{};
    final List<SurveyQuestionModel> questions = [];

    if (data['questions'] is List) {
      final List<dynamic> items = data['questions'] as List<dynamic>;
      for (int i = 0; i < items.length; i++) {
        final dynamic item = items[i];
        if (item is Map<String, dynamic>) {
          questions.add(SurveyQuestionModel.fromMap(item));
        }
      }
    }

    return SurveyModel(
      id: data['id'] as String?,
      title: data['name'] as String?,
      questions: questions,
    );
  }

  factory SurveyModel.fromEntity(SurveyEntity entity) {
    final List<SurveyQuestionModel> questions = [];
    for (int i = 0; i < entity.questions.length; i++) {
      questions.add(SurveyQuestionModel.fromEntity(entity.questions[i]));
    }

    return SurveyModel(
      id: entity.id,
      title: entity.title,
      questions: questions,
    );
  }

  Map<String, dynamic> toMap() {
    final List<Map<String, dynamic>> questions = [];
    for (int i = 0; i < this.questions.length; i++) {
      questions.add((this.questions[i] as SurveyQuestionModel).toMap());
    }

    return {
      'id': id,
      'name': title,
      'questions': questions,
    };
  }
}

class SurveyQuestionEntity extends Equatable {
  const SurveyQuestionEntity({
    required this.id,
    required this.text,
    required this.answers,
  });

  final int? id;
  final String? text;
  final List<SurveyOptionEntity> answers;

  @override
  List<Object?> get props => [id, text, answers];
}

class SurveyQuestionModel extends SurveyQuestionEntity {
  const SurveyQuestionModel({
    required super.id,
    required super.text,
    required super.answers,
  });

  factory SurveyQuestionModel.fromMap(Map<String, dynamic> map) {
    final List<SurveyOptionModel> answers = [];
    if (map['answers'] is List) {
      final List<dynamic> items = map['answers'] as List<dynamic>;
      for (int i = 0; i < items.length; i++) {
        final dynamic item = items[i];
        if (item is Map<String, dynamic>) {
          answers.add(SurveyOptionModel.fromMap(item));
        }
      }
    }

    return SurveyQuestionModel(
      id: map['id'] as int?,
      text: map['text'] as String?,
      answers: answers,
    );
  }

  factory SurveyQuestionModel.fromEntity(SurveyQuestionEntity entity) {
    final List<SurveyOptionModel> answers = [];
    for (int i = 0; i < entity.answers.length; i++) {
      answers.add(SurveyOptionModel.fromEntity(entity.answers[i]));
    }

    return SurveyQuestionModel(
      id: entity.id,
      text: entity.text,
      answers: answers,
    );
  }

  Map<String, dynamic> toMap() {
    final List<Map<String, dynamic>> answers = [];
    for (int i = 0; i < this.answers.length; i++) {
      answers.add((this.answers[i] as SurveyOptionModel).toMap());
    }

    return {
      'id': id,
      'text': text,
      'answers': answers,
    };
  }
}

class SurveyOptionEntity extends Equatable {
  const SurveyOptionEntity({required this.id, required this.text});

  final int? id;
  final String? text;

  @override
  List<Object?> get props => [id, text];
}

class SurveyOptionModel extends SurveyOptionEntity {
  const SurveyOptionModel({required super.id, required super.text});

  factory SurveyOptionModel.fromMap(Map<String, dynamic> map) {
    return SurveyOptionModel(
      id: map['id'] as int?,
      text: map['text'] as String?,
    );
  }

  factory SurveyOptionModel.fromEntity(SurveyOptionEntity entity) {
    return SurveyOptionModel(
      id: entity.id,
      text: entity.text,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
    };
  }
}
```

## Error Handling Flow

Errors flow **upward** through layers:

```
Data Source (throws Exception)
   ↓
Repository Implementation (catches, converts to Failure)
   ↓
Use Case (returns Either<Failure, T>)
   ↓
BLoC (handles Either, emits Failure state)
   ↓
UI (displays error message)
```

**Exception Types**:
- `ServerException`: Network/API errors (converted to `ServerFailure`)
- `FormatException`: JSON parsing errors (converted to `ServerFailure`)
- Generic `Exception`: Unknown errors (converted to `ServerFailure`)

## Testing Strategy

### Domain Layer Tests
- Test use cases with mock repositories
- Test entities for equality
- No Flutter dependencies needed

### Data Layer Tests
- Test repository implementations with mock data sources
- Test model serialization/deserialization
- Test error handling

### Presentation Layer Tests
- Test BLoC with mock use cases
- Test pages/widgets with mock BLoC
- Widget tests with Flutter test framework

## Benefits

1. **Testability**: Business logic independent of UI and data sources
2. **Maintainability**: Clear boundaries, easy to locate code
3. **Flexibility**: Easy to swap implementations (e.g., different data sources)
4. **Scalability**: New features follow same pattern
5. **Team Collaboration**: Teams can work on different layers independently

## Common Mistakes to Avoid

❌ **BLoC calling repository directly**
```
// Wrong
final class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._repo); // ❌ Repository in BLoC
  final AuthRepo _repo;
}
```

✅ **BLoC calling use case**
```
// Correct
final class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._loginUseCase); // ✅ Use case in BLoC
  final Login _loginUseCase;
}
```

❌ **Entity with JSON serialization**
```
// Wrong
class LoginEntity {
  factory LoginEntity.fromMap(Map<String, dynamic> map) { ... } // ❌
}
```

✅ **Model extends Entity**
```
// Correct
class LoginModel extends LoginEntity {
  factory LoginModel.fromMap(Map<String, dynamic> map) { ... } // ✅
}
```

## Next Steps

- [Module Structure](module_structure.md)
- [Dependency Injection](dependency_injection.md)
- [Domain Layer](../domain_layer/entities.md)
