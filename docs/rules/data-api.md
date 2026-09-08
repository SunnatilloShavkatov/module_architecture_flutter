# data-api.md — Data Qatlami (ApiPaths, DataSource, Model, RepositoryImpl)

> **Etalon DataSource:** `modules/notifications/lib/src/data/datasource/notifications_remote_data_source.dart`
> **Etalon Model:** `modules/notifications/lib/src/data/models/notification_model.dart`
> **Etalon RepositoryImpl:** `modules/notifications/lib/src/data/repository/notifications_repository_impl.dart`
> **Qoida:** Javob o'zbekcha, kod inglizcha (`AGENTS.md` §0).

---

## 1. Joylashuv va Tuzilma

```
modules/<module>/lib/src/data/
├── datasource/
│   ├── <module>_api_paths.dart
│   ├── <module>_remote_data_source.dart
│   └── <module>_remote_data_source_impl.dart    # part of '<module>_remote_data_source.dart'
├── models/
│   └── <module>_model.dart                       # extends <Module>Entity
└── repository/
    └── <module>_repository_impl.dart            # implements <Module>Repository
```

Yangi endpoint kiritish ketma-ketligi:
**ApiPaths ➔ DataSource ➔ Model ➔ RepositoryImpl ➔ UseCase ➔ DI ➔ BLoC**.

---

## 2. Qat'iy Qoidalar (Non-negotiables)

1. **Part-of Impl Shablon:** `*_remote_data_source.dart` ichida interfeys, `part '*_remote_data_source_impl.dart';` ichida esa implementatsiya yoziladi.
2. **Model extends Entity:** Har bir model mos Entity dan meros oladi (`class NotificationModel extends NotificationEntity`). Entityda JSON bo'lmaydi, faqat Modelda `fromMap` va `toMap` bo'ladi.
3. **Dart 3.47 Shorthand:** `const new(...)`, `factory fromMap(...)`, `const new _()`.
4. **Xavfsiz Parsing (Safe Parsing):**
   - Ro'yxat maydonlari (`List`) har doim bo'sh ro'yxat bilan boshlanadi: `(map['items'] as List?) ?? []`.
   - String, int, double tiplar `as Type?` orqali kasting qilinadi, xom `map['id'] as int` qilinmaydi.
5. **Xatolarni Tutish:** Remote DataSource ichida `FormatException` va `TypeError` lar `ServerException` ga o'raladi. RepositoryImpl esa ularni `Left(error.failure)` yoki `Left(ServerFailure(...))` sifatida qaytaradi.
6. **No Direct Module Imports:** Data qatlami boshqa hech qaysi modulni to'g'ridan-to'g'ri import qilmaydi (`arch-guard`).

---

## 3. Standart Kod Skeletlari va Namunalar

### A. ApiPaths
```dart
final class NotificationsApiPaths {
  const new _();

  static const String clientNotifications = '/api/notifications/client';
  static const String markAsRead = '/api/notifications/client/{id}/read';
  static const String unreadCount = '/api/notifications/unread-count';
}
```

### B. Remote DataSource (Interfeys + Part-Impl)
```dart
// notifications_remote_data_source.dart
import 'package:core/core.dart';
import 'package:notifications/src/data/models/notification_model.dart';

part 'notifications_remote_data_source_impl.dart';

abstract interface class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> getNotifications({required int page, int limit = Constants.defaultPageLimit});
  Future<void> markAsRead({required String id});
}
```

