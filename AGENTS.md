# AGENTS.md (AI Assistant Instructions)

## Default Mode: Vibe Coding (Template-Cloning)

This project explicitly rejects long, theoretical architectural prompts. Instead, you are required to act as an aggressive **Architecture Cloner**.

### Your Mandatory Startup Protocol
1. **Identify the Reference**: Use `docs/TEMPLATE_REFERENCE.md` as the absolute standard, or a specific existing module if explicitly provided by the user.
2. **Read the Reference**: Inspect the reference's `bloc`, `models`, `entities`, and `injection` files.
3. **Execute the Clone**: Write the requested feature by performing a 1:1 structural and syntactical mapping of the reference code onto the new domain requirements.

### Prohibitions
- NEVER invent a new way to parse JSON. Clone the exact `fromMap`/`toMap` syntax from the reference.
- NEVER invent new BLoC state patterns. Clone the exact `sealed class` and `final class` hierarchy.
- NEVER write dummy/placeholder code. You must output production-ready logic.
- NEVER invent new base classes. ALWAYS use the abstractions provided in the project's core packages:
  - `package:core/core.dart` (for `UsecaseWithoutParams`, `ResultFuture`, `ServerException`, `NetworkProvider`, etc.)
  - `package:components/components.dart` (for pre-built UI widgets like `CustomLoadingButton`, `SafeAreaWithMinimum`, etc.)
  - `package:navigation/navigation.dart` (for GoRouter configuration and paths)
  - `package:merge_dependencies/merge_dependencies.dart` (for module registration)
  - `package:platform_methods/platform_methods.dart` (for native bridges)
- NEVER define global API endpoints. Each module MUST have its own isolated API paths (e.g., `final class <Feature>ApiPaths` inside the module's datasource or a dedicated module-scoped constants file).
- NEVER give long Markdown explanations of *why* you wrote the code. Return only the filename headers and the code blocks.

### Deliverable Contract
- Give the file path.
- Give the code block.
- Nothing else.
