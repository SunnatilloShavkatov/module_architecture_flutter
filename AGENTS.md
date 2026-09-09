# AGENTS.md — Modular Architecture Standarti va Qoidalari

> **YAGONA MANBA.** `CLAUDE.md`, `GEMINI.md`, `.agents/rules/` — shu faylga ko'rsatkich.
> Bu loyiha — yangi mobil ilovalar uchun **mustaqil etalon shablon (template/boilerplate)**.
> Ziddiyat bo'lsa: **shu fayl > real kod > qolgan doc**. Guard qoidalari:
> [`.claude/rules/flutter-architecture.md`](.claude/rules/flutter-architecture.md).

---

## 0. Muloqot Tili va Uslubi

- Foydalanuvchiga **javob har doim o'zbek tilida**. Texnik atamalar (bloc, mixin, transformer, sealed, route) ingliz tilida qoladi.
- **Kod, kommentariya, commit message, PR matni, identifikatorlar — ingliz tilida.**
- Xato/log matnini tarjima qilma, asl holida ko'rsat.
- Qisqa yoz. Reja/variantlar ro'yxati kerak emas — ish qil, keyin nima qilganingni 3-5 qatorda ayt.

---

## 1. Ish Tartibi — Har Bir Topshiriqda

1. **Etalon faylni o'qi** (§3 jadval) — o'ylab topma, mavjud style'ni ko'chir.
2. O'zgartiradigan faylni **to'liq** o'qi + yonidagi 1 ta qo'shni faylni.
3. §2 router bo'yicha **faqat kerakli** rules faylini o'qi. Hammasini o'qish shart emas.
4. Yoz. Minimal diff. Aloqasiz kodga tegma.
5. Guard xabari kelsa — o'sha qatorni tuzat. **Hech qanday analyze/test buyrug'i yo'q** (§7).

### Token qoidalari

- Bir faylni ikki marta o'qima; o'qigan joyingni yodda tut.
- `rg` bilan qidir. `find`, `ls -R`, butun papkani o'qish — yo'q.
- Fayl 400 qatordan uzun bo'lsa, kerakli qismini `offset/limit` bilan o'qi.
- Guard (`arch-guard`) xabari — tayyor diagnoz. Qayta tekshirma, to'g'ridan-to'g'ri tuzat.
- Reja/variant ro'yxati yozma. Javob: nima qilingani (3–5 qator) + tegilgan fayllar.

---

## 2. Qoidalar Routeri (Rules Map)

| Topshiriq | O'qi (faqat shuni) |
|---|---|
| bloc / event / state / transformer | `docs/rules/bloc.md` |
| page / mixin / widget / setState / paginatsiya | `docs/rules/page-mixin.md` |
| yangi modul, DI, container, modullararo aloqa | `docs/rules/module.md` |
| endpoint, datasource, model, repository impl | `docs/rules/data-api.md` |
| domain (entity, repository, usecase, interactor) | `docs/rules/domain.md` |
| route, navigatsiya, args, bottom sheet, dialog | `docs/rules/navigation.md` |
| UI, spacing, padding, rang, shrift, komponent | `docs/rules/ui.md` |
| matn, tarjima, yangi l10n key | `docs/rules/l10n.md` |
| websocket, audio, uzoq yashovchi servis | `docs/rules/service.md` |
| `packages/*` ichida ish (component, tema, konstanta) | `docs/rules/packages.md` |
| test (unit, bloc, repo, mocktail) | `docs/rules/testing.md` |
| guard xabari, yangi tekshiruv qo'shish | `.claude/rules/flutter-architecture.md` |
| yangi modul skeleti (skript) | `docs/rules/module.md` + `./scripts/create_module.sh <name>` |
| «bu fayl nega qoidaga zid?» — eski pattern | `.claude/rules/migration-list.md` (style debt) |
| agentning o'zini tutishi (terminal, tahrir, reja) | `.agents/rules/agent-protocol.md` |
| bilmasang | shu fayl + eng yaqin etalon fayl |

---

## 3. Etalon Fayllar — Ko'chiriladigan Namuna

Loyihadagi barcha haqiqiy etalon fayllar. **`notifications` — bosh etalon modul.**
`auth` modulida eski nomlanish qoldiqlari bor (`domain/repos/`, `AuthRepo`) —
undan faqat forma/OTP page+mixin patternini ol, nomlanishni emas
(`.claude/rules/migration-list.md`).

