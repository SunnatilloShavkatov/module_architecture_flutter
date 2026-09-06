# Migratsiya ro'yxati

`.claude/rules/flutter-architecture.md` qoidalariga mos kelmaydigan mavjud fayllar.
2026-09-06 holatiga ko'ra. **Bu bosqichda hech narsa tuzatilmadi.**

`arch-guard.sh` bu ro'yxatdagi hech narsani bloklamaydi — hammasi 60–90% oraliqdagi yoki
egasi qarori bilan tanlangan qoidalar, guard esa faqat ≥90% qatorlarni majburlaydi.
Guard bo'yicha buzilish: **0 / 279 fayl (0.00%)**.

---

## 1. `auth` moduli — yagona «eski» modul

| Nima | Fayl |
|---|---|
| `domain/repos/` → `domain/repository/` | `modules/auth/lib/src/domain/repos/auth_repo.dart` |
| `data/repo/` → `data/repository/` | `modules/auth/lib/src/data/repo/auth_repo_impl.dart` |
| `AuthRepo` → `AuthRepository`, `AuthRepoImpl` → `AuthRepositoryImpl` | yuqoridagi 2 fayl + `auth_injection.dart` |
| event/state alohida `import` → bloc'ga `part` | `presentation/login/bloc/login_{bloc,event,state}.dart` |
| event/state alohida `import` → bloc'ga `part` | `presentation/otp_login/bloc/otp_login_{bloc,event,state}.dart` |
| DI izohlari `/// data` → `/// data sources`, `/// domain` → `/// repositories` | `src/di/auth_injection.dart` |
| Test nomi `login_usecase_test.dart` → `login_test.dart` | `test/src/domain/usecases/login_usecase_test.dart` |
| Test nomi `otp_login_usecase_test.dart` → `otp_login_test.dart` | `test/src/domain/usecases/otp_login_usecase_test.dart` |
| Raw `TextStyle(color: ...)` → `context.textTheme.*.copyWith(...)` — 2 joy | `presentation/login/login_page.dart:53,111` |
| Raw `TextStyle(color: ...)` → `context.textTheme.*.copyWith(...)` — 2 joy | `presentation/otp_login/otp_login_page.dart:65,85` |

## 2. Repo interfeys nomlanishi (50/50 — egasi `Repository` ni tanladi)

| Hozir | Bo'lishi kerak | Fayl |
|---|---|---|
| `HomeRepo` | `HomeRepository` | `modules/home/lib/src/domain/repository/home_repo.dart` |
| `MainRepo` | `MainRepository` | `modules/main/lib/src/domain/repository/main_repo.dart` |
| `AuthRepo` | `AuthRepository` | `modules/auth/lib/src/domain/repos/auth_repo.dart` |

## 3. Repo impl: fayl nomi ↔ klass nomi mos emas

| Fayl | Klass | Bo'lishi kerak |
|---|---|---|
| `modules/home/lib/src/data/repository/home_repository_impl.dart` | `HomeRepoImpl` | `HomeRepositoryImpl` |
| `modules/main/lib/src/data/repository/main_repository_impl.dart` | `MainRepoImpl` | `MainRepositoryImpl` |

## 4. `final class` yetishmaydi (infratuzilma sinflari)

| Fayl:qator | Klass |
|---|---|
| `modules/profile/lib/src/presentation/profile/bloc/profile_bloc.dart:10` | `ProfileBloc` |
| `modules/home/lib/src/data/datasource/home_local_data_source_impl.dart:3` | `HomeLocalDataSourceImpl` |
| `modules/profile/lib/src/data/datasource/profile_local_data_source_impl.dart:6` | `ProfileLocalDataSourceImpl` |
| `modules/main/lib/src/data/datasource/main_local_data_source_impl.dart:3` | `MainLocalDataSourceImpl` |
| `modules/main/lib/src/data/datasource/main_remote_data_source_impl.dart:3` | `MainRemoteDataSourceImpl` |
| `modules/main/lib/src/data/repository/main_repository_impl.dart:5` | `MainRepoImpl` |

## 5. Event nomlash (8/9 ot-birinchi)

| Hozir | Bo'lishi kerak | Fayl |
|---|---|---|
| `UpdateProfilePressedEvent` | `ProfileUpdateEvent` | `modules/profile/lib/src/presentation/profile/bloc/profile_event.dart` |

