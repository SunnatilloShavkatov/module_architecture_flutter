# Flutter Module Architecture

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.47+-02569B?logo=flutter)](https://flutter.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean_Architecture-green)](docs/README.md)
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
    - **Presentation**: Bloc-driven state management with exhaustive sealed classes.
3.  **Dependency Aggregation**: Centralized orchestration via the `merge_dependencies` pattern to eliminate "magic" globbing and hidden globals.
4.  **Functional Error Handling**: Standardized `ResultFuture<Either<Failure, T>>` pattern to treat errors as first-class citizens.

---

## 📦 Project Structure

```text
.
├── modules/               # Independent feature modules
│   ├── auth/              # Reference Module: Auth flow
│   ├── notifications/     # Full Standard Reference Module
│   ├── home/              # Main feature set
│   └── ...                # Scalable module bucket
├── packages/              # Shared architectural packages
│   ├── core/              # Abstractions, network, & base logic
│   ├── components/        # Standardized UI Design System
│   ├── navigation/        # Centralized routing & guardrails
│   └── merge_dependencies/# The "Orchestrator" (app entry only)
└── docs/                  # Architecture rules & agent docs (see docs/README.md)
```

## 🧭 Module Conventions (Real Paths)

There is exactly one canonical repository convention — see [`AGENTS.md`](AGENTS.md) §6:

| Layer | Folder | Interface | Implementation |
|---|---|---|---|
| Domain | `lib/src/domain/repository/` | `<Module>Repository` | — |
| Data | `lib/src/data/repository/` | — | `<Module>RepositoryImpl` |

```text
modules/notifications/lib/src/domain/repository/notifications_repository.dart   # NotificationsRepository
modules/notifications/lib/src/data/repository/notifications_repository_impl.dart # NotificationsRepositoryImpl
```

`home`, `main`, `notifications`, `payments` and `profile` all follow this. The single exception is
**`auth`**, which still uses the legacy `domain/repos/` + `data/repo/` folders and the `AuthRepo` /
`AuthRepoImpl` names; it is tracked in [`.claude/rules/migration-list.md`](.claude/rules/migration-list.md) §1.

Rules:

- The file name and the class name must match: `*_repository.dart` → `*Repository`, `*_repository_impl.dart` → `*RepositoryImpl`.
- Never introduce a new `repo` / `repos` folder or a `*Repo` class name.

---

## 🔍 Gold Standard Reference Modules

To ensure consistency across teams, the repository provides comprehensive reference implementations:
- **`modules/notifications`**: Full 6-layer Clean Architecture reference with 100% unit & BLoC test coverage.
- **`modules/auth`**: Reference for authentication flow and localized presentation.

All architectural rules and guidelines are documented under [`docs/README.md`](docs/README.md).

---

## 🖼️ Visual Proof & Performance

### State Flow & User Experience
The architecture is designed to handle the complexity of real-world state transitions.

|               Loading State                |           Success Flow            |              Error Handling              |
|:------------------------------------------:|:---------------------------------:|:----------------------------------------:|
| *[GIF/Screenshot showing Shimmer/Loading]* | *[GIF showing smooth transition]* | *[Screenshot showing BottomSheet Error]* |

> **Note**: Visuals are captured using the `components` library to ensure design consistency across the entire application.

---

## 🛠️ Getting Started

### Prerequisites
- Flutter SDK: `^3.47.0`
- Dart SDK: `^3.13.0`

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
- **Empty Modules**: Every module must have a clear purpose, or it is removed.
- **"Vague" Documentation**: No "TODO" comments in public APIs.
- **Implicit Dependencies**: Every import is verified to prevent circular dependency debt.
- **Framework Leakage**: The Domain layer is protected by lint rules from importing `package:flutter`.

---

© 2026 Flutter Module Architecture. Built for scale.
