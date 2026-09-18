# /module

Rules: `docs/rules/module.md`. Reference module: `modules/notifications/`.

1. `./scripts/create_module.sh <module_name>` — the script creates the skeleton (don't create folders by hand).
2. Orchestration: add `<Pascal>Container()` to `packages/merge_dependencies/lib/merge_dependencies.dart`.
3. Add route names to `Routes` in `packages/navigation`.
4. Module content order: container → injection → router — matching `modules/notifications/`.

Hard rule: `modules/*` never imports another module or lists it in `pubspec.yaml`.
Cross-module communication: `ModuleInteractor`, `PageFactory`, `WidgetFactory<T>`, `Routes`.

The script calls `flutter pub get` itself — that is the one exception; don't run any other flutter command.

Task is taken from the user.

Rules source: `AGENTS.md`. No analyze/test/pub get during a turn (§7).