Ta'sir: `profile_bloc.dart:13,33`, `profile_bloc_test.dart`, `edit_profile_mixin.dart`.

## 6. Private `State` klassi

| Hozir | Bo'lishi kerak | Fayl |
|---|---|---|
| `InternetConnectionPageState` | `_InternetConnectionPageState` | `modules/system/lib/src/presentation/internet_connection/internet_connection_page.dart` |

## 7. Hardcoded matn → `context.l10n.*`

| Matn | Fayl:qator |
|---|---|
| `'Logo'` | `modules/initial/lib/src/presentation/splash/splash_page.dart:20` |
| `'1.0.0'` | `modules/profile/lib/src/presentation/profile/profile_page.dart:38` |
| `'404'` | `modules/system/lib/src/presentation/not_found/not_found_page.dart:13` |
| `'Попробовать снова'` (rus, kirill) | `modules/system/lib/src/presentation/internet_connection/internet_connection_page.dart:62` |

## 8. Design system tokenlari

| Nima | Fayl:qator |
|---|---|
| `ElevatedButton` → `CustomLoadingButton` | `modules/profile/lib/src/presentation/profile/profile_page.dart:127,134` |
| `EdgeInsets.only(right: 8)` → `Dimensions.*` | `modules/notifications/lib/src/presentation/notifications/notifications_page.dart:67` |
| `EdgeInsets.only(bottom: 8, left: 4)` → `Dimensions.*` | `modules/profile/lib/src/presentation/profile/profile_page.dart:185` |
| `EdgeInsets.zero` → `Dimensions.*` | `modules/profile/lib/src/presentation/profile/profile_page.dart:207` |
| `SizedBox(height: 12)` → `Dimensions.kGap12` | `modules/system/lib/src/presentation/internet_connection/internet_connection_page.dart:48` |

`bottomNavigationBar: SafeArea(` — 2 joy (`system` moduli, `internet_connection_page.dart:56`,
`not_found_page.dart:14`). Qoidada istisno sifatida qayd etilgan, tuzatish talab qilinmaydi.

## 9. Klassik `const <ClassName>(` konstruktori → `const new(`

`modules/` va `packages/` da 15 fayl (`const new(` ishlatadigan 199 faylga qarshi):

```
modules/initial/lib/src/presentation/welcome/welcome_page.dart
modules/main/lib/src/presentation/main/main_page.dart
modules/payments/lib/src/presentation/payment_methods/payment_methods_page.dart
modules/system/lib/src/presentation/internet_connection/internet_connection_page.dart
packages/components/lib/src/bottom_navigation/bottom_indicator_bar.dart
packages/components/lib/src/bottom_sheet/update_app_sheet.dart
packages/platform_methods/example/lib/main.dart
modules/auth/test/src/presentation/login/bloc/login_bloc_test.dart
modules/auth/test/src/presentation/otp_login/bloc/otp_login_bloc_test.dart
modules/home/test/src/presentation/main/bloc/home_bloc_test.dart
modules/notifications/test/src/presentation/notifications/bloc/notifications_bloc_test.dart
modules/payments/test/src/presentation/payment_methods/bloc/payment_methods_bloc_test.dart
modules/profile/test/src/presentation/profile/bloc/profile_bloc_test.dart
packages/components/test/src/buttons/custom_loading_button_test.dart
packages/components/test/src/gap/gap_test.dart
```

## 10. Test qamrovi

| Modul | Test holati |
|---|---|
| `auth` | to'liq (10 test: datasource, model, repo, di, 2 usecase, 2 bloc, router) |
| `home`, `notifications`, `payments`, `profile` | faqat bloc testi (1 tadan) |
| `initial`, `main`, `system` | test yo'q |

## 11. Konfiguratsiya

- **`.cursorrules`** (42 qator) — kodga zid konvensiya tasvirlardi
  (`fromJson`/`toJson`, `*UseCase` suffiksi, `datasources/`+`repositories/`+`pages/` papkalari).
  Kodda bularning hech biri yo'q. **O'chirildi.**
- **`CLAUDE.md`** — 4 zid nuqta moslashtirildi (§2 event nomi, §2 state nomi, §10 usecase `final class`, §12 `textStyle`). Tafsilot: `flutter-architecture.md` §11.
