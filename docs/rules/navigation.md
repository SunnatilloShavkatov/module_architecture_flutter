# navigation.md — Route, Args, BottomSheet va Dialog

> **Etalon Router:** `modules/notifications/lib/src/router/notifications_router.dart`
> **Etalon BottomSheet:** `modules/notifications/lib/src/presentation/notifications_filter_sheet/notifications_filter_sheet.dart`
> **Etalon Dialog:** `modules/notifications/lib/src/presentation/clear_notifications_dialog/clear_notifications_dialog.dart`
> **Etalon Route Args:** `modules/notifications/lib/src/presentation/notifications_filter_sheet/args/notifications_filter_args.dart`
> **Etalon Route Utils:** `packages/navigation/lib/src/args/route_args_utils.dart`
> **Qoida:** Javob o'zbekcha, kod inglizcha (`AGENTS.md` §0).

---

## 1. Joylashuv va Tuzilma

Navigatsiya marshrutlari, sahifalar va argumentlar quyidagi tartibda taqsimlanadi:

```
packages/navigation/lib/src/
├── name_routes.dart                   # Routes klassi (barcha sahifalar nomlari va pathlari)
├── custom_page_route/                 # CupertinoRoute, MaterialSheetRoute, MaterialDialogRoute, SlideUpTransitionRoute
└── args/
    ├── route_args_utils.dart          # normalizeExtraMap, toNullableInt, toBool, toIntList
    └── <modul>/<name>_args.dart       # Bir nechta modul chaqiradigan umumiy argumentlar

modules/<module>/lib/src/
├── router/<module>_router.dart                     # AppRouter<RouteBase> implementatsiyasi
├── presentation/<sheet>/<sheet>_sheet.dart         # BottomSheet widgeti
├── presentation/<dialog>/<dialog>_dialog.dart       # Dialog widgeti
└── presentation/<feature>/args/<feature>_args.dart # Faqat o'z modulida ishlatiladigan typed args
```

---

## 2. Route Turini Tanlash (Route Types)

Har bir ekran turi uchun `packages/navigation/lib/src/custom_page_route/` dagi tayyor klasslar ishlatiladi:

| Nima ochiladi | Qaysi Route ishlatiladi | Xususiyati |
|---|---|---|
| **To'liq ekran (Full screen)** | `CupertinoRoute` | iOS swipe-back qo'llab-quvvatlaydi, `material_ui` ga mos. |
| **Pastdan chiquvchi oyna (Bottom Sheet)** | `MaterialSheetRoute<T>` | `enableDrag`, `isDismissible`, `useSafeArea`, `isScrollControlled` parametrlariga ega. `T` — sheet `context.pop(value)` bilan qaytaradigan qiymat turi. |
| **Tasdiqlash / Ogohlantirish (Dialog)** | `MaterialDialogRoute<T>` | Destruktiv tasdiq (confirm), ruxsat so'rash (consent) uchun. |
| **Pastdan sirg'alib ochiluvchi ekran** | `SlideUpTransitionRoute` | Modal uslubidagi to'liq ekranlar uchun. |

> ⚠️ **Nega oddiy `GoRoute(builder:)` yaramaydi?**  
> `go_router` default holatda `package:flutter/material` ning `MaterialApp` ini qidiradi. Bizning loyihamiz `package:material_ui` dan foydalangani uchun, oddiy `GoRoute(builder:)` `NoTransitionPage` ga tushib qoladi: natijada animatsiya va iOS swipe-back ishlamaydi. Har doim `CupertinoRoute`, `MaterialSheetRoute` yoki `MaterialDialogRoute` ishlatiladi.

---

## 3. Qat'iy Qoidalar (Non-negotiables)

1. **`showDialog` va `showModalBottomSheet` Qat'iyan Taqiq:** Dialog va Sheet'lar hech qachon imperativ metodlar bilan ochilmaydi! Ular router stack'idan tashqarida ochilib, shell route, deep link va back button mantiqini buzadi. **Barcha dialog va sheet'lar routerda alohida route sifatida ro'yxatdan o'tadi va `context.pushNamed` orqali ochiladi.**
2. **Generic `<T>` Aniqligi:** `MaterialDialogRoute<T>` / `MaterialSheetRoute<T>` va `context.pushNamed<T>` generic turi qaytariladigan qiymat bilan bir xil bo'lishi shart (masalan: `MaterialDialogRoute<bool>` + `context.pushNamed<bool>` + `context.pop(true)`). Aks holda runtimeda cast xatosi yuz beradi.
   Qiymat qaytarmaydigan sheet ham genericni aniq yozadi: `MaterialSheetRoute<void>`.
