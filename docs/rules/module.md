# module.md — Modul, Container, DI va Modullararo Bog'lanish

> **Etalon Container:** `modules/notifications/lib/src/notifications_container.dart`
> **Etalon DI:** `modules/notifications/lib/src/di/notifications_injection.dart`
> **Etalon Generator:** `scripts/create_module.sh`
> **Qoida:** Javob o'zbekcha, kod inglizcha (`AGENTS.md` §0).

---

## 1. Joylashuv va Tuzilma

Har bir modul mustaqil va izolyatsiyalangan mini-paketdir:

```
modules/<module>/
├── lib/
│   ├── <module>.dart                 # Barrel fayl: faqat container eksport qiladi
│   └── src/
│       ├── <module>_container.dart   # ModuleContainer implementatsiyasi
│       ├── data/                     # datasource, models, repository
│       ├── di/                       # Injection implementatsiyasi
│       ├── domain/                   # entities, repository, usecases, interactor
│       ├── presentation/             # bloc, mixin, widgets, page
│       └── router/                   # AppRouter implementatsiyasi
├── test/                             # lib qatlamini 1-ga-1 takrorlovchi testlar
└── pubspec.yaml                      # Faqat packages/* va pub paketlar
```

> ⚡ **Yangi modul generatsiyasi:** Qo'lda 18 ta fayl yozmaslik uchun tayyor buyruq:
> ```bash
> ./scripts/create_module.sh <module_name>
> ```

---

## 2. Qat'iy Qoidalar (Non-negotiables)

1. **Modullararo Izolyatsiya (`arch-guard`):** Hech bir modul boshqa modulni to'g'ridan-to'g'ri `import` qilishi yoki `pubspec.yaml` ga yozishi qat'iyan man etiladi.
2. **Container Yagona Kirish Nuqtasi:** Ilova qolgan qismiga modul faqat `ModuleContainer` orqali taqdim etiladi.
3. **Orkestratsiya:** Modul faqat `packages/merge_dependencies/lib/merge_dependencies.dart` dagi `MergeDependencies._allContainer` ro'yxatiga qo'shiladi.
4. **Modullararo Muloqot:** 
   - Biznes logika chaqirish uchun: `ModuleInteractor<Type, Params>` (`core`).
   - Vidjet chaqirish uchun: `WidgetFactory<Args>` (`core`).
   - Navigatsiya uchun: `Routes` va `XxxArgs.parse(state.extra)`.
5. **Dart 3.47 Shorthand:** Barcha konstruktorlarda `const new()`, `new(this._dep)`.

---

## 3. Standart Kod Skeletlari va Namunalar

### A. ModuleContainer
```dart
import 'package:core/core.dart';
import 'package:navigation/navigation.dart';
import 'package:notifications/src/di/notifications_injection.dart';
import 'package:notifications/src/router/notifications_router.dart';

final class NotificationsContainer implements ModuleContainer {
  const new();

  @override
  AppRouter<RouteBase> get router => const NotificationsRouter();

  @override
  Injection get injection => const NotificationsInjection();
}
```

### B. DI (Injection)
```dart
import 'dart:async' show FutureOr;
import 'package:core/core.dart';
import 'package:notifications/src/data/datasource/notifications_remote_data_source.dart';
import 'package:notifications/src/data/repository/notifications_repository_impl.dart';
import 'package:notifications/src/domain/interactor/get_unread_notifications_count_interactor.dart';
import 'package:notifications/src/domain/repository/notifications_repository.dart';
import 'package:notifications/src/domain/usecases/get_notifications.dart';
import 'package:notifications/src/presentation/notifications/bloc/notifications_bloc.dart';
import 'package:notifications/src/presentation/notifications/factory/notification_item_factory.dart';

final class NotificationsInjection implements Injection {
  const new();

  @override
  FutureOr<void> registerDependencies({required Injector di}) {
    di
      /// data sources
      ..registerLazySingleton<NotificationsRemoteDataSource>(() => NotificationsRemoteDataSourceImpl(di.get()))
      /// repositories
      ..registerLazySingleton<NotificationsRepository>(() => NotificationsRepositoryImpl(di.get()))
      /// usecases
      ..registerLazySingleton(() => GetNotifications(di.get()))
      /// interactors (boshqa modullar chaqirishi uchun)
      ..registerLazySingleton<ModuleInteractor<int, NoParams>>(
        () => GetUnreadNotificationsCountInteractor(di.get()),
        instanceName: InstanceNameKeys.getUnreadNotificationsCountInteractor,
      )
      /// widget factories
      ..registerLazySingleton<WidgetFactory<NotificationItemArgs>>(
        NotificationItemFactory.new,
        instanceName: InstanceNameKeys.notificationItemFactory,
      )
      /// blocs (har doim registerFactory)
      ..registerFactory(() => NotificationsBloc(di.get()));
  }
}
```

### C. Modullararo Muloqot (Iste'molchi tomonda)
```dart
// Boshqa moduldan ma'lumot olish:
final interactor = di.get<ModuleInteractor<int, NoParams>>(
  instanceName: InstanceNameKeys.getUnreadNotificationsCountInteractor,
);
final result = await interactor(const NoParams());

// Boshqa modul vidjetini chizish:
final factory = di.get<WidgetFactory<NotificationItemArgs>>(
  instanceName: InstanceNameKeys.notificationItemFactory,
);
final widget = factory.create(NotificationItemArgs(id: '1', title: 'Salom', isRead: false));
```

---

## 4. Eng Ko'p Qilinadigan Xatolar (Anti-patterns)

- ❌ `pubspec.yaml` ga boshqa modulni `path: ../other_module` qilib yozish (`arch-guard` buziladi).
- ❌ Bloc'ni `registerLazySingleton` bilan ro'yxatdan o'tkazish (BLoC har doim `registerFactory` bo'lishi shart).
- ❌ Modullararo argumentlar uchun model ishlatish (argumentlar `package:core/lib/src/entities/` ga qo'yiladi).

---

## 5. Tekshiruv Ro'yxati (Checklist)

- [ ] `<Module>Container` yaratilgan va `merge_dependencies` ga qo'shilgan.
- [ ] `pubspec.yaml` da faqat `packages/*` mavjud, begona modul yo'q.
- [ ] BLoC `registerFactory` orqali ro'yxatdan o'tgan.
- [ ] Modullararo aloqa faqat `ModuleInteractor` yoki `WidgetFactory` orqali qilingan.
