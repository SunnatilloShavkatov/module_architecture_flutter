# bloc.md — BLoC, Event, State va Transformerlar

> **Etalon BLoC:** `modules/notifications/lib/src/presentation/notifications/bloc/notifications_bloc.dart`
> **Etalon Sealed State:** `modules/notifications/lib/src/presentation/notifications/bloc/notifications_state.dart`
> **Ko'p-operatsiyali State:** `NotificationListState` va `NotificationActionState`
> **Qoida:** Javob o'zbekcha, kod inglizcha (`AGENTS.md` §0).

---

## 1. Joylashuv va Tuzilma

BLoC — holat dvigateli (stateless engine). Unda hech qanday UI kodi, mutable o'zgaruvchi yoki ro'yxat keshlanmaydi.

```
modules/<module>/lib/src/presentation/<feature>/bloc/
├── <feature>_bloc.dart       # Asosiy BLoC klassi (barcha handlerlar)
├── <feature>_event.dart      # part of '<feature>_bloc.dart'
└── <feature>_state.dart      # part of '<feature>_bloc.dart' (sealed subfamilies)
```

- BLoC klassi: `final class <Feature>Bloc extends Bloc<...>`
- Konstruktor: **`new(this._getNotifications, this._deleteNotification)`** — positional, private initializing formal.
- Dependency'lar: **private `final`**. Public usecase field — taqiq.
- `part` bilan event/state ulanadi. Event/state alohida faylda `import` qilinmaydi.
- `droppable`/`throttle`/`debounce`/`sequential` faqat `package:core/core.dart` orqali keladi; `bloc_concurrency` ni to'g'ridan-to'g'ri import qilish taqiqlanadi.
- `Either` natijasi `packages/core/lib/src/either/either.dart` orqali keladi (`dartz` taqiqlangan).

---

## 2. BLoC da Mutable State YO'Q (Stateless Engine)

BLoC — faqat kiruvchi eventni qabul qilib, tegishli usecase'ni chaqirib, natijani state sifatida emit qiluvchi stateless dvigateldir.

```dart
// ❌ Qat'iyan taqiqlanadi:
List<NotificationEntity> _notifications = [];
int _page = 1;
List<NotificationEntity> get notifications => _notifications; // Widget bunga qarab rebuild bo'lmaydi!
```

> **Asosiy qoida:** Barcha ma'lumotlar (`_items`, `_page`, `_hasMore`, `_isLoading`) sahifaning **Mixin**'ida saqlanadi va yashaydi. BLoC faqat shu emissiyaning payload'ini uzatadi. Batafsil: `docs/rules/page-mixin.md`.

---

## 3. Event Standartlari

Nom: `<Verb><Noun>Event` — `GetNotificationsEvent`, `GetPaginatedNotificationsEvent`, `MarkAsReadNotificationEvent`, `DeleteNotificationEvent`.

```dart
part of 'notifications_bloc.dart';

sealed class NotificationsEvent extends Equatable {
  const new();
}

final class GetNotificationsEvent extends NotificationsEvent {
  const new({this.page = 1});

  final int page;

  @override
  List<Object?> get props => [page];
}

final class GetPaginatedNotificationsEvent extends NotificationsEvent {
  const new({required this.page});

  final int page;

  @override
  List<Object?> get props => [page];
}
```

---

## 4. State — Ko'p va Kichik, Sealed Subfamily'larga Bo'lingan

Bitta monolithic `copyWith` state klassi **taqiqlangan**. Har bir mustaqil operatsiya o'z `sealed` oilasiga ega bo'ladi. Sahifadagi `buildWhen` yoki `listenWhen` aynan shu sub-family turi bo'yicha filtrlaydi.

```dart
part of 'notifications_bloc.dart';

sealed class NotificationsState extends Equatable {
  const new();
}

final class NotificationsInitialState extends NotificationsState {
  const new();

  @override
  List<Object?> get props => [];
}

// ---------------------------------------------------------------------------
// 1-oila: Ro'yxatni yuklash (List Subfamily)
// ---------------------------------------------------------------------------
sealed class NotificationListState extends NotificationsState {
  const new();
}

final class NotificationsLoadingState extends NotificationListState {
  const new();

  @override
  List<Object?> get props => [];
}

final class NotificationsPaginationLoadingState extends NotificationListState {
  const new();

  @override
  List<Object?> get props => [];
}

final class NotificationsLoadedState extends NotificationListState {
  const new({required this.notifications});

  final List<NotificationEntity> notifications;

  @override
  List<Object?> get props => [notifications];
}

final class NotificationsFailureState extends NotificationListState {
  const new({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

// ---------------------------------------------------------------------------
// 2-oila: Aksiya/Mutatsiya (Action Subfamily - mustaqil operatsiya)
// ---------------------------------------------------------------------------
sealed class NotificationActionState extends NotificationsState {
  const new();
}

final class NotificationActionLoadingState extends NotificationActionState {
  const new();

  @override
  List<Object?> get props => [];
}

final class NotificationActionSuccessState extends NotificationActionState {
  const new({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

final class NotificationActionFailureState extends NotificationActionState {
  const new({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
```

