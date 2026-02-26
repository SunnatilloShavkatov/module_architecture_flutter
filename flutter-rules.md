# Flutter Rules (Vibe Coding & Template-Cloning Source of Truth)

This project strictly follows **"Template-Cloning Driven Development"** to minimize AI hallucination, maximize speed (Vibe Coding), and guarantee architectural consistency.

## 1. The Golden Rule of this Repository
**DO NOT INVENT ARCHITECTURE.**
Do not read long architectural theories. Look at existing, verified code and **clone its exact structure, naming conventions, import order, and data mapping logic** for the new feature.

## 2. Where to find the Reference Template?
Before writing any code, you MUST find the Reference Template.
- **Primary Best-Practice Reference:** Use `modules/auth` as the canonical implementation style for production code (`bloc`, `models`, `entities`, `injection`, router/page wiring).
- **Secondary Reference:** Use `docs/TEMPLATE_REFERENCE.md` as structural fallback when `modules/auth` does not cover a required pattern.
- **Alternative:** If a specific existing module path is provided in the prompt, clone that module; if there is a conflict, prefer `modules/auth` conventions.

## 3. The Core Packages Rule
This mono-repo has pre-built packages for abstractions, UI, and routing. **NEVER reinvent these wheels.** Always import and use them:
- **`package:core/core.dart`**: Contains base architecture classes (`UsecaseWithParams`, `UsecaseWithoutParams`, `ResultFuture`, `ResultFeatureVoid`, `ServerException`, `ServerFailure`, `NetworkProvider`, `Injector`, `Injection`).
- **`package:components/components.dart`**: Contains all shared UI elements, themes, and extensions (e.g., `context.color`, `Dimensions.*`, buttons).
- **`package:navigation/navigation.dart`**: Contains universal routing constants.
- **`package:merge_dependencies/merge_dependencies.dart`**: Used ONLY for registering new modules.
- **`package:platform_methods/platform_methods.dart`**: Used for native channels.

*Crucial:* Only import the public barrel files (e.g., `package:core/core.dart`), never internal `src/...` files.

## 4. Strict Cloning Guardrails
When you clone a template, you must retain these absolute rules explicitly shown in the templates:
- **Presentation → Domain ← Data.**
- **BLoC**: `final class XxxBloc`, `sealed` events/states, `Equatable` props, `_<verb><Target>Handler`.
- **DI**: `registerLazySingleton` for data layer, `registerFactory` for presentation layer.
- **Routing**: `GoRouter` only (`context.pushNamed` / `context.goNamed`). `final Args` with `const` constructor.
- **API Endpoints**: For all new modules/features, endpoints must be module-local (e.g., `final class <Feature>ApiPaths` inside the module's datasource/constants). Legacy global `ApiPaths` may exist, but do not clone that pattern into new code.
- **No forbidden APIs**: `Navigator 1.0`, `MediaQuery.of(context)`, `print()`.

## 5. Execution Discipline (Token-Saving)
- **Do not output generic explanations.** 
- **Return only production-ready code** for the requested scope.
- **Work layer-by-layer** if the feature is large (Domain → Data → Presentation).
