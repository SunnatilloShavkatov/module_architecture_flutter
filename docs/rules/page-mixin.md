# page-mixin.md — Page, Mixin, state egaligi

> Etalon: `modules/notifications/lib/src/presentation/notifications/` (page + mixin + bloc + state)
> Paginatsiya: `modules/notifications/lib/src/presentation/notifications/mixin/notifications_mixin.dart`

**Agent eng ko'p shu yerda xato qiladi.** Bloc — stateless, **mixin — ma'lumot egasi**.

## 1. Ma'lumot oqimi (bir yo'nalish, 4 qadam)

```
mixin metodi → bloc.add(Event) → handler → emit(kichik State)
   → BlocListener(_handleStates) → mixin fieldini o'zgartiradi → BlocBuilder(buildWhen) qayta chizadi
```

Qisqa yo'l yo'q. `setState` bilan «tuzatish» — belgi, ma'lumot noto'g'ri joyda turibdi.

## 2. Papka

```
presentation/<feature>/
  <feature>_page.dart          # StatefulWidget, part 'mixin/<feature>_mixin.dart';
  bloc/<feature>_bloc.dart | _event.dart | _state.dart
  mixin/<feature>_mixin.dart   # part of '../<feature>_page.dart';
  widgets/*.dart               # StatelessWidget, faqat konstruktor ma'lumoti
  args/<feature>_args.dart     # route input olsa
```

## 3. Page

```dart
part 'mixin/notifications_mixin.dart';

class NotificationsPage extends StatefulWidget {
  const new({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with NotificationsMixin {
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    bloc.add(const GetNotificationsEvent());
  }

  @override
  void dispose() {
    _disposeMixin();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocListener<NotificationsBloc, NotificationsState>(
    listener: _handleStates,
    child: Scaffold(...),
  );
}
```

- Page — oddiy `class` (`final class` emas), `StatefulWidget`.
- **Boshlang'ich event page'ning `initState()` ida** yuboriladi, mixin'da emas.
- `dispose()` mixin'ning `_disposeMixin()` ini chaqiradi.

## 4. Mixin — barcha o'zgaruvchan ma'lumot shu yerda

```dart
part of '../notifications_page.dart';

mixin NotificationsMixin on State<NotificationsPage> {
  final ScrollController _scrollController = ScrollController();
  List<NotificationEntity> _notifications = [];
  int _page = 1;
  bool _isPaginating = false;

  void _handleStates(BuildContext context, NotificationsState state) {
    if (state is NotificationsLoadedState) {
      _notifications = state.notifications;
      if (state.notifications.length < Constants.defaultPageLimit) {
        _isPaginating = true;
      } else {
        _page++;
      }
    } else if (state is NotificationMarkReadSuccessState) {
      _notifications = _notifications.map((n) => n.id == state.id ? n.copyWith(isRead: true) : n).toList();
      showSuccessMessage(context, message: 'Notification marked as read');
    } else if (state is NotificationsFailureState) {
      showErrorMessage(context, message: state.message);
    }
  }

  void _disposeMixin() {
    _scrollController.dispose();
  }

  NotificationsBloc get bloc => context.read<NotificationsBloc>();
}
```

- Mixin **doim** `part of '../<feature>_page.dart'` — mustaqil kutubxona emas.
- `_handleStates` — bitta emissiyaga bitta marta ishlaydi: snackbar, navigatsiya, sheet shu yerda.
- **Hosila qiymat — getter**, qo'lda sinxronlanadigan ikkinchi field emas.
- Controller / focus / timer / subscription — mixin'da yaratiladi, `_disposeMixin()` da tozalanadi.

## 4.1 Paginatsiya — to'liq shablon

Etalon: `modules/notifications/lib/src/presentation/notifications/mixin/notifications_mixin.dart`.

```dart
final ScrollController _scrollController = ScrollController();
List<NotificationEntity> _notifications = [];
int _page = 1;
bool _isPaginating = false;          // true = ro'yxat tugadi, boshqa so'ramaymiz

void _scrollListener() {
  if (_isPaginating || _notifications.isEmpty) return;
  if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
      !_scrollController.position.outOfRange) {
    bloc.add(GetPaginatedNotificationsEvent(page: _page));
  }
}

// _handleStates ichida:
if (state is NotificationsPaginationLoadedState) {
  _notifications = {..._notifications, ...state.notifications}.toList();     // set-union = dublikat yo'q
  if (state.notifications.length < Constants.defaultPageLimit) {
    _isPaginating = true;                                                    // qisqa sahifa = oxirgi sahifa
  } else {
    _page++;
  }
}
```

Uchinchi tomon paginatsiya paketi ishlatilmaydi — shablon shu.

## 5. Page'da builder'lar

```dart
BlocListener<NotificationsBloc, NotificationsState>(
  listener: _handleStates,
  child: BlocBuilder<NotificationsBloc, NotificationsState>(
    buildWhen: (_, curr) => curr is NotificationListState,       // faqat ro'yxat holati
    builder: (context, state) => ...,
  ),
)
```

`buildWhen` **har doim** bo'ladi va sealed subfamily'ni nomlaydi. Builder'ning `state` argumenti odatda
ishlatilmaydi — daraxt mixin fieldlarini o'qiydi. Bu to'g'ri: emissiya — **trigger**, mixin — **haqiqat manbai**.

## 6. `setState` — qachon kerak

Umumiy qoida yo'q, field **qayerda o'qilishiga** bog'liq:

| Holat | Qaror |
|---|---|
| Field `BlocBuilder`/`BlocConsumer.builder` ichida o'qiladi va `buildWhen` kelayotgan state'ni o'tkazadi | `setState` **kerak emas** — builder shu emissiyadan qayta ishlaydi |
| Field bloc bilan chizilmaydigan widget'da o'qiladi | `setState` **kerak** |
| O'zgarish bloc emissiyasidan emas: `Timer` tiki, `StreamSubscription`, oddiy toggle | `setState` **kerak** |
| Bitta metodda ikkala holat bor (lokal validatsiya + bloc) | har shox uchun alohida qaror |

`await` dan keyin `context`/`setState` ga tegishdan oldin: `if (!mounted) return;`.

## 7. Widget fayllari

`StatelessWidget`, ma'lumot faqat konstruktor orqali. Widget ichida repository/datasource/DI chaqirig'i — taqiq.
Callback'lar (`onTap`) parametr sifatida keladi.

## 8. Tekshiruv

- [ ] mixin `part of '../<feature>_page.dart'`
- [ ] boshlang'ich event page'ning `initState()` ida
- [ ] `dispose()` → `_disposeMixin()`
- [ ] barcha o'zgaruvchan ma'lumot mixin'da, `_handleStates` da o'zgaradi
- [ ] hosila qiymat — getter
- [ ] har `BlocBuilder` da `buildWhen` + sealed subfamily
- [ ] `setState` faqat §6 bo'yicha
- [ ] `await` dan keyin `mounted` tekshiruvi
