# bloc.md — BLoC / Event / State

> Etalon: `modules/auth/lib/src/presentation/login/bloc/login_bloc.dart`
> Ko'p-operatsiyali sealed state: `modules/notifications/lib/src/presentation/notifications/bloc/notifications_state.dart`
> Javob o'zbekcha, kod inglizcha (`AGENTS.md` §0).

## 1. Skelet

```dart
part 'notification_list_event.dart';
part 'notification_list_state.dart';

final class NotificationListBloc extends Bloc<NotificationListEvent, NotificationListState> {
  new(this._getNotifications, this._deleteNotification) : super(const NotificationListInitialState()) {
    on<GetNotificationsEvent>(_getNotificationsHandler, transformer: droppable());
    on<DeleteNotificationEvent>(_deleteNotificationHandler, transformer: throttle());
  }

  final GetNotifications _getNotifications;
  final DeleteNotification _deleteNotification;
}
```

- `final class`, konstruktor **`new(this._x, this._y)`** — positional, private initializing formal.
- `part` bilan event/state. Alohida `import` **yo'q**.
- Dependency'lar: **private `final`**. Public usecase field — taqiq.
- `droppable`/`throttle`/`debounce`/`sequential` `package:core/core.dart` orqali keladi; `bloc_concurrency` ni to'g'ridan-to'g'ri import qilma.

## 2. Bloc'da mutable state YO'Q

Bloc — stateless dvigatel: event keladi → usecase chaqiradi → state emit qiladi. Yagona fieldlari — `final` private dependency.

```dart
// ❌ hech qachon
List<Item> _items = [];
int _page = 1;
List<Item> get items => _items;   // widget bunga qarab rebuild bo'lmaydi
```

Ma'lumot mixin'da yashaydi → `docs/rules/page-mixin.md`.

## 3. Event

```dart
sealed class NotificationListEvent extends Equatable {
  const new();
}

final class GetNotificationsEvent extends NotificationListEvent {
  const new({required this.page});

  final int page;

  @override
  List<Object?> get props => [page];
}
```

Nom: `<Verb><Noun>Event` — `GetXxxEvent`, `UpdateXxxEvent`, `DeleteXxxEvent`, `CreateXxxEvent`.

## 4. State — ko'p va kichik, sealed oilalarga bo'lingan

Bitta katta `copyWith` state **emas**. Har operatsiya o'z `sealed` oilasini oladi, `buildWhen` shu oilani nomlaydi.

```dart
sealed class NotificationsState extends Equatable { const new(); }
final class NotificationsInitialState extends NotificationsState { const new(); }

sealed class NotificationListState extends NotificationsState { const new(); }         // ro'yxatni yuklash
final class NotificationsLoadingState extends NotificationListState { const new(); }
final class NotificationsLoadedState extends NotificationListState { ... }
final class NotificationsFailureState extends NotificationListState { ... }

sealed class NotificationActionState extends NotificationsState { const new(); }       // mustaqil operatsiya (mark as read/delete)
final class NotificationActionLoadingState extends NotificationActionState { ... }
final class NotificationMarkReadSuccessState extends NotificationActionState { ... }
final class NotificationActionFailureState extends NotificationActionState { ... }
```

State faqat **shu emissiyaning** payloadini olib yuradi — butun ekran snapshot'ini emas.
Har konkret state `props` ni override qiladi (bo'sh marker state `[]` ni meros oladi).

## 5. Handler

```dart
Future<void> _getNotificationsHandler(GetNotificationsEvent event, Emitter<NotificationsState> emit) async {
  if (state is NotificationsLoadingState) return;          // loading guard
  emit(const NotificationsLoadingState());

  final result = await _getNotifications(GetNotificationsParams(page: event.page));
  result.fold(
    (failure) => emit(NotificationsFailureState(message: failure.message)),
    (notifications) => emit(NotificationsLoadedState(notifications: notifications)),
  );
}
```

- Nom: **`_<verb><target>Handler`**. `_onXxx` — taqiq.
- Handler nomi event nomining aynan nusxasi bo'lishi shart emas, lekin **o'sha obyekt va o'sha amalni** nomlashi shart.
- Loading emit qiladigan har handler tepasida guard.
- `result.fold(failure, success)` — `Either` `packages/core/lib/src/either/either.dart` da, dartz emas.

## 6. Transformer tanlash

| Event turi | Transformer | Misol |
|---|---|---|
| yozish (POST/PATCH/PUT/DELETE, login, submit) | `throttle()` | `LoginSubmitEvent`, `MarkNotificationAsReadEvent` |
| o'qish (GET, list, refresh) | `droppable()` | `GetNotificationsEvent`, `HomeLoadEvent` |
| qidiruv / filtr (klaviatura) | `debounce(duration: ..., isBlocClosed: () => isClosed)` | `SearchEvent` (300ms) |
| tartib muhim juftlik | `sequential()` | `QueueEvent` |
| lokal tanlov (sync) | baribir aniq yoz | `SelectFilterEvent` |

Yangi kodda har doim transformer yoz.

## 7. Paginatsiya

Ikki event: `Get<X>ListEvent` (1-sahifa, to'liq loading) va `GetPaginated<X>ListEvent` (n+1, alohida
`XxxPaginationLoadingState` — to'liq ekran spinneri yo'q). Ikkalasi ham `droppable()`.
Sahifa tugaganini `state.list.length < Constants.defaultPageLimit` bilan aniqlanadi — serverdan `hasMore` kutilmaydi.
Hisoblagich va bayroq mixin'da: `docs/rules/page-mixin.md` §4.

## 8. Tekshiruv

- [ ] `final class`, `new(this._x)` konstruktor
- [ ] mutable field yo'q, dependency private final
- [ ] `part` bilan event/state
- [ ] har `on<Event>()` da `transformer:`
- [ ] handler nomi `_<verb><target>Handler`
- [ ] Loading emit qiladigan handler'da guard
- [ ] state'lar kichik, sealed subfamily'ga bo'lingan