| Nima yozyapsan | Etalon Fayl |
|---|---|
| bloc + event + state | `modules/notifications/lib/src/presentation/notifications/bloc/notifications_bloc.dart` |
| ko'p-operatsiyali sealed state | `modules/notifications/lib/src/presentation/notifications/bloc/notifications_state.dart` |
| paginatsiyali ro'yxat + set-union | `modules/notifications/lib/src/presentation/notifications/notifications_page.dart` & `mixin/notifications_mixin.dart` |
| forma + validatsiya + auth | `modules/auth/lib/src/presentation/login/login_page.dart` & `mixin/login_mixin.dart` |
| OTP / tasdiqlash kiritish | `modules/auth/lib/src/presentation/otp_login/otp_login_page.dart` & `mixin/otp_login_mixin.dart` |
| forma tahrirlash + args + pop result | `modules/profile/lib/src/presentation/edit_profile/edit_profile_page.dart` & `mixin/edit_profile_mixin.dart` |
| karta kiritish / formatlash | `modules/payments/lib/src/presentation/add_card/add_card_page.dart` & `mixin/add_card_mixin.dart` |
| dashboard / ko'p-bo'limli ekran | `modules/home/lib/src/presentation/main/home_page.dart` & `mixin/home_mixin.dart` |
| splash / app bootstrap | `modules/initial/lib/src/presentation/splash/splash_page.dart` & `mixin/splash_mixin.dart` |
| navigation shell / tablar | `modules/main/lib/src/presentation/main/main_page.dart` & `mixin/main_mixin.dart` |
| bottom sheet (route orqali) | `modules/notifications/lib/src/presentation/notifications_filter_sheet/notifications_filter_sheet.dart` |
| dialog (route orqali) | `modules/notifications/lib/src/presentation/clear_notifications_dialog/clear_notifications_dialog.dart` |
| router (CupertinoRoute, Sheet, Dialog)| `modules/notifications/lib/src/router/notifications_router.dart` |
| args + `.parse()` | `modules/notifications/lib/src/presentation/notifications_filter_sheet/args/notifications_filter_args.dart` |
| domain (entity, repo, usecases) | `modules/notifications/lib/src/domain/` |
| datasource + model + repo impl | `modules/notifications/lib/src/data/` |
| DI (injection) | `modules/notifications/lib/src/di/notifications_injection.dart` |
| module container | `modules/notifications/lib/src/notifications_container.dart` |
| widget factory | `modules/notifications/lib/src/presentation/notifications/factory/notification_item_factory.dart` |
| module interactor | `modules/notifications/lib/src/domain/interactor/get_unread_notifications_count_interactor.dart` |
| to'liq test to'plami | `modules/notifications/test/notifications_test.dart` |

---

## 4. Tuzilma va Modul Chegarasi

```
packages/              # Umumiy paketlar (modullarga bog'liq emas)
  core/                # entity, Either, usecase base, network, l10n, Constants, DI interfeyslari
  components/          # UI: Dimensions (kGap*, kPadding*, kRadius*), tugmalar, snackbar, theme
  navigation/          # Routes, CupertinoRoute, MaterialSheetRoute, MaterialDialogRoute, args
  platform_methods/    # native kanal
  merge_dependencies/  # Yagona orkestrator: hamma modulni yig'adi (_allContainer)

modules/<module>/lib/src/
  domain/              # entities/, repository/, usecases/, interactor/ (sof Dart, zero Flutter)
  data/                # datasource/ (+impl part), models/, repository/
  presentation/<feature>/
    <feature>_page.dart
    bloc/ mixin/ widgets/ args/
  di/<module>_injection.dart
  router/<module>_router.dart
  <module>_container.dart
```

**Qat'iy Chegara:**
- `modules/*` bir-birini **hech qachon** to'g'ridan-to'g'ri import qilmaydi yoki `pubspec.yaml` ga yozmaydi (`arch-guard`).
- Modullararo muloqot faqat `ModuleInteractor`, `PageFactory`, `WidgetFactory<T>` yoki `Routes` orqali bo'ladi.
- Boshqa paketning `src/` iga hech qachon kirma — faqat barrel: `package:core/core.dart`.

