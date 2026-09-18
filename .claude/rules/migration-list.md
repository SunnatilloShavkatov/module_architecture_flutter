# Style debt — remnants the guard doesn't block

> Guard violations are **not** here: they live in `.claude/rules/arch-migration.md`
> (auto-written by `scripts/arch_guard_scan.sh --md`). This file is a manually
> maintained list of style remnants (in the 60–90% range) that `arch-guard` does not enforce.

**Guard status: 0 / 269 files in violation** (`modules/*/lib` + `packages/*/lib`, excluding tests).
Last checked: 2026-09-10.

New code must not be added to this list — the template is cloned in this state
and debt only decreases. Agent rule: **don't copy an old pattern from this file as an example**,
use the `notifications` reference module instead (`AGENTS.md` §3).

---

## 1. `auth` — the one "legacy" module

| What                                                                 | File                                                  |
|----------------------------------------------------------------------|-------------------------------------------------------|
| `domain/repos/` → `domain/repository/`                               | `modules/auth/lib/src/domain/repos/auth_repo.dart`    |
| `data/repo/` → `data/repository/`                                    | `modules/auth/lib/src/data/repo/auth_repo_impl.dart`  |
| `AuthRepo` → `AuthRepository`, `AuthRepoImpl` → `AuthRepositoryImpl` | the 2 files above + `src/di/auth_injection.dart`      |
| Test name `login_usecase_test.dart` → `login_test.dart`              | `modules/auth/test/src/domain/usecases/`              |
| Test name `otp_login_usecase_test.dart` → `otp_login_test.dart`      | `modules/auth/test/src/domain/usecases/`              |
| Raw `TextStyle(color: ...)` → `context.textStyle.*.copyWith(...)`    | `login_page.dart:52,110`, `otp_login_page.dart:64,84` |

Remaining modules (`home`, `main`, `notifications`, `payments`, `profile`, `system`) —
correctly use `<Module>Repository` + `domain/repository/` + `data/repository/`.

## 2. Missing `final class` (infrastructure classes)

| File:line                                                                       | Class                        |
|---------------------------------------------------------------------------------|------------------------------|
| `modules/profile/lib/src/presentation/profile/bloc/profile_bloc.dart:10`        | `ProfileBloc`                |
| `modules/home/lib/src/data/datasource/home_local_data_source_impl.dart:3`       | `HomeLocalDataSourceImpl`    |
| `modules/profile/lib/src/data/datasource/profile_local_data_source_impl.dart:6` | `ProfileLocalDataSourceImpl` |
| `modules/main/lib/src/data/datasource/main_local_data_source_impl.dart:3`       | `MainLocalDataSourceImpl`    |
| `modules/main/lib/src/data/datasource/main_remote_data_source_impl.dart:3`      | `MainRemoteDataSourceImpl`   |

## 3. Event naming

| Now                         | Should be            | File                                                                   |
|-----------------------------|----------------------|------------------------------------------------------------------------|
| `UpdateProfilePressedEvent` | `ProfileUpdateEvent` | `modules/profile/lib/src/presentation/profile/bloc/profile_event.dart` |

Impact: `profile_bloc.dart`, `profile_bloc_test.dart`, `edit_profile_mixin.dart`.

## 4. Private `State` class

| Now                           | Should be                      | File                                                                                    |
|-------------------------------|--------------------------------|-----------------------------------------------------------------------------------------|
| `InternetConnectionPageState` | `_InternetConnectionPageState` | `modules/system/lib/src/presentation/internet_connection/internet_connection_page.dart` |

## 5. Design system tokens

| What                                                   | File:line                                                                |
|--------------------------------------------------------|--------------------------------------------------------------------------|
| `ElevatedButton` → `CustomLoadingButton`               | `modules/profile/lib/src/presentation/profile/profile_page.dart:128,135` |
| `EdgeInsets.only(bottom: 8, left: 4)` → `Dimensions.*` | `modules/profile/.../profile_page.dart:186`                              |
| `EdgeInsets.zero` → `Dimensions.*`                     | `modules/profile/.../profile_page.dart:208`                              |

## 6. Numeric literal text (low priority)

`Text('1.0.0')` (`profile_page.dart:39`), `Text('404')` (`not_found_page.dart:13`).
Guard only blocks alphabetic literals; moving these to `context.l10n.*` too is preferred.

## 7. Classic `const <ClassName>(` constructor — tests only

`lib/` is clean (guard enforces it). Remaining — 8 test files:
bloc tests in `auth`, `home`, `notifications`, `payments`, `profile`, and
`packages/components/test/src/{gap/gap_test.dart,buttons/custom_loading_button_test.dart}`.

## 8. Test coverage

| Module                        | Test count          |
|-------------------------------|---------------------|
| `notifications`               | 11 — full reference |
| `auth`                        | 10                  |
| `home`, `payments`, `profile` | 1 (bloc only)       |
| `initial`, `main`, `system`   | 0                   |
