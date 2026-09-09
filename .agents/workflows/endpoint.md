# /endpoint

Etalon: `modules/notifications/lib/src/data/` (api_paths, datasource + impl, models, repository impl)
va `modules/notifications/lib/src/domain/` (entity, repository interfeysi, usecase).
Qoida: `docs/rules/data-api.md` TL;DR bloki; domain qatlami uchun `docs/rules/domain.md`.

Talab:
- `fromMap` / `toMap` — hech qachon `fromJson` / `toJson`
- yo'l `<Module>ApiPaths` ga qo'shiladi
- `abstract interface class` — datasource / repository interfeysi; `final class` — impl
- domain sof Dart: `package:flutter/*` yoki `material_ui` importi yo'q
- natija `Either<Failure, T>`; usecase `class <Verb><Noun>`
- DI: `modules/<module>/lib/src/di/<module>_injection.dart` yangilanadi

Turn ichida analyze/test ishlatma.

Topshiriq foydalanuvchidan olinadi.

Qoidalar manbasi: `AGENTS.md`. Turn ichida analyze/test/pub get yo'q (§7).