```dart
// notifications_remote_data_source_impl.dart
part of 'notifications_remote_data_source.dart';

final class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  const new(this._networkProvider);

  final NetworkProvider _networkProvider;

  @override
  Future<List<NotificationModel>> getNotifications({required int page, int limit = Constants.defaultPageLimit}) async {
    try {
      final response = await _networkProvider.fetchMethod<List<dynamic>>(
        NotificationsApiPaths.clientNotifications,
        methodType: RMethodTypes.get,
        queryParameters: {'page': page, 'limit': limit},
      );
      final rawList = response.data ?? [];
      return rawList.whereType<Map<String, dynamic>>().map(NotificationModel.fromMap).toList();
    } on FormatException {
      throw ServerException.formatException(locale: _networkProvider.locale);
    } on ServerException {
      rethrow;
    } on Exception {
      rethrow;
    } on Error catch (error, stackTrace) {
      logMessage('ERROR getNotifications: ', error: error, stackTrace: stackTrace);
      if (error is TypeError) {
        throw ServerException.typeError(locale: _networkProvider.locale);
      }
      throw ServerException.unknownError(locale: _networkProvider.locale);
    }
  }

  @override
  Future<void> markAsRead({required String id}) async {
    await _networkProvider.fetchMethod<dynamic>(
      NotificationsApiPaths.markAsRead.replaceAll('{id}', id),
      methodType: RMethodTypes.patch,
    );
  }
}
```

### C. Model
```dart
import 'package:notifications/src/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const new({
    required super.id,
    required super.title,
    required super.message,
    required super.timestamp,
    required super.isRead,
    required super.type,
    super.timeAgo,
  });

  factory fromMap(Map<String, dynamic> map) => NotificationModel(
    id: '${map['id'] ?? ''}',
    title: map['title'] as String? ?? '',
    message: map['message'] as String? ?? '',
    timestamp: DateTime.tryParse(map['timestamp']?.toString() ?? '') ?? DateTime.now(),
    isRead: map['isRead'] as bool? ?? false,
    type: map['type'] as String? ?? 'info',
    timeAgo: map['timeAgo'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'message': message,
    'timestamp': timestamp.toIso8601String(),
    'isRead': isRead,
    'type': type,
    'timeAgo': timeAgo,
  };
}
```

### D. Repository Impl
```dart
import 'package:core/core.dart';
import 'package:notifications/src/data/datasource/notifications_remote_data_source.dart';
import 'package:notifications/src/domain/entities/notification_entity.dart';
import 'package:notifications/src/domain/repository/notifications_repository.dart';

final class NotificationsRepositoryImpl implements NotificationsRepository {
  const new(this._remoteDataSource);

  final NotificationsRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<List<NotificationEntity>> getNotifications({required int page, int limit = Constants.defaultPageLimit}) async {
    try {
      final models = await _remoteDataSource.getNotifications(page: page, limit: limit);
      return Right(models);
    } on ServerException catch (error) {
      return Left(error.failure);
    } on Exception catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  ResultFuture<Unit> markAsRead({required String id}) async {
    try {
      await _remoteDataSource.markAsRead(id: id);
      return const Right(unit);
    } on ServerException catch (error) {
      return Left(error.failure);
    } on Exception catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }
}
```

---

## 4. Eng Ko'p Qilinadigan Xatolar (Anti-patterns)

- ❌ `Entity` ichida `fromMap` yoki `toMap` yozish (bu faqat `Model` da bo'ladi).
- ❌ DataSource faylini `part` va `part of` siz alohida fayl qilib yozish.
- ❌ Xom parsing: `map['id'] as int` (serverdan `null` yoki `string` kelsa crash beradi).
- ❌ Repository nomini `NotificationsRepoImpl` deb qisqartirish (har doim to'liq `NotificationsRepositoryImpl`).

---

## 5. Tekshiruv Ro'yxati (Checklist)

- [ ] `*_remote_data_source.dart` va uning `part '*_remote_data_source_impl.dart'` fayli to'g'ri bog'langan.
- [ ] Model `Entity` dan meros olgan (`extends`) va xavfsiz `fromMap`/`toMap` ga ega.
- [ ] RepositoryImpl barcha xatoliklarni `Left(Failure)` shaklida qaytaradi (rethrow qilmaydi).
- [ ] `Unit` qaytaruvchi amallarda `const Right(unit)` ishlatilgan.