3. **Routes Nomlari Yagona Manbada:** Barcha marshrut nomlari va pathlari `packages/navigation/lib/src/name_routes.dart` dagi `Routes` klassida `static const String` bo'lishi shart. Sahifa yoki router ichida hardcoded string taqiqlangan.
4. **Router Implements:** Har bir router `final class <Module>Router implements AppRouter<RouteBase>` va `List<RouteBase> getRouters(Injector di)` shaklida bo'ladi. BLoC `di` orqali yaratiladi.
5. **Xavfsiz Argument Parsing (`.parse`):** `state.extra as MyArgs` yoki `state.extra! as MyArgs` qilib xom kasting qilish taqiqlangan (ekran qayta qurilganda yoki deep linkda `extra` null bo'ladi). Har doim `XxxArgs.parse(state.extra, queryParameters: state.uri.queryParameters)` ishlatiladi.
6. **`extra` orqali Callback Uzatish Taqiq:** `extra: {'onSelected': (v) {...}}` — funksiya serialize bo'lmaydi, deep link va state restore da yo'qoladi. Sheet/dialog natijani **doim `context.pop(value)` orqali qaytaradi**, chaqiruvchi esa `await context.pushNamed<T>(...)` bilan oladi.
7. **Args Fayllar Joylashuvi:**
   - Agar argumentni **bir nechta modul** ishlatsa: `packages/navigation/lib/src/args/<modul>/<name>_args.dart`.
   - Agar argument **faqat o'z moduli** ichida ishlatilsa: `modules/<module>/lib/src/presentation/<feature>/args/<name>_args.dart`.
   - Hech qachon args uchun modullararo `pubspec.yaml` bog'liqligi qo'shilmaydi!

---

## 4. Standart Kod Skeletlari va Namunalar

### A. Modul Routeri (`<module>_router.dart`)
```dart
import 'package:core/core.dart';
import 'package:navigation/navigation.dart';
import 'package:notifications/src/presentation/clear_notifications_dialog/clear_notifications_dialog.dart';
import 'package:notifications/src/presentation/notifications/bloc/notifications_bloc.dart';
import 'package:notifications/src/presentation/notifications/notifications_page.dart';
import 'package:notifications/src/presentation/notifications_filter_sheet/args/notifications_filter_args.dart';
import 'package:notifications/src/presentation/notifications_filter_sheet/notifications_filter_sheet.dart';

final class NotificationsRouter implements AppRouter<RouteBase> {
  const new();

  @override
  List<RouteBase> getRouters(Injector di) => [
    // 1. To'liq ekran: CupertinoRoute
    CupertinoRoute(
      path: Routes.notifications,
      name: Routes.notifications,
      builder: (_, _) => BlocProvider<NotificationsBloc>(
        create: (_) => di.get<NotificationsBloc>(),
        child: const NotificationsPage(),
      ),
    ),
    // 2. Bottom Sheet: MaterialSheetRoute<String> — String qaytaradi, args .parse() orqali olinadi
    MaterialSheetRoute<String>(
      path: Routes.notificationsFilterSheet,
      name: Routes.notificationsFilterSheet,
      builder: (_, state) => NotificationsFilterSheet(
        args: NotificationsFilterArgs.parse(state.extra, queryParameters: state.uri.queryParameters),
      ),
    ),
    // 3. Dialog: MaterialDialogRoute<bool>
    MaterialDialogRoute<bool>(
      path: Routes.clearNotificationsDialog,
      name: Routes.clearNotificationsDialog,
      builder: (_, _) => const ClearNotificationsDialog(),
    ),
  ];
}
```

---

### B. Dialog Ochish va Qaytish Namunasi

1. Dialog Widgeti (`ClearNotificationsDialog`):
```dart
import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:navigation/navigation.dart';

class ClearNotificationsDialog extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog(
    shape: const RoundedRectangleBorder(borderRadius: Dimensions.kBorderRadius16),
    title: Text(context.l10n.notificationsTitle, style: context.textStyle.defaultW600x20),
    content: Text(
      context.l10n.areYouSureWantDelete,
      style: context.textStyle.defaultW400x14.copyWith(color: context.color.textSecondary),
    ),
    actions: [
      TextButton(
        onPressed: () => context.pop(false),
        child: Text(context.l10n.cancel, style: context.textStyle.defaultW500x14),
      ),
      TextButton(
        onPressed: () => context.pop(true),
        child: Text(
          context.l10n.confirm,
          style: context.textStyle.defaultW500x14.copyWith(color: context.colorScheme.error),
        ),
      ),
    ],
  );
}
```

2. Mixin / Sahifadan chaqirish:
```dart
Future<void> _confirmClearAll() async {
  final confirmed = await context.pushNamed<bool>(Routes.clearNotificationsDialog);
  if (confirmed == true && mounted) {
    bloc.add(const ClearAllNotificationsEvent());
  }
}
```

---

### C. BottomSheet Ochish va Qaytish Namunasi

1. BottomSheet Widgeti (`NotificationsFilterSheet`):
```dart
import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:navigation/navigation.dart';

class NotificationsFilterSheet extends StatelessWidget {
  const new({required this.args, super.key});

  final NotificationsFilterArgs args;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: Dimensions.kPaddingAll16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(context.l10n.notificationsTitle, style: context.textStyle.defaultW600x20),
          Dimensions.kGap8,
          for (final filter in NotificationsFilterArgs.availableFilters)
            ListTile(
              title: Text(filter, style: context.textStyle.defaultW400x16),
              trailing: args.selectedFilter == filter ? Icon(Icons.check, color: context.color.primary) : null,
              // Natija POP orqali qaytadi — callback `extra` da uzatilmaydi.
              onTap: () => context.pop(filter),
            ),
        ],
      ),
    ),
  );
}
```

2. Mixin / Sahifadan chaqirish:
```dart
Future<void> _showFilterSheet() async {
  final filter = await context.pushNamed<String>(
    Routes.notificationsFilterSheet,
    extra: NotificationsFilterArgs(selectedFilter: _selectedFilter).toMap(),
  );
  if (filter == null || !mounted) {
    return;
  }
  setState(() => _selectedFilter = filter);
}
```

---

### D. Typed Args Klassi va `.parse()` Sintaksisi
```dart
import 'package:core/core.dart';
import 'package:navigation/navigation.dart';

final class NotificationsFilterArgs extends Equatable {
  const new({this.selectedFilter = defaultFilter});

  factory parse(Object? extra, {Map<String, String>? queryParameters}) {
    final map = normalizeExtraMap(extra);
    final qp = queryParameters ?? const <String, String>{};

    return NotificationsFilterArgs(
      selectedFilter: map?['selectedFilter'] as String? ?? qp['selectedFilter'] ?? defaultFilter,
    );
  }

  static const String defaultFilter = 'All';
  static const List<String> availableFilters = [defaultFilter, 'Unread', 'Read'];

  final String selectedFilter;

  Map<String, dynamic> toMap() => {'selectedFilter': selectedFilter};

  @override
  List<Object?> get props => [selectedFilter];
}
```

> `extra` typed instance bo'lishi ham mumkin (`extra: MyArgs(...)`). Bunday holda `parse` birinchi qatorda
> uni qaytaradi — etalon: `modules/profile/lib/src/presentation/edit_profile/args/edit_profile_args.dart`.
>
> ```dart
> factory parse(Object? extra, {Map<String, String>? queryParameters}) {
>   if (extra is EditProfileArgs) {
>     return extra;
>   }
>   final map = normalizeExtraMap(extra);
>   ...
> }
> ```

---

## 5. Eng Ko'p Qilinadigan Xatolar (Anti-patterns)

- ❌ `showDialog(...)` yoki `showModalBottomSheet(...)` chaqirish (router stackidan chiqib ketadi).
- ❌ `Navigator.push(...)`, `Navigator.pop(...)`, `MaterialPageRoute(...)` ishlatish.
- ❌ `state.extra as MyArgs` / `state.extra! as MyArgs` deb to'g'ridan-to'g'ri cast qilish (ekran refreshida yoki deep linkda crash beradi).
- ❌ `extra` orqali callback (`ValueChanged`, `VoidCallback`) uzatish — natija `context.pop(value)` bilan qaytariladi.
- ❌ Genericsiz `MaterialSheetRoute(` / `MaterialDialogRoute(` yozish (qaytish qiymati `dynamic` bo'lib qoladi).
- ❌ Hardcoded route string: `context.push('/notifications/detail')` (har doim `Routes.*` va `pushNamed`).
- ❌ Oddiy `GoRoute(builder: ...)` ishlatish (iOS swipe-back yo'qoladi, doim `CupertinoRoute`).

---

## 6. Tekshiruv Ro'yxati (Checklist)

- [ ] Route nomi `packages/navigation/lib/src/name_routes.dart` dagi `Routes` klassida e'lon qilingan.
- [ ] Sahifa uchun `CupertinoRoute`, sheet uchun `MaterialSheetRoute<T>`, dialog uchun `MaterialDialogRoute<T>` ishlatilgan (generic aniq yozilgan).
- [ ] Hech qanday `showDialog` yoki `showModalBottomSheet` ishlatilmagan, barchasi alohida route.
- [ ] Dialog/Sheet dan qaytish `context.pop(value)` orqali, chaqirish `await context.pushNamed<T>(...)` orqali.
- [ ] Argumentlar `XxxArgs.parse(state.extra, queryParameters: ...)` va `route_args_utils.dart` orqali olingan.
- [ ] `extra` ichida callback yo'q — natija `context.pop(value)` orqali qaytariladi.
- [ ] `./scripts/verify.sh` muvaffaqiyatli o'tgan.