State faqat **shu emissiyaning** payload'ini olib yuradi — butun ekran snapshot'ini emas.

---

## 5. Handler Qoidalari va Loading Guard

```dart
Future<void> _getNotificationsHandler(
  GetNotificationsEvent event,
  Emitter<NotificationsState> emit,
) async {
  if (state is NotificationsLoadingState) return; // Loading guard
  emit(const NotificationsLoadingState());

  final result = await _getNotifications(GetNotificationsParams(page: event.page));
  result.fold(
    (failure) => emit(NotificationsFailureState(message: failure.message)),
    (notifications) => emit(NotificationsLoadedState(notifications: notifications)),
  );
}
```

- **Nom:** Qat'iy ravishda **`_<verb><Target>Handler`**. `_onXxx` yoki `_onGetNotifications` taqiqlanadi.
- Handler nomi event bilan mantiqiy bog'liq bo'lishi shart:
  - `GetNotificationsEvent` → `_getNotificationsHandler` ✅
  - `DeleteNotificationEvent` → `_deleteNotificationHandler` ✅
  - `CheckUserPressedEvent` → `_checkUserHandler` ✅
- **Loading Guard:** Loading emit qiluvchi har bir handler boshida guard qo'yiladi (`if (state is ...LoadingState) return;`).
- `result.fold(...)`: Muvaffaqiyatsizlik birinchi, muvaffaqiyat ikkinchi argument bo'ladi.

---

## 6. Transformer Tanlash Jadvali

| Event turi | Transformer | Maqsadi va Misol |
|---|---|---|
| **Yozish** (POST, PATCH, PUT, DELETE, submit) | `throttle()` | Duplikat bosishlarni bloklaydi (`DeleteNotificationEvent`, `SubmitFormEvent`) |
| **O'qish** (GET, list, refresh) | `droppable()` | Oldingi so'rov bajarilayotganda yangisini tashlab yuboradi (`GetNotificationsEvent`) |
| **Qidiruv / Filtr** (klaviatura input) | `debounce(...)` | Foydalanuvchi yozib bo'lishini kutadi (`SearchNotificationsEvent`, 300ms) |
| **Tartib muhim juftlik** | `sequential()` | So'rovlarni ketma-ket navbat bilan bajaradi (`PlayAudioEvent`, `SyncQueueEvent`) |
| **Lokal sinxron tanlov** | Har doim aniq yoziladi | Transformer ko'rsatilishi shart |

> **Eslatma:** Har bir `on<Event>` chaqiruvida `transformer:` parametri bo'lishi shart. Transformer ko'rsatilmagan event ro'yxatdan o'tkazish taqiqlanadi.

---

## 7. Paginatsiya Arxitekturasi

BLoC da paginatsiya ikki xil event orqali tashkil qilinadi:
1. `GetNotificationsEvent` — 1-sahifa, butun ro'yxatni yangilash yoki refresh qilish. `NotificationsLoadingState` emit qiladi (sahifada to'liq loader ko'rinadi).
2. `GetPaginatedNotificationsEvent` — n+1 sahifa, pastki paginatsiya. `NotificationsPaginationLoadingState` emit qiladi (faqat ro'yxat ostida kichik spinner ko'rinadi).

Ikkalasi ham `droppable()` transformeriga ega.

**Ro'yxat tugaganini aniqlash:**
Serverdan alohida `hasMore` kutib o'tirilmaydi:
```dart
final hasMore = state.notifications.length >= Constants.defaultPageLimit;
```
Agar kelgan elementlar soni sahifa limitidan kam bo'lsa (`length < Constants.defaultPageLimit`), demak ro'yxat tugagan. Bu mantiq va elementlarni to'plash Mixin'da bajariladi (`docs/rules/page-mixin.md`).

---

## 8. BLoC Tekshiruv Ro'yxati (Verification Checklist)

- [ ] `final class <Name>Bloc extends Bloc<...>`
- [ ] Konstruktor `new(this._dep1, this._dep2)` ko'rinishida yozilgan
- [ ] BLoC da mutable fieldlar yo'q (`List _items = []` yo'q), dependency'lar private `final`
- [ ] `part '<feature>_event.dart';` va `part '<feature>_state.dart';` orqali ulangan
- [ ] Har bir `on<Event>` da mos `transformer:` bor
- [ ] Handler nomi `_<verb><Target>Handler` shaklida
- [ ] Loading emit qiluvchi handler'da guard tekshiruvi bor
- [ ] State'lar alohida `sealed` subfamily'larga ajratilgan
- [ ] `core` ning `Either` va transformerlari ishlatilgan
