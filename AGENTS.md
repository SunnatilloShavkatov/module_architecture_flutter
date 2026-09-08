# AGENTS.md — Modular Architecture Standarti va Qoidalari

> **Asosiy qoida:** Foydalanuvchiga barcha javoblar va tushuntirishlar **O'zbek tilida**, kod, identifikatorlar va izohlar esa **Ingliz tilida** yoziladi.
> Bu loyiha — mustaqil etalon shablon (template). Barcha etalonlar shu loyihaning o'zida to'liq implement qilingan.

## 1. Arxitektura va Modul Tuzilishi

Loyiha Feature-First va Clean Architecture tamoyillariga asoslangan:
- `modules/<module>/lib/src/`:
  - `domain/`: `entities/`, `repository/`, `usecases/`, `interactor/` (tashqi framework yoki UI bog'liqligi yo'q).
  - `data/`: `datasource/` (`*_remote_data_source.dart` + `part '*_remote_data_source_impl.dart'`), `models/`, `repository/`.
  - `presentation/`: `<feature>/` (`bloc/`, `mixin/`, `widgets/`, `args/`, `factory/`), `<feature>_page.dart`.
  - `di/`: `<module>_injection.dart` (`Injection` interfeysi orqali DI ro'yxatdan o'tkazish).
  - `router/`: `<module>_router.dart` (`AppRouter` interfeysi, `CupertinoRoute`, `MaterialSheetRoute`, `MaterialDialogRoute`).
  - `container/`: `<module>_container.dart` (`ModuleContainer` orqali router va DI ni eksport qilish).

> Tafsilotlar: `docs/rules/module.md`

## 2. Qoidalar Kartasi (Rules Map)

AI Agent har bir vazifani bajarishdan oldin mos qoida faylini o'qishi shart:

| Mavzu | Qoida fayli | Loyihadagi Haqiqiy Etalon |
|---|---|---|
| Modul va qatlamlar | `docs/rules/module.md` | `modules/notifications/lib/src/container/notifications_container.dart` |
| BLoC, Event, State | `docs/rules/bloc.md` | `modules/notifications/lib/src/presentation/notifications/bloc/` |
| Sahifa, Mixin, Lifecycle | `docs/rules/page-mixin.md` | `modules/notifications/lib/src/presentation/notifications/` |
| Data, Remote DS, Model | `docs/rules/data-api.md` | `modules/notifications/lib/src/data/` |
| Router, Navigatsiya, Args | `docs/rules/navigation.md` | `modules/notifications/lib/src/router/notifications_router.dart` |
| UI, Dimensions, MaterialUI | `docs/rules/ui.md` | `modules/notifications/lib/src/presentation/notifications/notifications_page.dart` |
| Lokalizatsiya (l10n) | `docs/rules/l10n.md` | `packages/core/lib/src/l10n/` & `modules/auth/lib/src/presentation/login/login_page.dart` |
| Testlash (Unit, Bloc, Repo)| `docs/rules/testing.md` | `modules/notifications/test/notifications_test.dart` |

## 3. Eng Ko'p Xato Qilinadigan 7 Qoida (Non-negotiables)

1. **Dart 3.47 Constructor Shorthand**: Deklaratsiyalarda `const new(...)`, `new(...)`, `const new _()`, `factory parse(...)` ishlatiladi. Chaqiruv joylarida klass nomi saqlanadi (`NotificationModel(...)`).
2. **Material UI Import**: Hech qachon `package:flutter/material.dart` import qilinmaydi. Faqat `package:material_ui/material_ui.dart` va `package:components/components.dart`.
3. **Bo'shliq va O'lchamlar**: Xom `SizedBox(height: ..., width: ...)` taqiqlangan. Faqat `Dimensions.kGap*`, `Dimensions.kPadding*`, `Dimensions.kRadius*`.
4. **BLoC Event/State Bog'lanishi**: Har doim `part '..._event.dart';` va `part '..._state.dart';`. BLoC klassida mutable field bo'lishi taqiqlangan.
5. **Transformers va Handler Nomi**: Har bir `on<Event>` da `transformer:` (`droppable()` o'qish uchun, `throttle()` yozish uchun). Handler nomi `_<verb><Target>Handler`.
6. **Modullararo Izolyatsiya**: Modullar bir-birini to'g'ridan-to'g'ri import qilmaydi (`arch-guard` qoidasi). Aloqa faqat `core` dagi interactor, args yoki DI orqali bo'ladi.
7. **setState Intizomi**: `setState` faqat va faqat lokal tranzit UI holatlar uchungina (masalan, password visibility, local checkbox). `BlocBuilder`/`BlocConsumer` rebuild qiladigan holatda ortiqcha `setState` taqiqlangan.

## 4. Ish Yakunlash Darvozasi (Verification Gate)

Har qanday o'zgarishdan so'ng terminalda quyidagi tekshiruvlar to'liq o'tishi shart:
```bash
./scripts/arch_guard_scan.sh   # 0 violations bo'lishi shart
./scripts/quick_check.sh       # dart fix, format va analyze toza bo'lishi shart
flutter test                   # Barcha testlar yashil o'tishi shart
```
