# AGENTS.md — Modular Architecture Standarti va Qoidalari

> **YAGONA MANBA.** Boshqa barcha rules fayllari (`GEMINI.md`, `CLAUDE.MD`, `README.md`, `docs/rules/`) shu faylga ko'rsatkich.
> Bu loyiha — mustaqil etalon shablon (template). Barcha etalonlar shu loyihaning o'zida to'liq implement qilingan.

---

## 0. Muloqot Tili va Ish Uslubi

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
5. §7 sifat gate'ni ishga tushir (`./scripts/verify.sh`).

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
| test (unit, bloc, repo, mocktail) | `docs/rules/testing.md` |

---

## 3. Etalon Fayllar — Ko'chiriladigan Namuna

Loyihadagi barcha haqiqiy etalon fayllar:

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

**Qat'iy Chegara:** Modullar bir-birini **hech qachon** to'g'ridan-to'g'ri import qilmaydi yoki `pubspec.yaml` ga yozmaydi (`arch-guard`). Muloqot faqat `ModuleInteractor`, `WidgetFactory` yoki `Routes` orqali bo'ladi.

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
| `flutter build apk`, `flutter build ios`, `gradlew` | Hech qachon yurgazma | 3-5 daqiqa vaqt oladi, faqat foydalanuvchiga tegishli |

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
  > UseCase `final class` bo'lsa, Mocktail uni boshqa kutubxonadan `implements` qila olmaydi — test yozib bo'lmaydi (`docs/rules/domain.md` §2.4).
- Konstruktor: **`const new(...)`** / **`new(...)`** (Dart 3.47 shorthand). Class nomini takrorlash taqiqlangan.

---

## 7. Ish Yakunlash Darvozasi (Verification Gate)

Har qanday o'zgarishdan so'ng terminalda quyidagi yagona tezkor buyruq (<10 sekund) to'liq o'tishi shart:
```bash
./scripts/verify.sh            # Faqat o'zgargan fayllar va o'zgargan modul testini tekshiradi (<10s)
```
> Katta o'zgarish bo'lganda yoki foydalanuvchi so'raganda to'liq chuqur tekshiruv:
> `./scripts/verify.sh --all` — arch-guard (butun loyiha) + guard/qoida selftest + `dart format` +
> `dart analyze` + barcha modul va paket testlari.
>
> Flutter SDK PATH da bo'lmasa `FLUTTER_ROOT` ni belgila — skriptlarda hech qanday shaxsiy yo'l yo'q.

### Tugallanganlik Cheklisti:
- [ ] Etalon fayl ochilgan va uslub ko'chirilgan.
- [ ] §5 jadvalidan birorta ham ❌ yo'q.
- [ ] BLoC da mutable field yo'q, dependency'lar private final.
- [ ] Har bir `on<Event>()` da `transformer:` bor, loading handlerda guard bor.
- [ ] UI ma'lumoti mixin'da yashaydi, `_handleStates` ichida o'zgaradi, hosila qiymat — getter.
- [ ] Har bir `BlocBuilder` da `buildWhen` bor va sealed subfamily'ni nomlaydi.
- [ ] Barcha modal va dialoglar alohida Route (`MaterialSheetRoute`, `MaterialDialogRoute<T>`) sifatida ochilgan.
- [ ] Modullararo bog'liqlik qo'shilmagan (`arch-guard` toza).
- [ ] Hardcoded matn yo'q, barchasi `context.l10n.*` orqali olingan.
- [ ] `./scripts/verify.sh` muvaffaqiyatli o'tgan (<10s).

---

## 8. Agent / Antigravity Ishlash Protokoli

1. **Terminal va buyruqlar (`run_command`):**
   - Hech qachon `cd` ishlatma (`NEVER cd`). Har doim `Cwd` parametrini ko'rsat.
   - Tezkor skriptlardan foydalan: `./scripts/verify.sh`, `./scripts/quick_check.sh`, `./scripts/test_module.sh <name>`, `./scripts/create_module.sh <name>`.
   - Standart sandbox rejimida bajar (`BypassSandbox: false`). Faqat tashqi Flutter SDK yoki tarmoq zarur bo'lgandagina bypass so'ra.
2. **Fayl tahrirlash (`replace_file_content`):**
   - Tahrirlashdan oldin faylni `view_file` orqali ko'rib, qator raqami va aniq bo'sh joylarni (indentation) tekshir.
   - Bitta faylga parallel bir nechta tahrirlash chaqiruvlarini qilma.
   - Katta fayllarni to'liq o'chirib qayta yozma, faqat kerakli qismini almashtir.
3. **Planning Mode Chegarasi:**
   - Kichik va aniq topshiriqlar (bug fix, l10n, UI styling, bitta fayl refaktori, qoida yangilash) uchun ortiqcha reja tuzib to'xtab qolma — to'g'ridan-to'g'ri bajar.
   - Faqat yangi modul yaratish yoki katta arxitekturaviy refaktoring uchun reja tuz.
4. **Auto-import va taqiqlar filtri:**
   - Har bir tahrirdan keyin importlarni tekshir: tasodifan `package:flutter/material.dart` kirmasin (faqat `package:material_ui/material_ui.dart`).
   - Modullararo chegarani buzma (`modules/*` dan boshqa modulga to'g'ridan-to'g'ri import taqiqlangan).
   - Konstruktorlarda `const new(...)` shakliga qat'iy rioya qil.
5. **Avtomatik sifat tekshiruvi:**
   - Har bir ish yakunida `./scripts/verify.sh` ni yurgaz va toza ekaniga ishonch hosil qil.
