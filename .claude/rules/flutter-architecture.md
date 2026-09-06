---
paths:
  - "modules/*/lib/src/**/*.dart"
  - "packages/*/lib/src/**/*.dart"
  - "lib/**/*.dart"
---

# Flutter arxitektura qoidalari

Bu fayl **mavjud kodni o'lchash** natijasida yozilgan. Har bir qatordagi dalil ustuni —
`<qoidaga mos fayl>/<tekshirilgan fayl>` nisbati, 2026-09-06 holatiga ko'ra.
O'lchov doirasi: **279 `.dart` fayl** (`modules/*/lib` 152, `packages/*/lib` 121, `lib/` 6).

`lib/` papkasida atigi 6 fayl bor (bootstrap: `main_dev`, `main_prod`, `app`, `main_common`,
2 ta `firebase_options`). Haqiqiy kod `modules/` va `packages/` ichida — shuning uchun
frontmatter `lib/**` bilan cheklanmagan.

**Ustunlik chegarasi:** ≥90% → majburiy qoida. 60–90% → egasi tanlagan variant qoida qilib
yozilgan, lekin `arch-guard.sh` uni **majburlamaydi**. <60% → «Noaniq qolgan joylar» bo'limida.

---

## 1. Papka sxemasi

Uch pog'onali: **monorepo → modul → modul ichida layer-first → layer ichida feature-first.**
Aralash sxema emas.

| Qoida | Dalil |
|---|---|
| Ilova kodi `modules/<m>/` yoki `packages/<p>/` ichida bo'lishi shart; `lib/` faqat bootstrap uchun | 273/279 fayl `modules`+`packages` da |
| Modul barrel fayli `modules/<m>/lib/<m>.dart` bo'lishi va faqat `<M>Container` ni export qilishi shart | 8/8 |
| Modul kirish nuqtasi `modules/<m>/lib/src/<m>_container.dart`, `final class <M>Container implements ModuleContainer` bo'lishi shart | 8/8 |
| Router `modules/<m>/lib/src/router/<m>_router.dart` da bo'lishi shart | 8/8 |
| DI `modules/<m>/lib/src/di/<m>_injection.dart` da bo'lishi shart | 6/6 (DI'si bor modullar) |
| Domain layer `src/domain/{entities,repository,usecases}/` bo'lishi shart | 5/6 modul (`auth` da `repos/`) |
| Data layer `src/data/{datasource,models,repository}/` bo'lishi shart | 5/6 modul (`auth` da `repo/`) |
| Presentation `src/presentation/<feature>/` — har bir feature o'z papkasida | 42/42 presentation fayl |
| Bloc uchligi `src/presentation/<feature>/bloc/` da bo'lishi shart | 6/6 feature |
| Mixin `src/presentation/<feature>/mixin/` da bo'lishi shart | 8/8 |
| Route argumentlari `src/presentation/<feature>/args/` da bo'lishi shart | 1/1 |
| Sheet o'zining yuqori darajali papkasida: `src/presentation/<name>_sheet/` | 1/1 |
| Cross-module page factory modul ildizida: `src/<m>_page_factory.dart` | 2/2 |
| Modul-lokal API yo'llari `src/data/datasource/<m>_api_paths.dart` da bo'lishi shart; global `ApiPaths` ga qo'shish taqiqlanadi | 5/5, global 0 |

Modul skeleti:

```
modules/<m>/
  lib/<m>.dart                                  ← barrel: export 'src/<m>_container.dart' show <M>Container;
  lib/src/<m>_container.dart
  lib/src/<m>_page_factory.dart                 ← faqat modul sahifasini tashqariga bersa
  lib/src/di/<m>_injection.dart
  lib/src/router/<m>_router.dart
  lib/src/domain/entities/<x>_entity.dart
  lib/src/domain/repository/<m>_repository.dart
  lib/src/domain/usecases/<verb>_<target>.dart
  lib/src/data/datasource/<m>_api_paths.dart
  lib/src/data/datasource/<m>_{remote,local}_data_source.dart
  lib/src/data/datasource/<m>_{remote,local}_data_source_impl.dart
  lib/src/data/models/<x>_model.dart
  lib/src/data/repository/<m>_repository_impl.dart
  lib/src/presentation/<feature>/<feature>_page.dart
  lib/src/presentation/<feature>/bloc/<feature>_{bloc,event,state}.dart
  lib/src/presentation/<feature>/mixin/<feature>_mixin.dart
  lib/src/presentation/<feature>/args/<feature>_args.dart
  test/src/**                                   ← lib/src/** ko'zgusi
```

