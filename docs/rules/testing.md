# testing.md — Testlash Standartlari (Unit & BLoC Testlar)

> **Etalon To'liq Test To'plami:** `modules/notifications/test/notifications_test.dart`
> **Etalon BLoC Test:** `modules/notifications/test/src/presentation/notifications/bloc/notifications_bloc_test.dart`
> **Etalon UseCase Test:** `modules/notifications/test/src/domain/usecases/get_notifications_test.dart`
> **Etalon Repository Test:** `modules/notifications/test/src/data/repository/notifications_repository_impl_test.dart`
> **Qoida:** Javob o'zbekcha, kod inglizcha (`AGENTS.md` §0).

---

## 1. Joylashuv va Tuzilma

Test papkasi `modules/<module>/test/` har doim `modules/<module>/lib/src/` arxitektura qatlamlarini 1-ga-1 takrorlaydi:

```
modules/<module>/test/
├── <module>_test.dart                       # Barcha testlarni jamlovchi bosh fayl (aggregator)
└── src/
    ├── <module>_container_test.dart         # Container va router/DI eksport testi
    ├── data/
    │   ├── datasource/                      # Remote data source testlari
    │   ├── models/                          # Model serialization/deserialization testlari
    │   └── repository/                      # Repository implementatsiya testlari
    ├── di/                                  # DI ro'yxatdan o'tish testlari
    ├── domain/
    │   ├── interactor/                      # Interactor testlari
    │   └── usecases/                        # UseCase testlari
    ├── presentation/
    │   └── <feature>/
    │       └── bloc/                        # BLoC blocTest testlari
    └── router/                              # Router navigatsiya testlari
```

---

## 2. Qat'iy Qoidalar (Non-negotiables)

1. **Mocktail Uchun Klass Deklaratsiyasi:** Mock qilinadigan UseCase yoki Repository klasslari `final class` emas, oddiy `class` bo'lishi shart (Dart 3 da `final class` ni boshqa kutubxona `implements` qila olmaydi).
2. **Fallback Value:** Agar testda `any()` ishlatilsa, parametr turi uchun `setUpAll` ichida `registerFallbackValue(...)` ro'yxatdan o'tkazilishi shart.
3. **BLoC Test Tuzilishi:** BLoC testida `blocTest` ishlatiladi. `build`, `act`, `expect`, `verify` tartibi buzilmasligi kerak.
4. **Tezkor Test Ijrosi:** Hech qachon uzoq kutadigan umumiy buyruqlar emas, faqat `./scripts/test_module.sh <name>` yoki bevosita modul aggregator fayli yurgaziladi.
5. **APK/iOS Build Qat'iyan Taqiq:** Testlash yoki verifikatsiyada hech qachon build yurgazilmaydi (`AGENTS.md` 8-qoida).

---

## 3. Standart Kod Skeletlari va Namunalar

### A. Aggregator Test Fayli (`modules/<module>/test/<module>_test.dart`)

```dart
import 'package:flutter_test/flutter_test.dart';

import 'src/data/datasource/notifications_remote_data_source_test.dart' as remote_data_source_test;
import 'src/data/models/notification_model_test.dart' as model_test;
import 'src/data/repository/notifications_repository_impl_test.dart' as repository_test;
import 'src/di/notifications_injection_test.dart' as injection_test;
import 'src/domain/interactor/get_unread_notifications_count_interactor_test.dart' as interactor_test;
import 'src/domain/usecases/get_notifications_test.dart' as usecase_test;
import 'src/notifications_container_test.dart' as container_test;
import 'src/presentation/notifications/bloc/notifications_bloc_test.dart' as bloc_test;
import 'src/presentation/notifications_filter_sheet/args/notifications_filter_args_test.dart' as filter_args_test;
import 'src/router/notifications_router_test.dart' as router_test;

void main() {
  group('Notifications Module Tests', () {
    container_test.main();
    injection_test.main();
    router_test.main();
    remote_data_source_test.main();
    model_test.main();
    repository_test.main();
    usecase_test.main();
    interactor_test.main();
    bloc_test.main();
    filter_args_test.main();
  });
}
```

---

