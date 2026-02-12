# Flutter Module Architecture

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.38+-02569B?logo=flutter)](https://flutter.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean_Architecture-green)](docs/architecture/clean_architecture.md)
[![Maintenance](https://img.shields.io/badge/Maintenace-Production--Ready-brightgreen)](CHANGELOG.md)

An enterprise-grade Flutter monorepo architecture engineered for extreme modularity and multi-team scalability. This repository serves as a meta-framework and architectural blueprint for building high-stakes, long-term mobile applications.

---

## 🚀 Value Proposition

The **Flutter Module Architecture** solves the "cost of change" problem in large-scale mobile development. Traditional "folder-by-feature" structures inevitably collapse under the weight of tight coupling and circular dependencies as teams grow. This project provides a rigid, yet pluggable, infrastructure that treats feature modules as independent services.

### Why this exists?
Most "clean architecture" examples in the Flutter ecosystem are built for single-developer MVPs or Todo apps. They fail to address the **multi-team scalability problem**: how to allow 20+ developers to work on the same codebase simultaneously without stepping on each other's toes. This architecture enforces strict boundaries that make feature isolation a physical reality, not just a naming convention.

### Why you should care?
If you are building a FinTech, E-commerce, or "Super-Apps" that must live for 3-5+ years, you cannot afford architectural drift. This blueprint provides the **DI orchestration, navigation guardrails, and layer isolation** needed to ensure your codebase remains as maintainable on day 1,000 as it was on day 1.

---

## 🏗️ Architectural Pillars

1.  **Modular Monorepo**: Dedicated packages for `core`, `components`, and `navigation` to prevent layer leakage.
2.  **Clean Architecture (Scrubbed)**: Rigid separation of concerns:
    - **Data**: API contracts, persistence, and DTO transformation.
    - **Domain**: Pure Dart business logic and entity definitions (zero framework dependencies).
    - **Presentation**: BLoC-driven state management with exhaustive sealed classes.
3.  **Dependency Aggregation**: Centralized orchestration via the `merge_dependencies` pattern to eliminate "magic" globbing and hidden globals.
4.  **Functional Error Handling**: Standardized `ResultFuture<Either<Failure, T>>` pattern to treat errors as first-class citizens.

---

## 📦 Project Structure

```text
.
├── modules/               # Independent feature modules
│   ├── auth/              # Reference Module: Auth flow
│   ├── home/              # Main feature set
│   └── ...                # Scalable module bucket
├── packages/              # Shared architectural packages
│   ├── core/              # Abstractions, network, & base logic
│   ├── components/        # Standardized UI Design System
│   ├── navigation/        # Centralized routing & guardrails
│   └── merge_dependencies/# The "Orchestrator" (app entry only)
└── docs/                  # In-depth architectural documentation
```

## 🧭 Module Conventions (Real Paths)

The repository contains both `repo` and `repository` naming styles.  
AI/engineers must follow the style of the **target module** and keep it consistent.

### `repo` / `repos` style example

- `modules/auth/lib/src/domain/repos/auth_repo.dart`
- `modules/auth/lib/src/data/repo/auth_repo_impl.dart`

### `repository` style examples

- `modules/home/lib/src/domain/repository/home_repo.dart`
- `modules/home/lib/src/data/repository/home_repository_impl.dart`
- `modules/main/lib/src/domain/repository/main_repo.dart`
- `modules/main/lib/src/data/repository/main_repository_impl.dart`
- `modules/more/lib/src/domain/repository/more_repository.dart`
- `modules/more/lib/src/data/repository/more_repository_impl.dart`

Rule:

- never mix `repo` and `repository` folder styles inside the same module.

---

## 🔍 The Reference Module (Auth)

To ensure consistency across teams, the `modules/auth` serves as the **Gold Standard Reference**. A module in this repository is only considered "Production Ready" if it includes all layers of the Clean Architecture stack without shortcuts.

### Complete Flow Implementation:
- **UI**: `LoginPage` (Presentation)
- **State Management**: `LoginBloc` with `LoginEvent` & `LoginState` (Sealed Classes)
- **Business Logic**: `LoginUseCase` (Domain)
- **Abstract Contract**: `AuthRepo` (Domain)
- **Data Implementation**: `AuthRepoImpl` (Data)
- **Networking**: `AuthRemoteDataSource` using `NetworkProvider` (Data)

### Why no shortcuts?
We do not skip the UseCase layer, even for simple "Pass-through" calls. This ensures that as complexity grows, the business logic has a dedicated home that is not tied to the BLoC or the Repository lifecycle.

---

## 🖼️ Visual Proof & Performance

### State Flow & User Experience
The architecture is designed to handle the complexity of real-world state transitions.

| Loading State | Success Flow | Error Handling |
| :---: | :---: | :---: |
| *[GIF/Screenshot showing Shimmer/Loading]* | *[GIF showing smooth transition]* | *[Screenshot showing BottomSheet Error]* |

> **Note**: Visuals are captured using the `components` library to ensure design consistency across the entire application.

---

## 🛠️ Getting Started

### Prerequisites
- Flutter SDK: `^3.38.0`
- Dart SDK: `^3.10.0`

### Installation
```bash
# Clone the repository
git clone https://github.com/Shavkatov/flutter_module_architecture.git

# Install all dependencies (monorepo)
flutter pub get
```

---

## 🛡️ Trust & Safety
- **[LICENSE](LICENSE)**: Licensed under Apache 2.0.
- **[SECURITY](SECURITY.md)**: Standardized reporting for vulnerabilities.
- **[CONTRIBUTING](CONTRIBUTING.md)**: Rigid rules for PR acceptance.
- **[CHANGELOG](CHANGELOG.md)**: Trackable versioning.

---

## 🚫 Common Trust Killers (Avoidance List)
We maintain a "No-Fluff" policy. This repository explicitly avoids:
- **Empty Modules**: Every module must have a clear purpose or it is removed.
- **"Vague" Documentation**: No "TODO" comments in public APIs.
- **Implicit Dependencies**: Every import is verified to prevent circular dependency debt.
- **Framework Leakage**: The Domain layer is protected by lint rules from importing `package:flutter`.

---

© 2026 Flutter Module Architecture. Built for scale.