---

## 2. Fayl ↔ klass nomlash

`arch-guard.sh` **majburlaydigan** qatorlar (≥90%, faqat `modules/*/lib/src/`).

Jadval `arch-guard.sh` dagi `RULES` bloki bilan **belgi-ba-belgi** mos. Ustunlar aynan
`papka_qismi|ruxsat_etilgan_suffikslar|klass_suffiksi` formatidagi maydonlar; tartib ham bir xil
(birinchi mos kelgan qator qo'llanadi). Tekshirish: `bash .claude/hooks/arch-guard-selftest.sh`.

| papka_qismi | ruxsat_etilgan_suffikslar | klass_suffiksi | Dalil |
|---|---|---|---|
| `/lib/src/presentation/*/bloc/` | `_bloc.dart,_event.dart,_state.dart` | `Bloc,Event,State` | 18/18 |
| `/lib/src/presentation/*/mixin/` | `_mixin.dart` | `Mixin` | 8/8 |
| `/lib/src/presentation/*/args/` | `_args.dart` | `Args` | 1/1 |
| `/lib/src/presentation/` | `_page.dart,_sheet.dart` | `Page,Sheet` | 15/15 |
| `/lib/src/domain/entities/` | `_entity.dart` | `Entity` | 10/10 |
| `/lib/src/domain/repository/` | `_repository.dart,_repo.dart` | `Repository,Repo` | 5/5 |
| `/lib/src/domain/repos/` | `_repository.dart,_repo.dart` | `Repository,Repo` | 1/1 |
| `/lib/src/data/models/` | `_model.dart` | `Model` | 10/10 |
| `/lib/src/data/datasource/` | `_data_source.dart,_data_source_impl.dart,_api_paths.dart` | `DataSource,DataSourceImpl,ApiPaths` | 16/16 |
| `/lib/src/data/repository/` | `_impl.dart` | `Impl` | 5/5 |
| `/lib/src/data/repo/` | `_impl.dart` | `Impl` | 1/1 |
| `/lib/src/router/` | `_router.dart` | `Router` | 8/8 |
| `/lib/src/di/` | `_injection.dart` | `Injection` | 6/6 |

Guard majburlamaydigan, lekin amal qilinishi shart bo'lgan nom qoidalari:

| Qoida | Dalil |
|---|---|
| Sahifa klassi fayl nomining PascalCase ekvivalenti bo'lishi shart (`login_page.dart` → `LoginPage`) | 14/14 |
| `State` klassi `_<X>PageState` — private bo'lishi shart | 8/9 (`InternetConnectionPageState` public — migratsiya) |
| Mixin nomi `<Feature>Mixin`, `on State<<Feature>Page>` bilan cheklanishi shart | 8/8 |
| Usecase klassi fe'l-birinchi, suffikssiz bo'lishi shart (`GetHomeCategories`, `Login`, `UpdateProfileUser`) — `UseCase` suffiksi taqiqlanadi | 11/11 |
| Usecase parametrlari `final class <Usecase>Params` — usecase bilan **bir faylda** bo'lishi shart | 5/5 |
| Datasource interfeysi `abstract interface class` bo'lishi shart | 11/11 |
| Impl fayli `_impl.dart`, klassi `<Interface>Impl` bo'lishi shart | 11/11 |
| Container `final class <M>Container implements ModuleContainer` | 8/8 |
| Injection `final class <M>Injection implements Injection` | 6/6 |
| Router `final class <M>Router implements AppRouter<RouteBase>` | 8/8 |
| Page factory `final class <M>PageFactory implements PageFactory`, `InstanceNameKeys` kaliti = klass nomi | 2/2 |
| Konstruktor `const new(...)` / `new(...)` qisqartmasi ishlatilishi shart; `const <ClassName>(` klassik shakli taqiqlanadi | 199 fayl vs 15 (93%) |
| `final class` modifikatori infratuzilma sinflarida shart: Bloc · Event · State · Container · Injection · Router · PageFactory · Params · ApiPaths · `*Impl` | 5/6 bloc, 6/6 container, 6/6 injection, 8/8 router, 5/5 params, 5/5 apipaths |
| Domain/data ma'lumot sinflari modifikatorsiz `class` bo'lishi shart: Entity · Model · Usecase | 10/10 entity, 10/10 model, 11/11 usecase — 0 ta `final` |
| Repo interfeysi nomi `<M>Repository`, papkalari `domain/repository/` + `data/repository/` bo'lishi shart | egasi tanlagan; papkalar 5/6, sinf nomi 3/6 — `auth` migratsiya ro'yxatida |

---

## 3. Qatlam bog'liqliklari

Haqiqiy o'lchangan yo'nalish — nol buzilish bilan:

| Qoida | Dalil |
|---|---|
| Barcha importlar `package:` bo'lishi shart; nisbiy import (`../`, `./`) taqiqlanadi | 279/279 |
| Modul o'z ichidagi faylni ham `package:<m>/src/...` orqali chaqirishi shart | 279/279 |
| Modul boshqa modulni import qilishi taqiqlanadi | 0/8 modul buzgan |
| Boshqa paketning `src/` ichiga kirish taqiqlanadi — faqat barrel (`package:core/core.dart`) | 0/279 |
| `components` · `core` · `navigation` · `platform_methods` bir-biriga yoki `modules/*` ga bog'lanishi taqiqlanadi | 0 bog'liqlik |
| `domain/` da `fromMap`/`toMap` taqiqlanadi | 0/17 domain fayl |
| `domain/` da UI import (`material_ui`, `cupertino_ui`, `package:flutter/...`) taqiqlanadi | 0/17 |
| Model entity'ni `extends` qilishi shart; teskarisi taqiqlanadi | 10/10 |
| `fromMap` + `toMap` faqat modelda bo'lishi shart | 7/7 model |
| Repo impl interfeysni `implements` qilishi shart | 6/6 |
| Usecase interfeysga bog'lanishi shart (`_repo` maydoni interfeys tipida) | 11/11 |
| Cross-module page uzatish `PageFactory` orqali bo'lishi shart; iste'molchi `pubspec.yaml` da egasi modul turmasligi shart | 2/2 factory, 0 bog'liqlik |

Serializatsiya:

| Qoida | Dalil |
|---|---|
| `fromMap`/`toMap` qo'lda yozilishi shart | 7/7 model |
| `json_serializable` · `build_runner` · `freezed` · `fromJson`/`toJson` taqiqlanadi | 0 ta pubspec, 0 ta fayl |

DI:

| Qoida | Dalil |
|---|---|
| Bloc `registerFactory` bilan ro'yxatdan o'tishi shart | 7/7 |
| Datasource · repository · usecase · factory `registerLazySingleton` bilan ro'yxatdan o'tishi shart | 30/30 |
| Ro'yxat tartibi izohlar bilan bo'linishi shart: `/// page factories` → `/// data sources` → `/// repositories` → `/// usecases` → `/// bloc` | `/// bloc` 5/5, `/// page factories` 2/2, `/// data sources` va `/// repositories` 4/5 (`auth` da `/// data`, `/// domain` — migratsiya) |

---

## 4. State management

`flutter_bloc`, `Equatable`, `bloc_concurrency`. `freezed` yo'q (0 misol).

| Qoida | Dalil |
|---|---|
| Bloc `final class <F>Bloc extends Bloc<<F>Event, <F>State>` bo'lishi shart | 5/6 (`ProfileBloc` da `final` yo'q — migratsiya) |
| Root event/state `sealed class ... extends Equatable` bo'lishi shart | 6/6 event, 6/6 state |
| Konkret event/state `final class` bo'lishi shart | 9/9 event, 26/26 state |
| Har bir konkret state `props` ni override qilishi shart (bo'sh bo'lsa ham) | 26/26 |
| Event nomi `<Feature><Verb>Event` — ot-birinchi: `HomeLoadEvent`, `PaymentMethodAddEvent`, `LoginSubmitEvent` | 8/9 (`UpdateProfilePressedEvent` — migratsiya) |
| State nomlari `<F>InitialState` · `<F>LoadingState` · `<F>SuccessState` · `<F>FailureState` bo'lishi shart; `Loaded`/`Error` taqiqlanadi | 6/6 bloc, `Loaded`/`Error` 0 ta |
| Event/state fayllari bloc'ga `part` bilan ulanishi shart (`part 'x_event.dart';` + `part of 'x_bloc.dart';`) | 4/6 (`auth` ikki blocida alohida import — migratsiya) |
| Handler nomi `_<verb><Target>Handler` bo'lishi shart; `_on<Xxx>` taqiqlanadi | 10/10 `Handler`, 0 ta `_on` |
| Har bir `on<Event>()` chaqiruvida `transformer:` bo'lishi shart | 10/10 |
| Yozuv (POST/PATCH/PUT/DELETE) → `throttle()`; o'qish (GET) → `droppable()` | throttle 5/5 yozuv, droppable 5/5 o'qish |
| Har bir handler `if (state is <F>LoadingState) { return; }` bilan boshlanishi shart | 10/10 |
| Bloc konstruktori usecase'larni pozitsion argument sifatida olishi, `final` private maydonda saqlashi shart | 6/6 |

