# testing.md — Testlash Standartlari (Unit & Bloc Testlar)

> Etalon To'liq Test To'plami: `modules/notifications/test/notifications_test.dart`
> BLoC Test: `modules/notifications/test/src/presentation/notifications/bloc/notifications_bloc_test.dart`
> UseCase Test: `modules/notifications/test/src/domain/usecases/get_notifications_test.dart`
> Repository Test: `modules/notifications/test/src/data/repository/notifications_repository_impl_test.dart`
> Javob o'zbekcha, kod inglizcha (`AGENTS.md` §0).

## 1. Test papka tuzilishi

Test papkasi `modules/<module>/test/` har doim `modules/<module>/lib/` arxitektura qatlamlarini 1-ga-1 takrorlaydi:

```
modules/notifications/test/
├── notifications_test.dart                       # Barcha testlarni jamlovchi bosh fayl (aggregator)
└── src/
    ├── container/
    ├── data/
    │   ├── datasource/
    │   ├── models/
    │   └── repository/
    ├── di/
    ├── domain/
    │   ├── interactor/
    │   └── usecases/
    ├── presentation/
    │   └── notifications/
    │       └── bloc/
    └── router/
```

## 2. Mocktail qoidalari

1. Mock qilinadigan usecase yoki servis klasslari `final class` emas, oddiy `class` bo'lishi shart (Dart 3 da `final class` ni boshqa kutubxona `implements` qila olmaydi).
2. Agar testda `any()` ishlatilsa, parametr turi uchun `setUpAll` ichida `registerFallbackValue` ro'yxatdan o'tkazilishi shart:

```dart
class _MockGetNotifications extends Mock implements GetNotifications {}

void main() {
  setUpAll(() {
    registerFallbackValue(const GetNotificationsParams(page: 1));
  });

  late NotificationsBloc bloc;
  late _MockGetNotifications mockGetNotifications;
  ...
}
```

## 3. BLoC testlash (`blocTest`)

```dart
blocTest<NotificationsBloc, NotificationsState>(
  'emits [NotificationsLoadingState, NotificationsLoadedState] on GetNotificationsEvent success',
  build: () {
    when(() => mockGetNotifications(any())).thenAnswer((_) async => Right(tNotifications));
    return notificationsBloc;
  },
  act: (bloc) => bloc.add(const GetNotificationsEvent()),
  expect: () => [
    const NotificationsLoadingState(),
    NotificationsLoadedState(notifications: tNotifications),
  ],
  verify: (_) => verify(() => mockGetNotifications(const GetNotificationsParams(page: 1))).called(1),
);
```

## 4. UseCase va Repo testlash

`Either` muvaffaqiyat holatini tekshirish:
```dart
test('calls repository.getNotifications with params and returns result', () async {
  when(() => mockRepository.getNotifications(page: 1, limit: 10))
      .thenAnswer((_) async => Right(tNotifications));

  final result = await usecase(const GetNotificationsParams(page: 1, limit: 10));

  expect(result, Right(tNotifications));
  verify(() => mockRepository.getNotifications(page: 1, limit: 10)).called(1);
});
```

## 5. Testlarni yurgazish

Modul testlarini bitta buyruq bilan yurgazish:
```bash
flutter test modules/notifications/test/notifications_test.dart
```

Barcha testlarni yurgazish:
```bash
flutter test
```

## 6. Tekshiruv ro'yxati

- [ ] Test fayli va papkasi `lib/src/` qatlamiga mos joylashgan.
- [ ] Mocktail uchun mocklanadigan usecase `final class` emas.
- [ ] `any()` parametrlari uchun `registerFallbackValue` `setUpAll` da berilgan.
- [ ] Har bir event va usecase uchun success va failure ssenariylari yozilgan.
- [ ] Testlar yashil (`All tests passed!`).
