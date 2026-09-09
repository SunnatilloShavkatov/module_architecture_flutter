# Style debt — guard bloklamaydigan qoldiqlar

> Guard buzilishlari bu yerda **emas**: ular `.claude/rules/arch-migration.md` da
> (`scripts/arch_guard_scan.sh --md` avtomatik yozadi). Bu fayl — qo'lda yuritiladigan,
> `arch-guard` majburlamaydigan (60–90% oraliqdagi) style qoldiqlari ro'yxati.

**Guard holati: 0 / 269 fayl buzilish** (`modules/*/lib` + `packages/*/lib`, test'siz).
Oxirgi tekshiruv: 2026-09-10.

Yangi kod bu ro'yxatga qo'shilmaydi — shablon shu holda klonlanadi va debt faqat kamayadi.
Agent qoidasi: **shu fayldagi eski patternni namuna qilib ko'chirma**, etalon `notifications`
moduli (`AGENTS.md` §3).

---

## 1. `auth` — yagona «eski» modul

| Nima | Fayl |
|---|---|
| `domain/repos/` → `domain/repository/` | `modules/auth/lib/src/domain/repos/auth_repo.dart` |
| `data/repo/` → `data/repository/` | `modules/auth/lib/src/data/repo/auth_repo_impl.dart` |
| `AuthRepo` → `AuthRepository`, `AuthRepoImpl` → `AuthRepositoryImpl` | yuqoridagi 2 fayl + `src/di/auth_injection.dart` |
| Test nomi `login_usecase_test.dart` → `login_test.dart` | `modules/auth/test/src/domain/usecases/` |
| Test nomi `otp_login_usecase_test.dart` → `otp_login_test.dart` | `modules/auth/test/src/domain/usecases/` |
| Raw `TextStyle(color: ...)` → `context.textStyle.*.copyWith(...)` | `login_page.dart:52,110`, `otp_login_page.dart:64,84` |

Qolgan modullar (`home`, `main`, `notifications`, `payments`, `profile`, `system`) —
`<Module>Repository` + `domain/repository/` + `data/repository/` bilan to'g'ri.

## 2. `final class` yetishmaydi (infratuzilma sinflari)

| Fayl:qator | Klass |
|---|---|
| `modules/profile/lib/src/presentation/profile/bloc/profile_bloc.dart:10` | `ProfileBloc` |
| `modules/home/lib/src/data/datasource/home_local_data_source_impl.dart:3` | `HomeLocalDataSourceImpl` |
| `modules/profile/lib/src/data/datasource/profile_local_data_source_impl.dart:6` | `ProfileLocalDataSourceImpl` |
| `modules/main/lib/src/data/datasource/main_local_data_source_impl.dart:3` | `MainLocalDataSourceImpl` |
| `modules/main/lib/src/data/datasource/main_remote_data_source_impl.dart:3` | `MainRemoteDataSourceImpl` |

## 3. Event nomlash

| Hozir | Bo'lishi kerak | Fayl |
|---|---|---|
| `UpdateProfilePressedEvent` | `ProfileUpdateEvent` | `modules/profile/lib/src/presentation/profile/bloc/profile_event.dart` |

Ta'sir: `profile_bloc.dart`, `profile_bloc_test.dart`, `edit_profile_mixin.dart`.

## 4. Private `State` klassi

| Hozir | Bo'lishi kerak | Fayl |
|---|---|---|
| `InternetConnectionPageState` | `_InternetConnectionPageState` | `modules/system/lib/src/presentation/internet_connection/internet_connection_page.dart` |

## 5. Design system tokenlari

| Nima | Fayl:qator |
|---|---|
| `ElevatedButton` → `CustomLoadingButton` | `modules/profile/lib/src/presentation/profile/profile_page.dart:128,135` |
| `EdgeInsets.only(bottom: 8, left: 4)` → `Dimensions.*` | `modules/profile/.../profile_page.dart:186` |
| `EdgeInsets.zero` → `Dimensions.*` | `modules/profile/.../profile_page.dart:208` |

## 6. Raqamli literal matn (past prioritet)

`Text('1.0.0')` (`profile_page.dart:39`), `Text('404')` (`not_found_page.dart:13`).
Guard faqat harfli literalni bloklaydi; bularni ham `context.l10n.*` ga o'tkazish afzal.

## 7. Klassik `const <ClassName>(` konstruktori — faqat testlarda

`lib/` toza (guard majburlaydi). Qoldiq — 8 ta test fayli:
`auth`, `home`, `notifications`, `payments`, `profile` bloc testlari va
`packages/components/test/src/{gap/gap_test.dart,buttons/custom_loading_button_test.dart}`.

## 8. Test qamrovi

| Modul | Test soni |
|---|---|
| `notifications` | 11 — to'liq etalon |
| `auth` | 10 |
| `home`, `payments`, `profile` | 1 (faqat bloc) |
| `initial`, `main`, `system` | 0 |