Guruhlangan sealed state (bir sahifada bir nechta oqim bo'lganda) — `profile_bloc` da bitta misol:
`sealed class LoadingState extends ProfileState` → `ProfileLoadingState`, `ProfileUpdatingState`.
Bitta misol, majburiy qoida emas.

---

## 5. UI / design system

Design system: `packages/components` (`Dimensions`, `CustomLoadingButton`, `SafeAreaWithMinimum`,
`ModalProgressHUD`, `Gap`, `ThemeColors` extension) + `packages/core` (`context.l10n`, extensionlar).

| Qoida | Dalil |
|---|---|
| Widget importi `package:material_ui/material_ui.dart` bo'lishi shart | 61 fayl |
| `package:cupertino_ui/cupertino_ui.dart` faqat haqiqiy Cupertino tiplari uchun | 2 fayl |
| `package:flutter/material.dart` va `package:flutter/cupertino.dart` taqiqlanadi | 0/279 |
| `package:flutter/{widgets,services,foundation}.dart` faqat kerak bo'lganda ruxsat | 5 / 10 / 32 fayl |
| Rang `context.color.*` yoki `context.colorScheme.*` orqali olinishi shart; `Colors.*` va `Color(0x...)` taqiqlanadi | 62 ishlatish, 0 hardcode |
| Matn stili `context.textTheme.*` orqali olinishi shart | 38 vs `context.textStyle.*` 2 vs raw `TextStyle(` 4 → 86% |
| O'lcham/bo'shliq `Dimensions.*` tokenlari orqali berilishi shart; raw `EdgeInsets`/`SizedBox` faqat token bo'lmaganda | 99 vs 4 → 96% |
| `Dimensions.*` tokenini ishlatishdan oldin `packages/components/lib/src/utils/dimensions.dart` da mavjudligi tekshirilishi shart | — |
| Sahifa `body` i `SafeAreaWithMinimum` bilan o'ralishi shart; `bottomNavigationBar` da plain `SafeArea` istisno | 12 vs 2 (ikkalasi ham `bottomNavigationBar`) → 86% |
| Asosiy/submit tugma `CustomLoadingButton` bo'lishi shart; `ElevatedButton` taqiqlanadi | 14 vs 1 joy → 93% |
| To'liq ekran async blok `ModalProgressHUD` bilan berilishi shart | 2/2 |
| `MediaQuery.of(context)` taqiqlanadi — `context.width` / `context.height` / `context.padding` | 0/279 |
| `print()` taqiqlanadi | 0/279 |
| Mixinli sahifa `StatefulWidget` bo'lishi shart | 8/8 |
| Mixin `part of '../<feature>_page.dart';` bilan sahifaga ulanishi shart | 8/8 |
| Mixinsiz sahifa `StatelessWidget` bo'lishi mumkin | 5/14 sahifa |
| Sheet root'i `SafeAreaWithMinimum(minimum: Dimensions.kPaddingAll16, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, ...))` bo'lishi shart | 1/1 |

---

## 6. Navigatsiya

`go_router`, `packages/navigation` barrel orqali. `Navigator 1.0` yo'q.

| Qoida | Dalil |
|---|---|
| `Navigator.push` · `Navigator.pop` · `Navigator.of(` taqiqlanadi — `context.pushNamed`/`goNamed`/`pop` | 0 `Navigator.`, 22 `context.*Named/pop` |
| Route klasslari faqat `package:navigation/navigation.dart` barrelidan olinishi shart | 32 fayl, `navigation/src/` 0 |
| To'liq ekran sahifa route'i `CupertinoRoute` bo'lishi shart | 9/9 |
| Sheet route'i `MaterialSheetRoute` bo'lishi shart | 1/1 |
| Modul router'ida `pageBuilder:` yozish taqiqlanadi — route klassi uni o'zi boshqaradi | 0/8 router |
| `StatefulShellBranch` ildizi va `Dimensions.kZeroBox` qaytaruvchi placeholder plain `GoRoute` bo'lishi mumkin — yagona istisno | 4/4 `GoRoute` shu holatda (`main_router.dart`) |
| Route nomi/yo'li `Routes.*` konstantalaridan (`packages/navigation/lib/src/name_routes.dart`) olinishi shart | 1 manba |
| Sheet route nomi `...Sheet` suffiksi bilan tugashi shart | 1/1 |
| Kirish ma'lumoti bor route `final class <F>Args` + `state.extra! as <F>Args` ishlatishi shart; xom entity uzatish va soxta fallback taqiqlanadi | 1/1 |
| Router `List<GoRoute> getRouters(Injector di)` yoki `List<RouteBase> getRouters(Injector di)` qaytarishi shart | 8/8 |

---

## 7. Localization

| Qoida | Dalil |
|---|---|
| Foydalanuvchiga ko'rinadigan matn `context.l10n.<key>` orqali berilishi shart | 80 vs 4 hardcode → 95% |
| Tarjimalar `packages/core/lib/src/l10n/app_{en,ru,uz}.arb` da bo'lishi shart | 3 til |
| Yaratilgan `app_localizations*.dart` fayllari qo'lda tahrirlanmasligi shart | 4 fayl |
| Kalit nomi lowerCamelCase (`loginSuccessMessage`, `chooseThemeMode`, `expiresLabel`) | 80/80 ishlatish |

Hardcode qolgan 4 joy — migratsiya ro'yxatida: `'Logo'`, `'1.0.0'`, `'404'`, `'Попробовать снова'`.

---

## 8. Test

| Qoida | Dalil |
|---|---|
| Test `<pkg>/test/src/**` da, `lib/src/**` yo'lini aynan ko'zgu qilib joylashishi shart | 13/14 modul testi |
| Test fayli `<manba>_test.dart` deb nomlanishi shart | 11/13 (`login_usecase_test.dart`, `otp_login_usecase_test.dart` — manba `login.dart`/`otp_login.dart`, migratsiya) |
| Bloc testi `test/src/presentation/<feature>/bloc/<feature>_bloc_test.dart` bo'lishi shart | 4/4 |
| Har bir yangi bloc uchun bloc testi bo'lishi shart | 4/6 bloc (main/initial/system'da bloc yo'q) |

`auth` yagona to'liq qoplangan modul (10 test: datasource, model, repo, di, 2 usecase, 2 bloc, router).
Boshqa modullarda faqat bloc testi.

---

## 9. Noaniq qolgan joylar (<60% — qoida yo'q)

| Nuqta | Taqsimot | Holat |
|---|---|---|
| Repo interfeysi nomi | `<M>Repo` 3 (`HomeRepo`, `MainRepo`, `AuthRepo`) vs `<M>Repository` 3 (`NotificationsRepository`, `ProfileRepository`, `PaymentsRepository`) — **50/50** | Konvensiya kodda yo'q. Egasi qarori bilan `<M>Repository` tanlandi; guard majburlamaydi. |
| Repo impl fayl ↔ klass mosligi | `home_repository_impl.dart` → `HomeRepoImpl`, `main_repository_impl.dart` → `MainRepoImpl` — **2/6 mos emas** | Fayl `_repository_impl`, klass `RepoImpl`. Tuzatilmagan. |

## 10. Kodda misoli yo'q — bu faylda qoida ham yo'q

Quyidagilar `CLAUDE.md` da tasvirlangan, lekin **kodda 0 ta misol** bor. Shuning uchun bu yerda
qoida qilib yozilmadi va guard ularni tekshirmaydi:

`presentation/*/widgets/` papkasi · `ModuleInteractor` implementatsiyasi · `WidgetFactory<T>`
implementatsiyasi · pagination (page counter + scroll listener) · `Args.parse()` / `.empty()` /
`.fromQueryParameters()` · `SlideUpTransitionRoute` · `packages/core/lib/src/entities/` papkasi ·
`/// widget factories` va `/// interactors` DI izohlari.

Birinchi misol paydo bo'lganda bu fayl yangilanishi kerak.

## 11. Zid manbalar — hal qilindi

- **`.cursorrules`** (42 qator) — kodga zid edi: `fromJson`/`toJson` (kodda `fromMap`/`toMap`),
  `*UseCase` suffiksi (kodda 0/11), `datasources/` + `repositories/` + `pages/` papkalari
  (kodda `datasource/`, `repo|repository/`, `pages/` umuman yo'q). **O'chirildi.**

- **`CLAUDE.md`** — 4 zid nuqta bu faylga moslashtirildi:

  | § | Oldin | Hozir | Dalil |
  |---|---|---|---|
  | §2 | event nomi fe'l-birinchi (`GetXxxEvent`) | `<Feature><Verb>Event` | kodda 8/9 |
  | §2 | state nomida `XxxLoadedState`/`XxxErrorState` muqobili | faqat `Initial/Loading/Success/Failure`; guruhlangan sealed misoli `profile_state.dart` ga o'zgartirildi | `Loaded`/`Error` kodda 0 ta |
  | §10 | usecase `final class` | modifikatorsiz `class` + `final` siyosati qaysi turga tegishli ekani yozildi | usecase 0/11, entity 0/10, model 0/10 `final` |
  | §12 | `context.textStyle.*` birinchi | `context.textTheme.*` birinchi | 38 vs 2 |

  Yondosh moslashtirishlar (o'sha kod bloklari ichida, zidlik saqlanib qolmasligi uchun):
  §2 namunasidagi `GetFeatureEvent` → `FeatureLoadEvent`; §10 namunasidagi
  `const FeatureEntity(...)` / `const FeatureRepository()` / `const GetFeature(...)` →
  `const new(...)` (repo konvensiyasi, 199 vs 15).

  `CLAUDE.md` da qolgan noaniqlik: §2 dagi handler misollari (`_getProfileHandler`,
  `_sendOtpHandler`) kodda aynan yo'q — haqiqiy nomlar `_getProfileUserHandler`,
  `_otpLoginHandler`. Qoida (`_<...>Handler`, 10/10) to'g'ri, faqat misollar taxminiy.
  Tegilmadi.

## 12. Migratsiya ro'yxati

`.claude/rules/migration-list.md` ga qarang. Bu bosqichda hech narsa tuzatilmadi.
