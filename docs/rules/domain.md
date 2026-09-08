# domain.md — Domain Qatlami (Entity, Repository, UseCase, Interactor)

> **Etalon Entity:** `modules/notifications/lib/src/domain/entities/notification_entity.dart`
> **Etalon Repository:** `modules/notifications/lib/src/domain/repository/notifications_repository.dart`
> **Etalon UseCase:** `modules/notifications/lib/src/domain/usecases/get_notifications.dart`
> **Etalon Interactor:** `modules/notifications/lib/src/domain/interactor/get_unread_notifications_count_interactor.dart`
> **Qoida:** Javob o'zbekcha, kod inglizcha (`AGENTS.md` §0).

---

## 1. Joylashuv va Tuzilma

Domain qatlami — sof biznes mantig'i. Unda hech qanday tashqi framework (`flutter`, `dio`, `hive` va h.k.) yoki UI import qilinmaydi.

```
modules/<module>/lib/src/domain/
├── entities/       # Sof biznes modellari (Equatable bilan)
├── repository/     # Repository interfeyslari (abstract interface class)
├── usecases/       # Yagona maqsadli operatsiyalar (UsecaseWithParams / UsecaseWithoutParams)
└── interactor/     # Modullararo chaqiruv interfeysi (ModuleInteractor)
```

---

## 2. Qat'iy Qoidalar (Non-negotiables)

1. **Sof Dart:** Faqat `package:core/core.dart` (Equatable, Failure, Either) import qilinadi. Framework yoki tashqi kutubxona taqiqlangan.
2. **Entity Immutability:** Barcha fieldlar `final`. Entity hech qachon `fromMap` yoki `toMap` ni o'z ichiga olmaydi (bular faqat Model qatlamida).
3. **Dart 3.47 Constructor Shorthand:** `const new({required this.id, ...})`.
4. **Mocktail uchun Usecase:** Mock qilish imkoni bo'lishi uchun UseCase klasslari `final class` emas, `class` bo'lishi shart (`class GetNotifications extends Usecase...`).
5. **Natija Turi:** Asinxron operatsiyalar har doim `ResultFuture<T>` (`Future<Either<Failure, T>>`) qaytaradi.
6. **Modullararo Izolyatsiya:** Boshqa modul domenidan foydalanish faqat `core` dagi `ModuleInteractor` orqali bo'ladi.

---

## 3. Standart Kod Skeletlari va Namunalar

### A. Entity
```dart
import 'package:core/core.dart' show Equatable;

class NotificationEntity extends Equatable {
  const new({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isRead,
    required this.type,
    this.timeAgo,
  });

  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String type;
  final String? timeAgo;

  @override
  List<Object?> get props => [id, title, message, timestamp, isRead, type, timeAgo];
}
```

### B. Repository Interfeysi
```dart
import 'package:core/core.dart';
import 'package:notifications/src/domain/entities/notification_entity.dart';

abstract interface class NotificationsRepository {
  ResultFuture<List<NotificationEntity>> getNotifications({required int page, int limit = Constants.defaultPageLimit});

  ResultFuture<Unit> markAsRead({required String id});

  ResultFuture<Unit> clearAll();

  ResultFuture<int> getUnreadCount();
}
```

### C. UseCase
```dart
import 'package:core/core.dart';
import 'package:notifications/src/domain/entities/notification_entity.dart';
import 'package:notifications/src/domain/repository/notifications_repository.dart';

class GetNotifications extends UsecaseWithParams<List<NotificationEntity>, GetNotificationsParams> {
  const new(this._repository);

  final NotificationsRepository _repository;

  @override
  ResultFuture<List<NotificationEntity>> call(GetNotificationsParams params) =>
      _repository.getNotifications(page: params.page, limit: params.limit);
}

final class GetNotificationsParams {
  const new({required this.page, this.limit = Constants.defaultPageLimit});

  final int page;
  final int limit;
}
```

### D. Interactor (Modullararo aloqa)
```dart
import 'package:core/core.dart';
import 'package:notifications/src/domain/usecases/get_unread_notifications_count.dart';

final class GetUnreadNotificationsCountInteractor implements ModuleInteractor<int, NoParams> {
  const new(this._getUnreadCount);

  final GetUnreadNotificationsCount _getUnreadCount;

  @override
  ResultFuture<int> call(NoParams params) => _getUnreadCount();
}
```

---

## 4. Eng Ko'p Qilinadigan Xatolar (Anti-patterns)

- ❌ `Entity` ichida `fromMap` yoki JSON parsing qilish (bu Model vazifasi).
- ❌ UseCase klassini `final class` deb e'lon qilish (testda Mocktail `implements` qila olmaydi).
- ❌ Domain ichida `flutter/material.dart` yoki `http/dio` import qilish.
- ❌ Positional o'rniga named dependency konstruktor yozish.

---

## 5. Tekshiruv Ro'yxati (Checklist)

- [ ] Domain qatlamida faqat `package:core/core.dart` va o'zining ichki fayllari import qilingan.
- [ ] Barcha Entity lar `Equatable` dan meros olgan va `const new(...)` shorthandiga ega.
- [ ] UseCase klasslari `class` kalit so'zi bilan yozilgan (`final class` emas).
- [ ] Barcha operatsiyalar `ResultFuture<T>` qaytaradi.
