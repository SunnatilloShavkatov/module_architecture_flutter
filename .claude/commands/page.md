---
description: Yangi page + mixin (to'liq ekran)
argument-hint: <module> <feature>
allowed-tools: Read, Edit, Write, Grep, Glob
---

Etalon (topshiriqqa mos bittasini tanla, butun papkani emas — page + mixin juftini o'qi):
- ro'yxat + paginatsiya → `modules/notifications/lib/src/presentation/notifications/`
- forma + validatsiya → `modules/auth/lib/src/presentation/login/`
- forma tahrirlash + args + pop result → `modules/profile/lib/src/presentation/edit_profile/`

Qoida: `docs/rules/page-mixin.md` TL;DR bloki.

Talab:
- `mixin <Name>Mixin on State<...>`; UI ma'lumoti mixin'da, `_handleStates` ichida o'zgaradi
- hosila qiymat — getter, `setState` bilan hisoblanmaydi
- har `BlocBuilder` / `BlocConsumer` da `buildWhen` + sealed subfamily nomi
- `context.l10n.*`, `Dimensions.*`, `context.color` / `context.textStyle`
- navigatsiya: `context.pushNamed` / `context.pop`; modal — `MaterialSheetRoute` / `MaterialDialogRoute<T>`
- route'ni `modules/<module>/lib/src/router/<module>_router.dart` ga qo'sh

Turn ichida analyze/test ishlatma.

Topshiriq: $ARGUMENTS