---

## 5. Qattiq Taqiqlar — Nol Tolerantlik

| ❌ Yozma | ✅ Yoz | Sabab |
|---|---|---|
| `package:flutter/material.dart` | `package:material_ui/material_ui.dart` va `package:components/components.dart` | Arxitektura standarti (`arch-guard`) |
| `Navigator.push/pop`, `MaterialPageRoute` | `context.pushNamed(...)`, `context.pop(value)` | go_router navigatsiyasi |
| `showDialog`, `showModalBottomSheet` | `MaterialDialogRoute<T>`, `MaterialSheetRoute<T>` | Barcha modal va dialoglar router stackida yashashi shart (`arch-guard`) |
| `MediaQuery.of(context)` | `context.width` / `context.height` / `context.padding` / `context.viewInsets` | Core extensionlar |
| `print()`, `debugPrint()` | `logMessage('...', error: e, stackTrace: s)` | Xavfsiz loglash |
| `Text('Login')` hardcoded | `Text(context.l10n.login)` | Lokalizatsiya (l10n) (`arch-guard`) |
| `EdgeInsets.all(16)` | `Dimensions.kPaddingAll16` | UI Design System |
| `SizedBox(height: 16)` oraliq uchun | `Dimensions.kGap16` yoki `spacing: 16` | UI Design System |
| BLoC ichida `List _items = []` yoki `int _page` | mixin fieldi (`docs/rules/page-mixin.md`) | BLoC stateless dvigatel, Mixin ma'lumot egasi |
| BLoC'da public usecase | `final GetXxx _getXxx;` (private final) | Enkapsulyatsiya |
| `_onXxx` handler nomi | `_getXxxHandler` (`_<verb><target>Handler`) | Nomlash standarti |
| `transformer:` siz `on<Event>()` | har doim aniq transformer (`droppable()`, `throttle()`, `debounce()`) | Duplikat so'rovlarning oldini olish |
| `fromJson` / `toJson` | `fromMap` / `toMap` | Model standarti |
| `Theme.of(context)` | `context.color`, `context.textStyle`, `context.textTheme` | Theme tokens (`arch-guard`) |
| `extra` orqali callback uzatish | `context.pop(value)` + `await context.pushNamed<T>(...)` | Callback deep link/restore da yo'qoladi |
| Modulni `pubspec.yaml` ga qo'shish | `ModuleInteractor` / `WidgetFactory` | Modullararo izolyatsiya |
| Turn ichida `flutter analyze`, `flutter test` | Turn ichida yo'q (§7), faqat hook va pre-commit | Vaqt va token tejamkorligi |

### Istisno kerak bo'lsa

Guard bitta qoidani fayl uchun o'chirishga ruxsat beradi — sabab majburiy:
```dart
// arch-guard: allow l10n-text — 'Visa' is a brand name, identical in every locale
```
Id'lar: `l10n-text`, `bloc-mutable`, `bloc-public-dep`, `build-when`, `import-order`.
Butun faylni chiqarish (parked kod): `// arch-guard: ignore — <sabab>`, birinchi 3 qatorda.
Istisno — oxirgi chora: avval kodni qoidaga moslashtir.

---

## 6. Nomlash va Class Modifikatorlari

| Nima | Qoida | Misol |
|---|---|---|
| fayl / papka | snake_case | `notifications_page.dart` |
| class | PascalCase | `NotificationsBloc` |
| private field | `_camelCase` | `_getNotifications` |
| event | `<Verb><Noun>Event` | `GetNotificationsEvent` |
| state | `<Noun><Holat>State` | `NotificationsLoadingState` |
| handler | `_<verb><target>Handler` | `_getNotificationsHandler` |
| usecase | `<Verb><Noun>` | `GetNotifications` |
| repository | `<Noun>Repository` | `NotificationsRepository` |
| api paths | `<Module>ApiPaths` | `NotificationsApiPaths` |

- `sealed class`: Event va State ildizlari (va subfamilies).
- `final class`: Implementatsiyalar (`*Impl`), BLoC, Router, Container, Injection, Interactor, Args, `*Params`, `*ApiPaths`.
- `abstract interface class`: Repository va DataSource shartnomalari.
- `class` (modifikatorsiz): Entity, Model, **UseCase**, StatefulWidget page, Mocktail mocklar.
- Konstruktor: **`const new(...)`** / **`new(...)`** (Dart 3.47 shorthand). Class nomini takrorlash taqiqlangan.