### B. BLoC Testlash (`blocTest`)

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetNotifications extends Mock implements GetNotifications {}

class _MockMarkNotificationAsRead extends Mock implements MarkNotificationAsRead {}

class _MockClearAllNotifications extends Mock implements ClearAllNotifications {}

void main() {
  setUpAll(() {
    registerFallbackValue(const GetNotificationsParams(page: 1));
  });

  late NotificationsBloc bloc;
  late _MockGetNotifications mockGetNotifications;
  late _MockMarkNotificationAsRead mockMarkNotificationAsRead;
  late _MockClearAllNotifications mockClearAllNotifications;

  setUp(() {
    mockGetNotifications = _MockGetNotifications();
    mockMarkNotificationAsRead = _MockMarkNotificationAsRead();
    mockClearAllNotifications = _MockClearAllNotifications();
    // BLoC dependency'lari doim POZITSION beriladi (named emas) — etalon ctor bilan bir xil tartibda.
    bloc = NotificationsBloc(mockGetNotifications, mockMarkNotificationAsRead, mockClearAllNotifications);
  });

  tearDown(() => bloc.close());

  blocTest<NotificationsBloc, NotificationsState>(
    'emits [NotificationsLoadingState, NotificationsLoadedState] on GetNotificationsEvent success',
    build: () {
      when(() => mockGetNotifications(any()))
          .thenAnswer((_) async => const Right(tNotifications));
      return bloc;
    },
    act: (bloc) => bloc.add(const GetNotificationsEvent()),
    expect: () => [
      const NotificationsLoadingState(),
      const NotificationsLoadedState(notifications: tNotifications),
    ],
    verify: (_) {
      verify(
        () => mockGetNotifications(
          any(that: isA<GetNotificationsParams>().having((p) => p.page, 'page', 1)),
        ),
      ).called(1);
    },
  );
}
```

---

### C. UseCase va Repository Testlash

```dart
test('should call repository.getNotifications with params and return data', () async {
  when(() => mockRepository.getNotifications(page: 1, limit: 10))
      .thenAnswer((_) async => const Right(tNotifications));

  final result = await usecase(const GetNotificationsParams(page: 1, limit: 10));

  expect(result, const Right(tNotifications));
  verify(() => mockRepository.getNotifications(page: 1, limit: 10)).called(1);
  verifyNoMoreInteractions(mockRepository);
});
```

---

## 4. Eng Ko'p Qilinadigan Xatolar (Anti-patterns)

### ❌ Anti-pattern 1: Mock qilinadigan klassni `final class` deb e'lon qilish
```dart
// ❌ XATO: Mocktail implements qila olmaydi
final class GetNotifications { ... }

// ✅ TO'G'RI:
class GetNotifications { ... }
```

### ❌ Anti-pattern 2: `any()` ishlatib, `registerFallbackValue` ni unutish
```dart
// ❌ XATO: Bad state: A test tried to use `any` with a custom type...
when(() => mockGetNotifications(any())).thenAnswer(...);

// ✅ TO'G'RI:
setUpAll(() {
  registerFallbackValue(const GetNotificationsParams(page: 1));
});
```

### ❌ Anti-pattern 3: Test faylini tartibsiz nomlash yoki noto'g'ri joylashtirish
```dart
// ❌ XATO: test/my_test.dart (qatlam noma'lum)
// ✅ TO'G'RI: test/src/domain/usecases/get_notifications_test.dart
```

---

## 5. Tekshiruv Ro'yxati (Checklist)

- [ ] Test fayllari va papkalari `lib/src/` qatlamlarini 1-ga-1 takrorlaydi.
- [ ] Mocktail uchun mock qilinadigan klasslar `final class` emas, oddiy `class`.
- [ ] `any()` ishlatilgan barcha custom turlar `setUpAll` ichida `registerFallbackValue` bilan ro'yxatdan o'tgan.
- [ ] Har bir event va usecase uchun success va failure ssenariylari qamrab olingan.
- [ ] `./scripts/test_module.sh <name>` orqali testlar yashil (`All tests passed!`).
- [ ] `./scripts/verify.sh` muvaffaqiyatli o'tgan.
