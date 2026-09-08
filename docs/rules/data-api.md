# data-api.md — Endpoint, DataSource, Model, Repository

> Etalon: `modules/notifications/lib/src/data/` va `modules/notifications/lib/src/domain/`

Yangi endpoint qo'shish tartibi: **ApiPaths → DataSource → Model → Repository → UseCase → DI → Bloc.**

## 1. ApiPaths — modul ichida

```dart
final class NotificationsApiPaths {
  const new _();

  static const String clientNotifications = '/api/notifications/client';
  static const String markAsRead = '/api/notifications/client/{id}/read';
}
```

Har modulda bitta `<Module>ApiPaths`, `data/datasource/` ichida, private `._()` konstruktor, hammasi
`static const String`. Umumiy/global paths class'ga **hech qachon** qo'shma.

## 2. Domain

```dart
// entity — Equatable, fromMap/toMap YO'Q, JSON yo'q
class NotificationEntity extends Equatable {
  const new({required this.id, required this.title, required this.isRead});

  final String id;
  final String title;
  final bool isRead;

  @override
  List<Object?> get props => [id, title, isRead];
}

// repository — "Repository", "Repo" emas
abstract interface class NotificationsRepository {
  const new();

  ResultFuture<List<NotificationEntity>> getNotifications({required int page, int limit = Constants.defaultPageLimit});
}

// usecase — class (mock qilish uchun), bitta amal, base class'ni EXTENDS qiladi
class GetNotifications extends UsecaseWithParams<List<NotificationEntity>, GetNotificationsParams> {
  const new(this._repo);

  final NotificationsRepository _repo;

  @override
  ResultFuture<List<NotificationEntity>> call(GetNotificationsParams params) =>
      _repo.getNotifications(page: params.page, limit: params.limit);
}

final class GetNotificationsParams extends Equatable {
  const new({required this.page, this.limit = Constants.defaultPageLimit});

  final int page;
  final int limit;

  @override
  List<Object?> get props => [page, limit];
}
```

Base class'lar (`packages/core/lib/src/usecase/usecase.dart`):
`UsecaseWithParams<T, P>`, `UsecaseWithoutParams<T>`, `UsecaseWithParamsVoid<P>`. Har doim **`extends`**.

`ResultFuture<T>` = `Future<Either<Failure, T>>` (`packages/core/lib/src/utils/typedef.dart`).
`Either` — o'zimizniki (`packages/core/lib/src/either/either.dart`), **dartz yo'q**.

## 3. DataSource — interfeys + `part` impl

```dart
// notifications_remote_data_source.dart
part 'notifications_remote_data_source_impl.dart';

abstract interface class NotificationsRemoteDataSource {
  const new();

  Future<List<NotificationModel>> getNotifications({required int page, int limit = Constants.defaultPageLimit});
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
      final result = await _networkProvider.fetchMethod<List<dynamic>>(
        NotificationsApiPaths.clientNotifications,
        methodType: RMethodTypes.get,
        queryParameters: {'page': page, 'limit': limit},
      );
      final List<NotificationModel> notifications = [];
      if (result.data != null && result.data is List) {
        for (final notification in result.data!) {
          if (notification is Map) {
            notifications.add(NotificationModel.fromMap(Map<String, dynamic>.from(notification)));
          }
        }
      }
      return notifications;
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
}
```

`RMethodTypes`: `head, get, post, put, patch, delete`.
DataSource **exception tashlaydi** (`ServerException.*`), `Failure` qaytarmaydi.

## 4. Model

```dart
class NotificationModel extends NotificationEntity {
  const new({required super.id, required super.title, required super.isRead});

  factory fromMap(Map<String, dynamic> map) => NotificationModel(
    id: '${map['id'] ?? ''}',
    title: map['title'] as String? ?? '',
    isRead: map['isRead'] as bool? ?? false,
  );

  Map<String, dynamic> toMap() => {'id': id, 'title': title, 'isRead': isRead};
}
```

- **`fromMap`/`toMap`** — `fromJson`/`toJson` emas.
- Model entity'ni `extends` qiladi, teskarisi emas.
- **Himoyalangan parsing**: ko'r-ko'rona cast yo'q.

## 5. Repository impl — exception → Failure

```dart
final class NotificationsRepositoryImpl implements NotificationsRepository {
  const new(this._remoteDataSource, this._localDataSource);

  final NotificationsRemoteDataSource _remoteDataSource;
  final NotificationsLocalDataSource _localDataSource;

  @override
  ResultFuture<List<NotificationEntity>> getNotifications({
    required int page,
    int limit = Constants.defaultPageLimit,
  }) async {
    try {
      final result = await _remoteDataSource.getNotifications(page: page, limit: limit);
      return Right(result);
    } on ServerException catch (error) {
      return Left(error.failure);
    } on Exception catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }
}
```

Repository impl datasource'ni oddiy `import` bilan oladi — bu yerda `part`/`part of` **ishlatilmaydi**.

## 6. Tekshiruv

- [ ] endpoint modul-lokal `<Module>ApiPaths` da
- [ ] entity'da `fromMap`/`toMap` yo'q; model'da ikkalasi bor
- [ ] ro'yxat maydonlari himoyalangan parsing bilan
- [ ] datasource `ServerException.*` tashlaydi, repository `Left(Failure)` qaytaradi
- [ ] usecase `extends Usecase*`, bitta amal
- [ ] DI da datasource → repository → usecase tartibi