Import tartibi: `dart:` bloki → bo'sh qator → barcha `package:` importlari **bitta alfavit ro'yxatda**
(o'z moduli ham shu ro'yxatda, alohida emas). `arch-guard` shuni tekshiradi.

---

## 7. Sifat Gate — Turn Ichida YO'Q

Turn ichida bu buyruqlar **taqiqlanadi** (`PreToolUse` hook bloklaydi):
`flutter analyze`, `dart analyze`, `flutter test`, `dart test`, `scripts/run_tests.sh`,
`flutter pub get`, `flutter clean`, `flutter build`, `dart format ./`, `dart fix --apply`.

Sabab: Ko'p modulli loyihalarda har turn'da 2–5 daqiqa kutish va token isrofini yo'qotish.

| Bosqich | Nima | Qachon | Vaqt |
|---|---|---|---|
| PostToolUse hook | `arch-guard.sh` (§5 taqiqlar, §2 struktura) | har Write/Edit | ~50 ms |
| Stop hook | `dart format` + guard scan — faqat o'zgargan fayl | turn oxiri | ~2 s |
| pre-commit | format check + `dart analyze` (faqat tegilgan paket) | `git commit` | 5–25 s |
| CI | to'liq testlar + `flutter analyze` | PR | fon |

Turn ichida ruxsat etilgan yagona tekshiruv — guard skani (~1 s, flutter chaqirmaydi):
`bash scripts/arch_guard_scan.sh --changed`.
Dasturchi xohlasa qo'lda: `bash scripts/analyze_changed.sh` yoki `./scripts/verify.sh`.

### Turn tugaganda model o'zi tekshiradi (buyruqsiz)

- [ ] Etalon fayl ochilgan, style ko'chirilgan
- [ ] §5 jadvalidan birorta ❌ yo'q
- [ ] BLoC'da mutable field yo'q, dependency'lar `private final`
- [ ] Har bir `on<Event>()` da `transformer:`; Loading emit qiluvchi handler'da guard
- [ ] UI ma'lumoti mixin'da; hosila qiymat — getter
- [ ] Har bir `BlocBuilder` da `buildWhen`, sealed subfamily nomlangan
- [ ] Barcha modal va dialoglar alohida Route (`MaterialSheetRoute`, `MaterialDialogRoute<T>`)
- [ ] Modullararo bog'liqlik qo'shilmagan (`pubspec.yaml`)
- [ ] Barcha matn `context.l10n.*`
- [ ] Javobda tegilgan fayllar ro'yxati bor

---

## 8. Tayyor Buyruqlar (Slash Commands / Workflows)

Har biri kerakli etalon + rules faylini o'zi ko'rsatadi — ortiqcha fayl o'qilmaydi.

| Buyruq | Nima qiladi | Claude Code | Boshqa agentlar |
|---|---|---|---|
| `/bloc <module> <feature>` | bloc + event + state | `.claude/commands/bloc.md` | `.agents/workflows/bloc.md` |
| `/page <module> <feature>` | page + mixin + route | `.claude/commands/page.md` | `.agents/workflows/page.md` |
| `/endpoint <module> <endpoint>` | api_paths + datasource + model + repo + usecase | `.claude/commands/endpoint.md` | `.agents/workflows/endpoint.md` |
| `/l10n <key> "<matn>"` | 3 ta `.arb` + ishlatilishi | `.claude/commands/l10n.md` | `.agents/workflows/l10n.md` |
| `/module <name>` | yangi modul skeleti + orkestratsiya | `.claude/commands/module.md` | `.agents/workflows/module.md` |
| `/test <module> <target>` | test + aggregator ulanishi | `.claude/commands/test.md` | `.agents/workflows/test.md` |
| `/guard` | guard buzilishlarini skanlab tuzatish | `.claude/commands/guard.md` | `.agents/workflows/guard.md` |

Buyruqsiz ishlayotgan bo'lsang ham shu fayllarni o'qish mumkin — ular §1–§6 ning qisqartmasi.
