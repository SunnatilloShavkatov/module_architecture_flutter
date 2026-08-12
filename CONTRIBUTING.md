# Contributing Guide

Thank you for your interest in contributing to this project!

This repository follows a **strict modular Clean Architecture** approach with well-defined patterns
and conventions. Please read this document carefully before opening a Pull Request.

---

## 📐 Architecture Rules (Mandatory)

This project uses **Module-based Clean Architecture** with three distinct layers.

### Layer Dependency Rules

| Layer            | Can Depend On | Cannot Depend On                      |
|------------------|---------------|---------------------------------------|
| **Presentation** | Domain only   | Data layer, Repositories directly     |
| **Domain**       | Nothing       | Flutter, External packages, Any layer |
| **Data**         | Domain only   | Presentation layer                    |

### Critical Rules

❌ **Presentation Layer MUST NOT**:

- Access repositories directly (use UseCases instead)
- Import from Data layer
- Access data sources
- Use models (use entities instead)

❌ **Domain Layer MUST NOT**:

- Depend on Flutter framework
- Import external packages (except Dart SDK)
- Know about UI or data sources
- Have any framework dependencies

✅ **Data Layer MUST**:

- Implement repository contracts from Domain
- Handle data transformation (Model ↔ Entity)
- Manage API calls and local storage
- Catch exceptions and convert to Failures

---

## 📦 Module Structure

Each module **MUST** follow this exact structure:

```
modules/module_name/
├── lib/
│   ├── module_name.dart              # Public API (exports container only)
│   └── src/
│       ├── module_name_container.dart # Module registration
│       ├── data/                      # Data Layer
│       │   ├── datasource/
│       │   │   ├── module_remote_datasource.dart       # Abstract
│       │   │   └── module_remote_datasource_impl.dart  # Implementation
│       │   ├── models/
│       │   │   └── module_model.dart  # Extends entity, has JSON
│       │   └── repo/
│       │       └── module_repo_impl.dart  # Implements domain repo
│       ├── di/                        # Dependency Injection
│       │   └── module_injection.dart
│       ├── domain/                    # Domain Layer
│       │   ├── entities/
│       │   │   └── module_entity.dart  # Pure Dart, extends Equatable
│       │   ├── repo/
│       │   │   └── module_repo.dart    # Abstract repository
│       │   └── usecases/
│       │       └── module_usecase.dart # Business logic
│       ├── presentation/              # Presentation Layer
│       │   └── feature_name/
│       │       ├── bloc/
│       │       │   ├── feature_bloc.dart   # BLoC logic
│       │       │   ├── feature_event.dart  # Sealed events
│       │       │   └── feature_state.dart  # Sealed states
│       │       ├── widgets/
│       │       │   └── feature_widget.dart
│       │       └── feature_page.dart
│       └── router/                    # Module routing
│           └── module_router.dart
└── pubspec.yaml
```

---

## 🎯 Code Standards

### File Naming

```
✅ DO:
login_page.dart
user_entity.dart
auth_repository.dart
get_user_usecase.dart

❌ DON'T:
LoginPage.dart
UserEntity.dart
authRepository.dart
GetUserUseCase.dart
```

**Rules**:

- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables: `camelCase`
- Private members: `_camelCase`
- Constants: `kCamelCase` or `UPPER_SNAKE_CASE` (static final)

### Class Structure

#### Entity (Domain Layer)

```
final class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
```

#### Model (Data Layer)

```
final class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
```

#### Repository Abstract (Domain Layer)

```
part '../../data/repo/user_repo_impl.dart';

abstract class UserRepo {
  ResultFuture<UserEntity> getUser({required int id});
}
```

#### Repository Implementation (Data Layer)

```
part of '../../domain/repo/user_repo.dart';

final class UserRepoImpl implements UserRepo {
  const UserRepoImpl(this._remoteDataSource);

  final UserRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<UserEntity> getUser({required int id}) async {
    try {
      final result = await _remoteDataSource.getUser(id: id);
      return Right(result);
    } on ServerException catch (error) {
      return Left(error.failure);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
```

#### Use Case (Domain Layer)

```
final class GetUser extends UseCase<UserEntity, GetUserParams> {
  const GetUser(this._repository);

  final UserRepo _repository;

  @override
  ResultFuture<UserEntity> call(GetUserParams params) {
    return _repository.getUser(id: params.id);
  }
}

final class GetUserParams extends Equatable {
  const GetUserParams({required this.id});

  final int id;

  @override
  List<Object?> get props => [id];
}
```

#### Bloc (Presentation Layer)

