# module.md — Modul, DI, modullararo aloqa

> Etalon: `modules/notifications/lib/src/notifications_container.dart`, `modules/notifications/lib/src/di/notifications_injection.dart`

## 1. Modul tuzilishi

```
modules/<module>/
  lib/
    <module>.dart                 # barrel: container + public tashqi narsalar
    src/
      domain/ data/ presentation/ di/ router/
      <module>_container.dart
  test/<module>_test.dart         # barcha test fayllarni chaqiradi
  pubspec.yaml
```

`pubspec.yaml` da faqat `packages/*` va pub paketlar. **Boshqa modul — hech qachon.**

## 2. Container — appga yagona kirish nuqtasi

```dart
final class NotificationsContainer implements ModuleContainer {
  const new();

  @override
  AppRouter<RouteBase> get router => const NotificationsRouter();

  @override
  Injection get injection => const NotificationsInjection();
}
```

Ulash: `packages/merge_dependencies/lib/merge_dependencies.dart` dagi `MergeDependencies._allContainer` ga
`const <Module>Container()` qo'shiladi + shu paketning `pubspec.yaml` iga modul yoziladi. **Boshqa hech nima**
modulning router/injection/page/bloc'ini nomlamaydi.

Interfeyslar (`packages/core/lib/src/core_abstractions/`):

```dart
abstract interface class ModuleContainer { const new(); AppRouter<Object>? get router => null; Injection? get injection => null; }
abstract interface class AppRouter<T>    { const new(); List<T> getRouters(Injector di); }
abstract interface class Injection       { const new(); FutureOr<void> registerDependencies({required Injector di}); }
```

## 3. DI

```dart
final class NotificationsInjection implements Injection {
  const new();

  @override
  void registerDependencies({required Injector di}) {
    di
      /// data sources
      ..registerLazySingleton<NotificationsRemoteDataSource>(() => NotificationsRemoteDataSourceImpl(di.get()))
      /// repositories
      ..registerLazySingleton<NotificationsRepository>(() => NotificationsRepositoryImpl(di.get(), di.get()))
      /// usecases
      ..registerLazySingleton(() => GetNotifications(di.get()))
      /// interactors
      ..registerLazySingleton<ModuleInteractor<int, NoParams>>(
        () => GetUnreadNotificationsCountInteractor(di.get()),
        instanceName: InstanceNameKeys.getUnreadNotificationsCountInteractor,
      )
      /// widget factories
      ..registerLazySingleton<WidgetFactory<NotificationItemArgs>>(
        NotificationItemFactory.new,
        instanceName: InstanceNameKeys.notificationItemFactory,
      )
      /// blocs
      ..registerFactory(() => NotificationsBloc(di.get(), di.get(), di.get()));
  }
}
```

| Nima | Registratsiya |
|---|---|
| datasource, repository, usecase, `ModuleInteractor`, `PageFactory`, `WidgetFactory` | `registerLazySingleton` |
| bloc | `registerFactory` (har ekranga yangi nusxa) |

Tartib: datasource → repository → usecase → interactor → factory → bloc.
`/// data sources` kabi guruh yorliqlari — faqat shu DI fayllarida ruxsat.

## 4. Modullararo aloqa — 3 ta yo'l

Boshqa modulning usecase'ini import qilma. Uchta abstraksiyadan birini tanla:

### 4.1 `ModuleInteractor<T, P>` — biznes-amal

```dart
abstract interface class ModuleInteractor<T, P> {
  const new();
  Future<Either<Failure, T>> call(P params);
}
```

Egasi implementatsiya qiladi va **nomlangan** registratsiya qiladi (kalit `InstanceNameKeys` ga qo'shiladi):

```dart
..registerLazySingleton<ModuleInteractor<int, NoParams>>(
  () => GetUnreadNotificationsCountInteractor(di.get()),
  instanceName: InstanceNameKeys.getUnreadNotificationsCountInteractor,
)
```

Iste'molchi nom bo'yicha oladi, egasi modulni import qilmaydi:

```dart
final ModuleInteractor<int, NoParams> _getUnreadCount;
// DI: di.get(instanceName: InstanceNameKeys.getUnreadNotificationsCountInteractor)
```

### 4.2 `PageFactory` — butun ekran (argumentsiz, DI dan quriladi)

```dart
abstract interface class PageFactory {
  const new();
  Widget create(Injector di);
}

final class HomePageFactory implements PageFactory {
  const new();

  @override
  Widget create(Injector di) => BlocProvider<HomeBloc>(
    create: (_) => di.get<HomeBloc>()..add(const HomeLoadEvent()),
    child: const HomePage(),
  );
}

// iste'molchi router:
builder: (_, _) => di.get<PageFactory>(instanceName: InstanceNameKeys.homeFactory).create(di)
```

### 4.3 `WidgetFactory<T>` — chaqiruvchi ma'lumotini oladigan widget

```dart
abstract interface class WidgetFactory<T> {
  const new();
  Widget create(T args);
}

final class NotificationItemFactory implements WidgetFactory<NotificationItemArgs> {
  const new();

  @override
  Widget create(NotificationItemArgs args) => NotificationItem(args: args);
}

// iste'molchi:
late final WidgetFactory<NotificationItemArgs> _notificationItemFactory = di.get(
  instanceName: InstanceNameKeys.notificationItemFactory,
);
// build ichida:
_notificationItemFactory.create(NotificationItemArgs(...))
```

Args turi ikkala modulga ko'rinishi kerak → `packages/core/lib/src/entities/`.

### 4.4 Umumiy entity

Modul chegarasini kesib o'tadigan entity `packages/core/lib/src/entities/` ga ko'chadi. **Model** (`fromMap`/`toMap`) egasi modulning data qatlamida qoladi va core entity'ni `extends` qiladi.

## 5. Widget'siz koddan navigatsiya

Interceptor, background handler, servis'da `BuildContext` yo'q → `AppNavigationService`.
DI dan ol. Saqlangan `BuildContext` yoki o'zingning `GlobalKey` ing — taqiq.

## 6. Paket izolyatsiyasi

`core`, `components`, `navigation`, `platform_methods` bir-biriga va `modules/*` ga bog'lanmaydi.
`merge_dependencies` — ataylab qilingan yagona istisno, hamma modulga bog'lanadi.

## 7. Tekshiruv

- [ ] `<Module>Container` bor va `_allContainer` ga qo'shilgan
- [ ] `pubspec.yaml` da boshqa modul yo'q
- [ ] DI tartibi va turi to'g'ri (bloc — `registerFactory`)
- [ ] modullararo narsa factory/interactor orqali, `InstanceNameKeys` da kalit bor
- [ ] umumiy entity `packages/core/lib/src/entities/` da, model modulda qolgan
