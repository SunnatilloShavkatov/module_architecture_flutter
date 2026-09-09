# /module

Qoida: `docs/rules/module.md`. Etalon modul: `modules/notifications/`.

1. `./scripts/create_module.sh <module_name>` — skeletni skript yaratadi (qo'lda papka ochma).
2. Orkestratsiya: `packages/merge_dependencies/lib/merge_dependencies.dart` ga
   `<Pascal>Container()` qo'sh.
3. Route nomlari `packages/navigation` dagi `Routes` ga qo'shiladi.
4. Modul kontenti: container → injection → router — `modules/notifications/` dagi tartibda.

Qat'iy: `modules/*` boshqa modulni import qilmaydi va `pubspec.yaml` ga yozmaydi.
Modullararo aloqa: `ModuleInteractor`, `PageFactory`, `WidgetFactory<T>`, `Routes`.

Skript `flutter pub get` ni o'zi chaqiradi — bu yagona istisno; boshqa flutter buyrug'ini yozma.

Topshiriq foydalanuvchidan olinadi.

Qoidalar manbasi: `AGENTS.md`. Turn ichida analyze/test/pub get yo'q (§7).