```
// Events
sealed class UserEvent extends Equatable {
  const UserEvent();
}

final class FetchUser extends UserEvent {
  const FetchUser({required this.id});

  final int id;

  @override
  List<Object?> get props => [id];
}

// States
sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserLoaded extends UserState {
  const UserLoaded({required this.user});

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

final class UserError extends UserState {
  const UserError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

// BLoC
final class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(this._getUserUseCase) : super(UserInitial()) {
    on<FetchUser>(_onFetchUser);
  }

  final GetUser _getUserUseCase;

  Future<void> _onFetchUser(FetchUser event,
      Emitter<UserState> emit,) async {
    emit(UserLoading());
    final result = await _getUserUseCase(
      GetUserParams(id: event.id),
    );
    result.fold(
          (failure) => emit(UserError(message: failure.message)),
          (user) => emit(UserLoaded(user: user)),
    );
  }
}
```

---

## 🔌 Dependency Injection

### Module Injection

```
final class ModuleInjection implements Injection {
  const ModuleInjection();

  @override
  FutureOr<void> registerDependencies({required Injector di}) {
    // Data sources
    di.registerLazySingleton<ModuleRemoteDataSource>(
          () => ModuleRemoteDataSourceImpl(di.get()),
    );

    // Repositories
    di.registerLazySingleton<ModuleRepo>(
          () => ModuleRepoImpl(di.get()),
    );

    // Use cases
    di.registerLazySingleton<GetModuleData>(
          () => GetModuleData(di.get()),
    );

    // BLocs
    di.registerFactory(
          () => ModuleBloc(di.get()),
    );
  }
}
```

### Lifecycle Rules

| Registration            | Lifecycle                           | Use For                  |
|-------------------------|-------------------------------------|--------------------------|
| `registerSingleton`     | Created immediately, lives forever  | Pre-initialized services |
| `registerLazySingleton` | Created on first use, lives forever | Repositories, UseCases   |
| `registerFactory`       | Created every time                  | BLocs, ViewModels        |

---

## 🧭 Navigation

### Route Definition

```
final class ModuleRouter implements AppRouter<RouteBase> {
  const ModuleRouter();

  @override
  List<GoRoute> getRouters(Injector di) =>
      [
        GoRoute(
          path: Routes.modulePage,
          name: Routes.modulePage,
          builder: (context, state) => const ModulePage(),
        ),
      ];
}
```

### Navigation Rules

- ✅ Use `GoRouter` for all navigation
- ✅ Route names defined in `Routes` class (`navigation` package)
- ✅ Pass data via `state.extra` or route parameters
- ❌ Never use `Navigator.push` directly
- ❌ Never hardcode route strings

---

## 🎨 UI Guidelines

### Use Shared Components

```
// ✅ DO: Use components package
import 'package:components/components.dart';

SafeAreaWithMinimum(
  minimum: Dimensions.kPaddingAll16,
  child: CustomLoadingButton(
    onPressed: () {},
    child: Text('Submit'),
  ),
)

// ❌ DON'T: Create custom components in modules
SafeArea(
  child: Container(
    padding: const EdgeInsets.all(16.0),
    child: ElevatedButton(
      onPressed: () {},
      child: Text('Submit'),
    ),
  ),
)
```

### Styling Rules

```
// ✅ DO: Use theme extensions
Text(
  'Hello',
  style: context.textStyle.defaultW700x24,
)

Container(
  color: context.color.primary,
  padding: Dimensions.kPaddingAll16,
)

// ❌ DON'T: Hardcode styles
Text(
  'Hello',
  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
)

Container(
  color: Colors.blue,
  padding: EdgeInsets.all(16.0),
)
```

---

## 📦 Package Usage

### Module Dependencies

