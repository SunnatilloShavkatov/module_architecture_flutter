# navigation.md — Navigatsiya, Router va Route Args

> Etalon: `modules/notifications/lib/src/router/notifications_router.dart`
> Args parser: `modules/notifications/lib/src/presentation/notifications/args/notification_detail_args.dart`
> Nav utils: `packages/navigation/lib/src/args/route_args_utils.dart`
> Javob o'zbekcha, kod inglizcha (`AGENTS.md` §0).

## 1. Route nomlari

Barcha route nomlari va path'lari `packages/navigation/lib/src/name_routes.dart` da `Routes` klassida `static const String` shaklida e'lon qilinadi:

```dart
abstract final class Routes {
  static const String notifications = 'notifications';
  static const String notificationsFilterSheet = 'notificationsFilterSheet';
  static const String clearNotificationsDialog = 'clearNotificationsDialog';
}
```

Hech qachon sahifa ichida yoki router'da hardcoded string route nomi yozilmaydi.

## 2. Route turlari (Transitions)

Oddiy `GoRoute(builder: ...)` ishlatilmaydi — u iOS swipe-back va standart o'tish animatsiyasini yo'qotadi. Har doim `pageBuilder` bilan quyidagi sahifa turlari ishlatiladi:

| Oyna turi | Route Page klassi | Misol |
|---|---|---|
| Sahifa (To'liq ekran) | `CupertinoRoute` | Asosiy ekranlar, detail sahifalar (iOS swipe-back qo'llab-quvvatlaydi) |
| Bottom Sheet | `MaterialSheetRoute` | Filtr, tanlov, sheet oynalari |
| Dialog / Modal | `MaterialDialogRoute` | Tasdiqlash modal oynalari, ogohlantirishlar |

```dart
final class NotificationsRouter implements AppRouter {
  const new();

  @override
  List<RouteBase> get routes => [
    GoRoute(
      name: Routes.notifications,
      path: '/notifications',
      pageBuilder: (context, state) => CupertinoRoute(
        key: state.pageKey,
        child: const NotificationsPage(),
      ),
    ),
    GoRoute(
      name: Routes.notificationsFilterSheet,
      path: '/notifications/filter',
      pageBuilder: (context, state) => MaterialSheetRoute(
        key: state.pageKey,
        child: const NotificationsFilterSheet(),
      ),
    ),
    GoRoute(
      name: Routes.clearNotificationsDialog,
      path: '/notifications/clear-dialog',
      pageBuilder: (context, state) => MaterialDialogRoute(
        key: state.pageKey,
        child: const ClearNotificationsDialog(),
      ),
    ),
  ];
}
```

## 3. Route argumentlari (Typed Args)

Hech qachon `state.extra as MyClass` qilinmaydi (cast exception xavfi). Har doim xavfsiz `.parse(state.extra)` metodi va `route_args_utils.dart` utility funksiyalari ishlatiladi:

```dart
import 'package:core/core.dart';
import 'package:navigation/navigation.dart';

final class NotificationDetailArgs extends Equatable {
  const new({required this.id, required this.title});

  final String id;
  final String title;

  factory NotificationDetailArgs.parse(Object? extra) {
    final map = normalizeExtraMap(extra);
    return NotificationDetailArgs(
      id: (map['id'] as String?) ?? '',
      title: (map['title'] as String?) ?? '',
    );
  }

  @override
  List<Object?> get props => [id, title];
}
```

Router ichida:
```dart
GoRoute(
  name: Routes.notificationDetail,
  path: '/notifications/detail',
  pageBuilder: (context, state) {
    final args = NotificationDetailArgs.parse(state.extra);
    return CupertinoRoute(
      key: state.pageKey,
      child: NotificationDetailPage(args: args),
    );
  },
)
```

## 4. Navigatsiya chaqiruvi

```dart
// Sahifaga o'tish
context.pushNamed(Routes.notificationDetail, extra: {'id': '123', 'title': 'Salom'});

// Replace / Root darajasida o'tish
context.goNamed(Routes.mainHome);

// Qaytish
context.pop();
```

## 5. Tekshiruv ro'yxati

- [ ] Route nomi `packages/navigation/lib/src/name_routes.dart` da `Routes.*` sifatida kiritilgan.
- [ ] Router `AppRouter` interfeysini implement qilgan va `List<RouteBase> get routes` ga ega.
- [ ] Sahifa uchun `CupertinoRoute`, sheet uchun `MaterialSheetRoute`, dialog uchun `MaterialDialogRoute`.
- [ ] Argument uzatishda typed `XxxArgs.parse(state.extra)` ishlatilgan, xom `as Type` yo'q.