```yaml
# module/pubspec.yaml
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

### Import Rules

```
// ✅ DO: Import packages correctly
import 'package:core/core.dart';
import 'package:components/components.dart';
import 'package:navigation/navigation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ❌ DON'T: Import merge_dependencies in modules
import 'package:merge_dependencies/merge_dependencies.dart';
```

---

## ✅ Pull Request Checklist

Before submitting a PR, ensure:

### Code Quality

- [ ] All files follow naming conventions (`snake_case.dart`)
- [ ] Classes follow architecture patterns (Entity/Model/UseCase/BLoC)
- [ ] No hardcoded strings, colors, or dimensions
- [ ] Used `final` for immutable variables
- [ ] Used `const` constructors where possible

### Architecture

- [ ] Presentation layer only depends on Domain
- [ ] Domain layer has no external dependencies
- [ ] Data layer implements Domain contracts
- [ ] Bloc calls UseCases, not repositories
- [ ] Entities are pure Dart (no JSON serialization)
- [ ] Models extend entities and have JSON serialization

### State Management

- [ ] Events and States are `sealed class`
- [ ] All events/states extend `Equatable`
- [ ] Bloc event handlers are private (`_onEventName`)
- [ ] Error states include error messages

### Dependencies

- [ ] Dependencies registered in module injection
- [ ] Correct lifecycle used (singleton/lazySingleton/factory)
- [ ] No circular dependencies
- [ ] Module container created and exported

### UI/UX

- [ ] Used `SafeAreaWithMinimum` instead of `SafeArea`
- [ ] Used `Dimensions` constants for spacing
- [ ] Used `context.color` and `context.textStyle`
- [ ] Used `CustomLoadingButton` for primary buttons
- [ ] Widgets are reasonably sized (< 300 lines)

### Navigation

- [ ] Routes defined in module router
- [ ] Route names use `Routes` constants
- [ ] No hardcoded route strings
- [ ] Module registered in `merge_dependencies`

### Testing

- [ ] No lint errors (`flutter analyze`)
- [ ] Code formatted (`flutter format .`)
- [ ] App builds successfully
- [ ] Manual testing completed

### Documentation

- [ ] Complex logic has comments
- [ ] Public APIs have documentation
- [ ] README updated if needed

---

## 🚫 Common Mistakes to Avoid

### ❌ Bloc Calling Repository Directly

```
// WRONG
final result = await _repository.getUser(userId: '123');

// CORRECT
final result = await _getUserUseCase(GetUserParams(userId: '123'));
```

### ❌ Entity with JSON Serialization

```
// WRONG - Domain entity should not have JSON
final class UserEntity {
  const UserEntity({required this.id, required this.name});
  final String id;
  final String name;

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

// CORRECT - Keep domain pure
final class UserEntity extends Equatable {
  const UserEntity({required this.id, required this.name});
  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

// JSON in Model (Data layer)
final class UserModel extends UserEntity {
  const UserModel({required super.id, required super.name});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  UserEntity toEntity() => UserEntity(id: id, name: name);
}
```

### ❌ Hardcoded Values

```
// WRONG
Container(
  padding: EdgeInsets.all(16.0),
  color: Color(0xFF2196F3),
)

// CORRECT
Container(
  padding: EdgeInsets.all(Dimensions.kPaddingAll16),
  color: context.color.primary,
)
```

### ❌ Importing Merge Dependencies in Modules

```
// WRONG - in module code
import 'package:merge_dependencies/merge_dependencies.dart';

// CORRECT
import 'package:core/core.dart';
import 'package:components/components.dart';
import 'package:navigation/navigation.dart';
```

### ❌ Non-Sealed Event/State Classes

```
// WRONG
abstract class LoginEvent extends Equatable {}

class LoginSubmitted extends LoginEvent {}

// CORRECT
sealed class LoginEvent extends Equatable {}

final class LoginSubmitted extends LoginEvent {}
```

---

## 🔄 Contribution Workflow

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/my-feature`
3. **Follow** architecture rules and code standards
4. **Test** your changes thoroughly
5. **Commit** with clear messages: `git commit -m "feat: add user profile page"`
6. **Push** to your fork: `git push origin feature/my-feature`
7. **Open** a Pull Request with description

### Commit Message Format

```
<type>: <description>

[optional body]
[optional footer]
```

**Types**:

- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code refactoring
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `test`: Adding tests
- `chore`: Maintenance tasks

**Examples**:

```
feat: add user authentication module
fix: resolve null check error in profile page
refactor: extract common widget to components package
docs: update README with new module structure
```

---

## 📚 Additional Resources

- [Architecture Overview](docs/architecture/overview.md)
- [Clean Architecture Guide](docs/architecture/clean_architecture.md)
- [Module Structure Details](docs/architecture/module_structure.md)
- [Dependency Injection Guide](docs/architecture/dependency_injection.md)
- [Domain Layer Patterns](docs/domain_layer)
- [CLAUDE.md (Complete)](CLAUDE.md)

---

## 🆘 Getting Help

- **Architecture Questions**: See [docs/architecture/](docs/architecture)
- **Code Patterns**: See [CLAUDE.md](CLAUDE.md)
- **Issues**: Open a GitHub issue with the `question` label

---

## 🙏 Thank You

Your contributions make this project better! By following these guidelines, you help maintain code
quality, consistency, and scalability.

**Remember**:

- Clean Architecture is non-negotiable
- Domain layer stays pure
- Bloc calls UseCases, not repositories
- Follow naming conventions
- Use shared components and packages

Happy coding! 🚀
