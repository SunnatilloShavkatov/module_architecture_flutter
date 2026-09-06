# CLAUDE.md — Canonical AI Instructions

This file is the single source of truth for architecture rules. Do not follow a module's local
style if it conflicts with the rules below — the rules below are correct, not every existing
module is. `AGENTS.md` only adds output-formatting notes on top of this file.

**This repo is a template.** New projects get started by copying it, then keeping only the modules
they need. Every concrete module/file cited below (`auth`, `profile`, `payments`, `home`,
`notifications`, `main`, `system`, `initial`, `login_bloc.dart`, `profile_bloc.dart`, etc.) is an
**illustration of a pattern from this specific copy of the template** — not a required module, not
proof the pattern only applies there. If a cited file doesn't exist in the copy you're working in,
that's expected, not an error: apply the *pattern* (the naming, the wiring, the decision rule) to
whatever module you're actually in. Never treat "module X isn't here" as a reason to invent a
module X, restore a deleted example, or skip a rule — the rule is the point, the module name is not.

Same applies to the "Verified examples" tables scattered through this file: they document real
files in the template copy this file was written against, to prove the rule reflects working code,
not a guess. Before citing one as a reference in a future project, confirm the file still exists
there — if it doesn't, find (or write) the closest equivalent in that project instead.

## 0. Mandatory Docs Read (agents keep skipping this — stop skipping it)

`docs/` is not optional background reading. Before touching a task in the listed category,
open the file — don't rely on memory of this summary, the doc has edge cases this file omits.

| Task involves                               | Open before coding                                                               |
|---------------------------------------------|----------------------------------------------------------------------------------|
| any new entity                              | `docs/domain_layer/entities.md`                                                  |
| any new repository interface                | `docs/domain_layer/repositories.md`                                              |
| any new usecase                             | `docs/domain_layer/usecases.md`                                                  |
| any new model / `fromMap`/`toMap`           | `docs/data_layer/models.md`                                                      |
| any bloc/event/state/page/mixin             | `docs/presentation_layer/page_bloc_widget_mixin_plan.md`                         |
| any `components`/`core` widget or token use | `docs/presentation_layer/components_core_usage.md`                               |
| picking which module owns a feature         | `docs/architecture/module_selection.md` (map drifts — cross-check `ls modules/`) |
| creating a brand-new module                 | `docs/architecture/new_module_creation.md`                                       |
| unsure where a file goes                    | `docs/architecture/project_map.md`                                               |
| DI/GetIt registration                       | `docs/architecture/dependency_injection.md`                                      |
| general layering doubt                      | `docs/architecture/clean_architecture.md`, `docs/architecture/overview.md`       |

`docs/architecture/solid_standards.md` and `docs/presentation_layer/reference_best_practices.md` are supplementary — read when the task is non-trivial (new module, ambiguous ownership), skip for small mechanical additions.

## 1. Reference Priority (fixes "clone wrong module" problem)

1. **`docs/template_reference.md`** — the copy-paste shape of every file type in this project: constructor syntax, bloc/event/state, mixin, page, widget, args, router, sheet, DI, cross-module factories, plus a symptom→fix table of the mistakes agents actually make. **Open it before writing any file, not after.** It is written against `CLAUDE.md`; each of its sections names the rule it implements. If it ever disagrees with `CLAUDE.md`, `CLAUDE.md` wins — say so instead of following the doc.
2. **`docs/presentation_layer/page_bloc_widget_mixin_plan.md`** — mandatory for any bloc/event/state/page/mixin work. Rules inlined below too, but the doc is authoritative on edge cases.
3. An existing module (`modules/auth`, etc.) — use only for finding local folder-naming (`repo` vs `repository`). Never copy its bloc/state naming if it disagrees with sections 2–3 below — older modules may predate the current convention.

Never invent a fourth pattern. Never mix patterns from different modules in one feature.

## 2. Bloc / Event / State — Strict Naming (non-negotiable)

```
part 'feature_event.dart';
part 'feature_state.dart';

final class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  new(this._useCase) : super(const FeatureInitialState()) {
    on<FeatureLoadEvent>(_getFeatureHandler, transformer: droppable());
  }
  final GetFeature _useCase;

  Future<void> _getFeatureHandler(FeatureLoadEvent event, Emitter<FeatureState> emit) async { ... }
}
```

- bloc class: `final class`
- root `Event`/`State`: `sealed class extends Equatable`
- concrete event/state: `final class`
- handler method: **`_<verb><Target>Handler`** — e.g. `_getProfileHandler`, `_sendOtpHandler`. **NEVER `_onXxx`.**
- event names: **feature-first, then verb** — `<Feature><Verb>Event`: `HomeLoadEvent`, `HomeRefreshEvent`, `LoginSubmitEvent`, `PaymentMethodAddEvent`, `PaymentMethodDeleteEvent`, `NotificationsLoadEvent`. The feature prefix matches the bloc (`HomeBloc` → `Home*Event`), the verb says what happens, `Event` suffix always. Verb-first names (`GetXxxEvent`, `UpdateXxxPressedEvent`) are **wrong** — 8 of the 9 events in this repo are feature-first, and the one exception (`UpdateProfilePressedEvent`) is on the migration list, not the reference.
- state names: `XxxInitialState`, `XxxLoadingState`, `XxxSuccessState`, `XxxFailureState` — this exact four, every bloc in the repo. `XxxLoadedState`/`XxxErrorState` do **not** appear anywhere here; don't introduce them. Multi-flow pages: grouped sealed states — an intermediate `sealed class LoadingState extends XxxState` with `XxxLoadingState`/`XxxUpdatingState` under it, as in `profile_state.dart`; see plan doc §3.4.
- every concrete state overrides `props` even if empty (`=> []`).
- transformer is **required on every `on<Event>()` call that triggers a usecase/network call, no exceptions** — such an event registered without one is a bug, not a style choice. Pick by what the event does, not by feel:
  - **event calls a usecase that maps to POST/PATCH/PUT/DELETE on the backend** (create, update, delete, submit, confirm, pay, send, upload — any write) → **`throttle()`, always.** This is the #1 real-world bug in Dart/backend apps: a double tap (or a slow network making a button feel unresponsive so the user taps again) fires the same write request twice within ~1s. `throttle()` is the fix — non-negotiable for every write-triggering event, not a case-by-case judgment call.
  - event calls a usecase that reads/lists data (GET) → `droppable()` — ignore repeat triggers while one is in flight.
  - typing-driven event that itself calls a usecase (server-side search/filter) → `debounce()`.
  - event whose effect depends on strict ordering versus a previous event of the same type → `sequential()`.
  - **exception — no transformer, ever**: an event that only echoes local UI input back into state with no usecase/network call behind it (e.g. an OTP-digit-typed event, a text-field-changed event just for enabling/disabling a button). Throttling or debouncing these delays what the user sees typing on screen — the opposite of what a transformer is for. Prefer not routing pure keystroke echo through the bloc at all (a local `TextEditingController`/`ValueNotifier` in the mixin is enough, see `otp_login_bloc.dart` — it only has a `SubmitEvent`, no per-digit event); if a bloc event is unavoidable, register it with no `transformer:` argument.
- loading guard at the top of every handler that emits a loading state, in addition to the transformer (belt-and-suspenders against races): `if (state is FeatureLoadingState) return;` before `emit(const FeatureLoadingState())`. Already the majority pattern in this repo (`login_bloc.dart`, `home_bloc.dart`, `profile_bloc.dart`, etc.) — keep it on every new handler, don't drop it.

Verified examples, every bloc in this repo, all correct as of this writing — use these as the reference when unsure, don't re-derive from scratch:

| Bloc                        | Event                               | What it does      | Transformer   |
|-----------------------------|-------------------------------------|-------------------|---------------|
| `login_bloc.dart`           | `LoginSubmitEvent`                  | POST login        | `throttle()`  |
| `otp_login_bloc.dart`       | `OtpLoginSubmitEvent`               | POST otp verify   | `throttle()`  |
| `home_bloc.dart`            | `HomeLoadEvent`, `HomeRefreshEvent` | GET home data     | `droppable()` |
| `notifications_bloc.dart`   | `NotificationsLoadEvent`            | GET notifications | `droppable()` |
| `payment_methods_bloc.dart` | `PaymentMethodsLoadEvent`           | GET cards         | `droppable()` |
| `payment_methods_bloc.dart` | `PaymentMethodAddEvent`             | POST add card     | `throttle()`  |
| `payment_methods_bloc.dart` | `PaymentMethodDeleteEvent`          | DELETE card       | `throttle()`  |
| `profile_bloc.dart`         | `ProfileInitialEvent`               | GET profile       | `droppable()` |
| `profile_bloc.dart`         | `UpdateProfilePressedEvent`         | PATCH profile     | `throttle()`  |

No bloc in this repo currently has a pure UI-echo event (the exception case above) — if you add one (e.g. a live-validation-as-you-type event with no network call), it's the first, and it still gets no transformer.
- after any `await` inside a mixin/page method that then touches `context` or `setState`, check `if (!mounted) return;` (or `if (!context.mounted) return;`) first — the widget may have been disposed during to await.

Before writing a new bloc: grep the target module for an existing bloc, confirm it already follows this. If it doesn't, **do not copy it** — write the new one correctly and flag the mismatch instead of propagating it.

## 3. `setState` in a bloc-driven page — the #1 place agents guess wrong

A mixin is allowed to hold plain mutable fields — a `List`, an `int` counter, a `bool` flag. These are **not** bloc state, and that's fine; they don't need to be. The only question that matters is: **does something already rebuild the widget that reads this field, or not?**

```dart
// feature_mixin.dart — plain mutable fields, none of them bloc state
mixin FeatureMixin on State<FeaturePage> {
  List<Item> _list = [];
  int _page = 1;
  bool _isPaginating = false;

  void _handleStates(_, FeatureState state) {
    if (state is FeatureSuccessState) {
      // Mutate the field. No setState call here.
      _list = state.items;
      _page++;
    }
  }
}
```

```dart
// feature_page.dart — the field above is read only inside this builder
Widget build(BuildContext context) => BlocListener<FeatureBloc, FeatureState>(
  listener: _handleStates,           // mutates _list, _page (no setState)
  child: BlocBuilder<FeatureBloc, FeatureState>(
    buildWhen: (prev, curr) => curr is FeatureState,   // reruns on the same emission that fed the listener
    builder: (_, state) => ListView.builder(
      itemCount: _list.length,       // reads the plain field — fresh, because build() just reran
      itemBuilder: (_, i) => ItemTile(_list[i]),
    ),
  ),
);
```

This is the whole trick: `BlocListener`'s `listener` and `BlocBuilder`'s `builder` both run off the **same state stream**. When the bloc emits `FeatureSuccessState`, the listener mutates `_list`/`_page`, and the builder — listening to the exact same emission — reruns `build()` on its own and reads the now-updated field. No `setState` involved, because nothing needed to be told to rebuild; it was already going to.

The rule, not a feel-based call:

- **A field is read only inside a `BlocBuilder`/`BlocConsumer` builder that isn't filtered out (by `buildWhen`) from the state you're about to emit** → mutate the field, no `setState`. The upcoming `emit(...)` already reruns that builder.
- **A field drives UI that lives *outside* any Bloc widget, or the change happens on a path where no `bloc.add(...)`/`emit(...)` follows at all** (pure local validation before a submit, a toggle with no bloc involved) → `setState` is required, nothing else will rebuild it.
- When both apply in the same method (validate locally first, only call the bloc if valid) — pattern-match per branch, don't blanket-apply one or the other to the whole method.

Confirmed real bug fixed in this repo from exactly this confusion: [`login_mixin.dart`](modules/auth/lib/src/presentation/login/mixin/login_mixin.dart) wrapped `_errorMessage = state.message` in `setState` inside `_handleStates` — but that's called from `BlocConsumer`'s `listener`, and its `builder` has no `buildWhen`, so the `LoginFailureState` emission that invoked the listener had already scheduled a full rebuild; the `setState` did nothing but force a second one. Fixed: plain field mutation, no `setState`. Contrast [`otp_login_mixin.dart`](modules/auth/lib/src/presentation/otp_login/mixin/otp_login_mixin.dart)'s `submitOtp()`: the empty-code branch returns before any `bloc.add(...)` — nothing will rebuild that frame, so `setState` there is correct and stays. The valid-code branch clears the same field right before `bloc.add(...)` — that one *is* followed by a state emission, so it dropped `setState` too. Both branches are in the same function; the two are not the same case.

Same mechanism as §6 (Pagination)'s `_list`/`_page`/`_isPaginating` fields — that section's fields are exactly this pattern, not a different one.

## 4. File Placement

```
modules/<module>/lib/src/presentation/<feature>/
  <feature>_page.dart
  bloc/<feature>_bloc.dart | _event.dart | _state.dart
  mixin/<feature>_mixin.dart
  widgets/*.dart
```

Page: `StatefulWidget`, dispatch initial event in `initState()`, `BlocListener` for side effects, `BlocBuilder` for render, `buildWhen`/`listenWhen` set explicitly. Mixin: `part of` page, holds controllers/focus/timers, `_handleStates` listener, disposes everything, exposes `FeatureBloc get bloc => context.read<FeatureBloc>();`. Widgets: `StatelessWidget`, constructor-only data, no repo/datasource access.

In-repo reference for this exact wiring: `modules/auth/lib/src/presentation/login/` (page + bloc + mixin, `BlocConsumer` with `listenWhen`, grouped sealed states in `login_state.dart`).

## 5. Route Args — never pass a raw entity through `extra`, never fabricate a fallback

Any route that needs input data gets a typed `Args` class in `presentation/<feature>/args/<feature>_args.dart` — a plain `final class` holding the fields, nothing else. The page's constructor takes that `args` object, not the raw entity/values directly.

```
// presentation/edit_profile/args/edit_profile_args.dart
final class EditProfileArgs {
  const EditProfileArgs({required this.user});
  final ProfileUserEntity user;
}

// caller
final result = await context.pushNamed(Routes.editProfile, extra: EditProfileArgs(user: user));

// router
GoRoute(
  path: Routes.editProfile,
  name: Routes.editProfile,
  builder: (_, state) => BlocProvider<ProfileBloc>(
    create: (_) => di.get(),
    child: EditProfilePage(args: state.extra! as EditProfileArgs),
  ),
),
```

- `state.extra! as XxxArgs` — a bang cast, not a type-checked `is` branch with a fabricated fallback object. A route reached without its required `extra` is a caller bug; a silent fallback (`id: 0, email: '', role: 'CLIENT'`, etc.) hides that bug behind fake data instead of crashing where the mistake was made.
- confirmed real bug fixed in this repo: `profile_router.dart`'s `Routes.editProfile` used to do `state.extra is ProfileUserEntity ? ... : const ProfileUserEntity(id: 0, email: '', firstName: '', lastName: '', role: 'CLIENT')` — passing the raw entity through `extra` with a made-up default user if the type check failed. Fixed with `EditProfileArgs` + `state.extra! as EditProfileArgs`, matching the pattern above.
- same rule applies to sheet routes (§9) — same `args/` folder, same `state.extra! as XxxArgs` cast, no exception for sheets vs regular routes.

### 5a. Prefer `.parse()` over the bang cast — `extra` is not as durable as it looks

The bang cast in §5 assumes `state.extra` survives until the page reads it. It doesn't always: GoRouter's `extra` is in-memory routing state, not part of the URL — an **orientation change (portrait ↔ landscape)** can force GoRouter to re-resolve/rebuild the current route, and `extra` comes back `null` on that rebuild even though the user never left the page or triggered any navigation. `state.extra! as XxxArgs` then throws mid-session, on a device rotation, on a route that was working fine seconds earlier. This is a GoRouter gotcha, not a mistake in how the route was reached.

Deep links, push notifications, and shared URLs are a second, separate reason `extra` can be `null` — the app launches straight into the route from a URL/payload with no `extra` ever set, only query parameters or a raw JSON payload.

Both reasons point at the same fix: don't bang-cast `extra` on any route whose data matters (a chat, a payment flow, anything the user would be annoyed to see crash) — give the args class a `.parse()` factory instead:

```dart
final class ChatArgs {
  const ChatArgs({required this.chatId});

  const ChatArgs.empty() : this(chatId: null);

  // in-app extra was a raw Map (e.g. from an older call site or a push-notification payload)
  factory ChatArgs.fromQueryParameters(Map<String, String> queryParameters) =>
      ChatArgs(chatId: queryParameters['chat_id']);

  // single entry point the router calls — handles every source uniformly
  factory ChatArgs.parse(Object? extra, {required Map<String, String> queryParameters}) {
    if (extra is ChatArgs) return extra;
    if (extra case final Map<String, dynamic> map) {
      return ChatArgs.fromQueryParameters({
        for (final MapEntry(:key, :value) in map.entries)
          if (value != null) key: value.toString(),
      });
    }
    if (queryParameters.isNotEmpty) return ChatArgs.fromQueryParameters(queryParameters);
    return const ChatArgs.empty();
  }

  final String? chatId;
}
```

```
// router — one call handles pushNamed(extra: ChatArgs(...)), extra going null on an
// orientation change, a deep-link URL with ?chat_id=123, and a push-notification
// payload delivered as a raw Map — none of them crash.
GoRoute(
  path: Routes.personalChat,
  name: Routes.personalChat,
  builder: (_, state) => MessagesPage(args: ChatArgs.parse(state.extra, queryParameters: state.uri.queryParameters)),
),
```

Decision: is this route trivial (a settings toggle, a confirmation sheet with nothing to lose if it briefly shows empty) and definitely never opened from outside an in-app `pushNamed`? → plain `Args` class, bang cast is acceptable (§5). Otherwise, — any route carrying data the user would notice disappearing (a chat, a payment flow, anything mid-form) — add `.empty()` + `.fromQueryParameters()` + `.parse()` to the `Args` class and call `.parse()` in the router instead of casting. Default to `.parse()` when unsure; the bang cast is the exception for genuinely low-stakes routes, not the default. Both shapes can coexist in the same router file — pick per route, not per module.

## 5b. Route Class Selection — plain `GoRoute` is almost never right

This app's root is `MaterialApp.router` from **`package:material_ui`**, not from `package:flutter/material.dart` (§12a). go_router sniffs the app type by looking for `package:flutter/material`'s `MaterialApp`/`CupertinoApp` above it — it doesn't find one here, so it falls back to **`NoTransitionPage`**. Result: a plain `GoRoute` in this repo pushes pages with **no transition at all and no iOS swipe-back gesture**. On iOS that reads as a broken app, and it is not fixable from the page side — it has to be fixed at the route class.

`packages/navigation` exists exactly for this. Pick the route class by what the destination is:

| Destination                                                              | Route class                  | Why                                                              |
|--------------------------------------------------------------------------|------------------------------|------------------------------------------------------------------|
| any normal full-screen page (the default)                                | **`CupertinoRoute`**         | restores the Cupertino push transition + iOS swipe-back gesture  |
| bottom sheet (§9)                                                        | **`MaterialSheetRoute`**     | wraps the builder in `MaterialSheetPage`/`ModalBottomSheetRoute` |
| full-screen page that must slide up from the bottom                      | **`SlideUpTransitionRoute`** | modal-style full page (media viewer, full-screen composer)       |
| `StatefulShellRoute` branch roots / shell scaffolds                      | plain `GoRoute`              | never visually pushed — the shell owns the transition            |
| a route whose builder returns `Dimensions.kZeroBox` (placeholder branch) | plain `GoRoute`              | renders nothing, no transition to lose                           |

- **Default is `CupertinoRoute`.** Writing `GoRoute` for a real page is the mistake this section exists to stop. If a new page route is a plain `GoRoute`, it's wrong unless it's one of the last two rows above — and say which row applies.
- All of them are drop-in: same `path`/`name`/`builder`/`routes`/`redirect`/`parentNavigatorKey` args as `GoRoute`, and they all still return `GoRoute`, so `List<GoRoute> getRouters(Injector di)` and `AppRouter<RouteBase>` stay unchanged.
- Import from the barrel only: `package:navigation/navigation.dart`. Never `package:navigation/src/...`. `CupertinoRoute` and `MaterialSheetRoute` are exported today; `SlideUpTransitionRoute` is **not** — if you need it, add the export line to `packages/navigation/lib/navigation.dart` rather than reaching into `src/`.
- Never write `pageBuilder:` in module router code. `pageBuilder` is what these route classes own. A `pageBuilder` in a module router means a route class was bypassed — replace it with the right class from the table.
- Existing plain `GoRoute`s in older module routers (`auth_router.dart`, `initial_router.dart`, `system_router.dart`, `payments_router.dart`, `profile_router.dart`'s page routes) predate this rule. They are **not** the reference — don't copy them, and don't propagate. Touching one of those routes for another reason? Switch it to `CupertinoRoute` while you're there.

```
// correct — normal page route
CupertinoRoute(
  path: Routes.login,
  name: Routes.login,
  builder: (_, _) => BlocProvider<LoginBloc>(create: (_) => di.get(), child: const LoginPage()),
),
```

## 6. Pagination (infinite scroll list) — do not hand-roll a package for this

No pagination package, no `PagingController`. Just: a page counter in the mixin + a scroll listener + a merge-and-dedupe on load-more.

- events: one `Get<Feature>ListEvent(page: 1)` for first load, one `GetPaginated<Feature>ListEvent(page: n)` for load-more — two separate events, two separate handlers, both `droppable()`.
- states: first-load family (`XxxLoadingState`/`XxxSuccessState`/`XxxFailureState`) separate from a `PaginationState` sealed family (`XxxPaginationLoadingState`/`XxxPaginationSuccessState`/`XxxPaginationFailureState`) — first load shows a full-page spinner, page 2+ must not.
- mixin state: `List<Item> _list = []`, `int _page = 1`, `bool _isPaginating = false`, `final ScrollController _scrollController = ScrollController()`.
- `initState()`: dispatch first-page event, then `_scrollController.addListener(_scrollListener)`. `dispose()`: remove listener + dispose controller.
- scroll listener:

```dart
void _scrollListener() {
  if (_isPaginating || _list.isEmpty) return;
  if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
      !_scrollController.position.outOfRange) {
    bloc.add(GetPaginatedFeatureListEvent(page: _page));
  }
}
```

- `_handleStates`: on first-page loaded, replace `_list` and bump `_page` (or set `_isPaginating = true` if the page came back shorter than the page limit — that means it's the last page). On pagination-loaded, merge via `{..._list, ...state.list}.toList()` (set union — dedupes if an item reappears) and apply the same shorter-than-limit → `_isPaginating = true` check.
- never introduce a third-party pagination package for this — the above is the whole pattern, it's a page counter and a scroll threshold check.

## 7. Cross-Module Reuse — `ModuleInteractor` (mandatory, not optional)

Problem this solves: a usecase in `auth` needed by `profile` → do **not** import auth's usecase directly into profile (creates compile-time module coupling). Instead:

- Define the shared operation as `ModuleInteractor<T, P>` (`packages/core/lib/src/core_abstractions/module_interactor.dart`) implementation in the **owning** module.
- Register it in the owning module's injection with an `instanceName` (add key to `packages/core/lib/src/constants/instance_name_keys.dart`).
- Consuming module resolves it via `di.get<ModuleInteractor<T, P>>(instanceName: InstanceNameKeys.xxx)` — no import of the owning module's package.
- Consumer's bloc field is typed as the **interface itself**, not a wrapper class:

```
// consuming bloc — field typed directly as ModuleInteractor<T, P>
// ProfileUser is a shared type from `core`, not profile's own entity — see §7a
final ModuleInteractor<ProfileUser, NoParams> _getProfileInteractor;

// consuming module's injection — wired at DI, no import of the owning module
ConsumerBloc(di.get(), di.get(instanceName: InstanceNameKeys.getProfileInteractor));
```

If you catch yourself adding another module's package to `pubspec.yaml` just to reuse one usecase, stop — that's the `ModuleInteractor` case.

### 7a. Writing the interactor — shape, location, and the type-visibility trap

This repo has no `ModuleInteractor` implementation yet, so there is nothing here to copy from. The shape below is the one to write.

**Location and naming.** Own file in the **owning** module: `modules/<owner>/lib/src/domain/interactor/<verb>_<target>_interactor.dart`. Class `Get<Target>Interactor` / `Create<Target>Interactor` — verb-first, `Interactor` suffix, `final class`, `const` constructor, `implements ModuleInteractor<T, P>` (implements, not extends). Sits next to `domain/usecases/`, never inside `presentation/` or `data/`.

**It is a thin adapter, never a second implementation.** Its only constructor dependency is the module's existing usecase; `call()` delegates. If an interactor contains repo/datasource calls or business rules the usecase doesn't have, the logic is in the wrong place — put it in the usecase and let the interactor forward.

```dart
// modules/profile/lib/src/domain/interactor/get_profile_interactor.dart
import 'package:core/core.dart' show Either, Failure, ModuleInteractor, NoParams, ProfileUser;
import 'package:profile/src/domain/usecases/get_profile.dart';

final class GetProfileInteractor implements ModuleInteractor<ProfileUser, NoParams> {
  const GetProfileInteractor(this._getProfile);

  final GetProfile _getProfile;

  @override
  Future<Either<Failure, ProfileUser>> call(NoParams params) => _getProfile();
}
```

**The trap: `T` and `P` must be typed the consumer can already see.** The consumer resolves `ModuleInteractor<T, P>` without depending on the owning module — so if `T` is that module's own entity or model, the consumer cannot name the type, and the whole pattern collapses back into a package dependency. `T` and `P` are limited to:

1. a shared entity in `packages/core/lib/src/entities/` (create the folder + file if it doesn't exist yet, and export it from `packages/core/lib/core.dart`), or
2. a plain Dart type — `String`, `bool`, `List<String>`, `Map<String, dynamic>`.

When the owning module's entity is not worth promoting to `core`, **flatten it at the boundary** — convert inside the interactor and hand back a map:

```dart
final class GetPopupInteractor implements ModuleInteractor<Map<String, dynamic>, NoParams> {
  const GetPopupInteractor(this._getActivePopup);

  final GetActivePopup _getActivePopup;

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) async {
    final result = await _getActivePopup();
    return result.fold(Left.new, (data) => Right(PopupModel.fromEntity(data).toMap()));
  }
}
```

That `fromEntity(...).toMap()` hop is the whole point — the model conversion stays in the owning module's data layer (§11), and the consumer gets a type it can read with zero imports.

**Params.** No input → `NoParams` (already in `core`). With input → a shared params class in `packages/core/lib/src/usecase/`, named `<Thing>FlowParams`, a `final class` with `const` constructor and `==`/`hashCode` (or `Equatable`). Never the owning module's params type.

**Registration** — interface type as the registration type, impl only inside the closure, always `registerLazySingleton`, grouped under an `/// interactors` comment in the owning module's injection:

```
di
  /// interactors
  ..registerLazySingleton<ModuleInteractor<ProfileUser, NoParams>>(
    () => GetProfileInteractor(di.get()),
    instanceName: InstanceNameKeys.getProfileInteractor,
  )
```

Registering the concrete class (`registerLazySingleton<GetProfileInteractor>(...)`) defeats the pattern — the consumer would have to name that class to resolve it.

**`InstanceNameKeys`** — key string equals the class name, grouped by kind:

```dart
final class InstanceNameKeys {
  const InstanceNameKeys._();

  /// page factories
  static const String homeFactory = 'HomePageFactory';

  /// interactors
  static const String getProfileInteractor = 'GetProfileInteractor';

  /// widget factories
  static const String taskItemFactory = 'TaskItemFactory';
}
```

**Imports.** In an interactor, import `core` with an explicit `show` list (`import 'package:core/core.dart' show Either, Failure, ModuleInteractor, NoParams;`) — the file only needs 4-5 symbols, and the narrow list makes an accidental dependency on something heavier obvious in review.

## 8. Cross-Module Pages — `PageFactory` (mandatory, not optional)

Reference implementations, confirmed correct: `modules/home/lib/src/home_page_factory.dart`, `modules/profile/lib/src/profile_page_factory.dart`, consumed in `modules/main/lib/src/router/main_router.dart`.

- File lives at the **module root**: `modules/<owner>/lib/src/<owner>_page_factory.dart` — not under `presentation/`. One-page factory per module is the normal case; if a module exposes several, name them per page (`<owner>_<page>_page_factory.dart`).
- Module exposes its page via `final class XxxPageFactory implements PageFactory { const XxxPageFactory(); @override Widget create(Injector di) => BlocProvider(...); }` — `final class`, `const` constructor, `implements`.
- The factory owns the page's bloc wiring, including the initial event, so the consumer never learns the bloc or event names: `create: (_) => di.get<HomeBloc>()..add(const HomeLoadEvent())`. Add `lazy: false` when the page must start loading the moment it is built rather than on first `context.read` (see `profile_page_factory.dart`).
- Registered in the owning module's injection: `di.registerLazySingleton<PageFactory>(() => const XxxPageFactory(), instanceName: InstanceNameKeys.xxxFactory)`. **`registerLazySingleton`, not `registerFactory`** — the factory itself is a `const` stateless object; a fresh widget tree comes from calling `create(di)`, not from a new factory instance.
- Consumer (e.g. `main`'s router/shell) resolves with `di.get<PageFactory>(instanceName: InstanceNameKeys.xxxFactory).create(di)` and **never imports the page/bloc classes directly**.
- `create(Injector di)` takes the injector as an argument — resolve everything the page needs from that `di`. Do not reach for `AppInjector.instance` inside a factory; the passed injector is what makes the factory testable with a mock.
- Check consumer's `pubspec.yaml` after: it must NOT list the produced module as a dependency. If it does, the factory pattern was bypassed — fix it.

## 8a. Cross-Module Widgets — `WidgetFactory<T>`

`PageFactory` hands over a whole route destination. When the piece crossing the module boundary is a **widget embedded inside the consumer's own layout** — a list item, a calendar strip, a stats card the consumer arranges itself — that's `WidgetFactory<T>` (`packages/core/lib/src/core_abstractions/widget_factory.dart`), not `PageFactory`.

| Crossing the boundary                          | Use                     |
|------------------------------------------------|-------------------------|
| full page the router navigates to              | `PageFactory`           |
| widget the consumer places inside its own tree | `WidgetFactory<T>`      |
| just an operation/data, no UI                  | `ModuleInteractor` (§7) |

- **Args class** — one `final class` per factory holding exactly the widget's inputs, callbacks included (`VoidCallback`, `ValueChanged<T>`). It lives in `packages/core/lib/src/entities/<domain>_widget_args.dart` (create + export from `core.dart` if absent) because both modules must name the type. Same visibility rule as §7a's `T`.
- **Factory** — `modules/<owner>/lib/src/presentation/<feature>/factory/<name>_factory.dart`, `final class XxxFactory implements WidgetFactory<XxxArgs>`, `const` constructor. `create` does nothing but map args onto the widget constructor — no DI lookups, no state, no logic:

```dart
import 'package:core/core.dart' show TaskItemArgs, WidgetFactory;
import 'package:material_ui/material_ui.dart';
import 'package:system_control/src/presentation/reminder/widgets/task_item.dart';

final class TaskItemFactory implements WidgetFactory<TaskItemArgs> {
  const TaskItemFactory();

  @override
  Widget create(TaskItemArgs args) => TaskItem(stat: args.stat, onTap: args.onTap);
}
```

- **Registration** — owning module's injection, generic interface as the type, under a `/// widget factories` comment:

```
di
  /// widget factories
  ..registerLazySingleton<WidgetFactory<TaskItemArgs>>(
    TaskItemFactory.new,
    instanceName: InstanceNameKeys.taskItemFactory,
  )
```

- **Consumer** resolves once into a `late final` field, not inside `build()` — a `di.get` on every rebuild is wasted work:

```
late final WidgetFactory<TaskItemArgs> _taskItemFactory = di.get(instanceName: InstanceNameKeys.taskItemFactory);
// ...
itemBuilder: (_, i) => _taskItemFactory.create(TaskItemArgs(stat: items[i], onTap: () => _open(items[i]))),
```

- Same closing check as §8: after wiring, the consumer's `pubspec.yaml` must not list the owning module.

## 9. Sheet Pages (bottom sheet as a route)

- location: own top-level folder, `presentation/<name>_sheet/<name>_sheet.dart` — not nested inside another feature's folder.
- optional input: `presentation/<name>_sheet/args/<name>_sheet_args.dart` — plain `final class` holding fields, no `Equatable` needed unless the args are compared.
- optional own bloc when the sheet needs async state: `presentation/<name>_sheet/bloc/` — same rules as §2.
- widget: `StatelessWidget`, root is `SafeAreaWithMinimum(minimum: Dimensions.kPaddingAll16, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [...]))`. Before using any `Dimensions.*` token, confirm it exists in `packages/components/lib/src/utils/dimensions.dart` — inventing a plausible-looking token name (`kPaddingAll16T0`, `kGap10`) is a compile error, and the token list is not guessable.
- route: **`MaterialSheetRoute`, always** (from `package:navigation/navigation.dart`) — never a hand-rolled `GoRoute(pageBuilder: ... MaterialSheetPage(...))`. `MaterialSheetRoute` already does that wrapping, plus `restorationId`, `name`, and path/query `arguments`; writing the `pageBuilder` by hand loses those and is a bug, not a style choice. It takes `builder: (context, state) => ...` — the same signature as a plain `GoRoute`, so nothing else about the route changes. See §5b.

```
MaterialSheetRoute(
  path: Routes.chooseThemeModeSheet,
  name: Routes.chooseThemeModeSheet,
  builder: (_, state) => ChooseThemeModeSheet(args: state.extra! as ChooseThemeModeArgs),
),
```

- `MaterialSheetPage` is an internal implementation detail of `MaterialSheetRoute` — module code never names it. Sheet knobs (`enableDrag`, `isDismissible`, `useSafeArea`, `isScrollControlled`, `modalBarrierColor`) are optional named args on `MaterialSheetRoute` itself; pass them there.
- route name suffix: `...Sheet` (e.g. `Routes.chooseThemeModeSheet`).
- caller opens with `final result = await context.pushNamed<T>(Routes.xSheet, extra: XArgs(...));`, sheet returns via `context.pop(value)` or dismisses via `context.pop()`.
- reference in this repo: `modules/profile/lib/src/presentation/choose_theme_mode_sheet/choose_theme_mode_sheet.dart`.

## 10. Domain Layer Contract (non-negotiable)

```dart
// entity — no JSON, no fromMap/toMap, extends Equatable, all fields final
class FeatureEntity extends Equatable {
  const new({required this.id, required this.items});
  final String? id;              // scalar/object fields: nullable
  final List<ItemEntity> items;  // list fields: non-null, required
  @override
  List<Object?> get props => [id, items];
}

// repository — abstract interface class, returns ResultFuture<T>, no impl body
abstract interface class FeatureRepository {
  const new();
  ResultFuture<FeatureEntity> getFeature();
}

// usecase — plain `class` (no `final`), extends UsecaseWithParams/UsecaseWithoutParams,
// one operation, depends on interface not impl
class GetFeature extends UsecaseWithoutParams<FeatureEntity> {
  const new(this._repo);
  final FeatureRepository _repo;
  @override
  ResultFuture<FeatureEntity> call() => _repo.getFeature();
}
```

- entity naming: `Xxx` folder-local convention aside, suffix `Entity` when disambiguation needed, otherwise follow module's existing style.
- repo interface naming: `repo`/`repository`/`repos` — match the target module's existing style, don't mix within one module (see `docs/architecture/module_structure.md §3`).
- one usecase = one business operation. Never bundle two operations in one usecase class.
- **`final` modifier, by kind — not by feel.** Infrastructure classes are `final class`: bloc, event, state, `<M>Container`, `<M>Injection`, `<M>Router`, `PageFactory`/`WidgetFactory` impls, `<Usecase>Params`, `<M>ApiPaths`, every `*Impl`. Domain/data data-carrying classes are plain `class` with no modifier: entity, model, usecase. This is not a stylistic preference — it is what all 31 of those classes do today (10/10 entity, 10/10 model, 11/11 usecase carry no modifier). Adding `final` to a usecase or entity contradicts every existing one.

## 11. Data Layer Contract (non-negotiable)

```dart
class FeatureModel extends FeatureEntity {
  const FeatureModel({required super.id, required super.items});

  factory FeatureModel.fromMap(Map<String, dynamic> map) {
    final items = <ItemModel>[];
    if (map['items'] is List) {
      for (final item in map['items'] as List) {
        if (item is Map<String, dynamic>) items.add(ItemModel.fromMap(item));
      }
    }
    return FeatureModel(id: map['id'] as String?, items: items);
  }

  Map<String, dynamic> toMap() => {'id': id, 'items': items.map((e) => (e as ItemModel).toMap()).toList()};
}
```

- model extends entity, never the reverse.
- `fromMap`/`toMap` live in model only — never in entity/bloc/page/widget.
- list fields: initialize empty, only iterate if runtime type is `List`, type-check each element before parsing.
- scalar fields: nullable cast (`as String?`), no invented fallback (`''`, `0`) unless a stated business rule requires it.
- module-local API paths only: `final class <Feature>ApiPaths { const <Feature>ApiPaths._(); static const String x = '/...'; }` inside that module's `data/datasource/`. Never add to a shared/global `ApiPaths`.
- datasource impl catches `ServerException`/`Exception`/`Error`, converts to `ServerException.*`; repo impl converts `ServerException` → `Failure` via `Left`.

## 12. Component/Core Usage (presentation layer only)

- import only `package:components/components.dart` and `package:core/core.dart` — never `.../src/...`.
- widget imports: `package:material_ui/material_ui.dart` (default), `package:cupertino_ui/cupertino_ui.dart` when Cupertino types are needed. `package:flutter/material.dart` and `package:flutter/cupertino.dart` are **forbidden and don't resolve** on Flutter 3.47+ — see §12a.
- colors: `context.color.*` first, `context.colorScheme.*` for Material interop, hardcoded `Colors.*` only when no token exists.
- text: `context.textTheme.*` first (38 uses in this repo vs 2 for `context.textStyle.*`), avoid ad-hoc `TextStyle(...)`. Need a one-off tweak? `context.textTheme.bodyMedium?.copyWith(color: context.color.textSecondary)` — not a bare `TextStyle(...)`. `context.textStyle.*` is the custom `ThemeExtension` and stays available, but it is not the default reach.
- spacing: `Dimensions.kGap*`/`Gap(...)`/`Dimensions.kPadding*` — avoid raw `EdgeInsets`/`SizedBox` when a token exists.
- safe area: `SafeAreaWithMinimum`, not plain `SafeArea`, unless explicitly not wanted.
- primary/submit buttons: `CustomLoadingButton` (built-in double-tap throttle), not raw `ElevatedButton`.
- full-screen async block: `ModalProgressHUD`.
- all user-facing text: `context.l10n.<key>` — never a hardcoded string.
- navigation: `GoRouter` named routes only (`context.pushNamed`/`goNamed`/`pop`). No `Navigator 1.0`. Route classes come from `package:navigation/navigation.dart` — `CupertinoRoute` for pages, `MaterialSheetRoute` for sheets (§5b).
- forbidden APIs anywhere in module code: `Navigator.push`/`Navigator.pop` (use GoRouter), `MediaQuery.of(context)` (use `context.width`/`context.height`/`context.padding` extensions), `print()` (use the project logger).

## 12a. Widget Imports — `material_ui` / `cupertino_ui`, never `package:flutter/...` (Flutter 3.47+)

As of **Flutter 3.47** the Material and Cupertino widget libraries moved out of the Flutter SDK into standalone packages. This repo is on that layout: every `pubspec.yaml` here depends on `material_ui: ^1.1.1` (and `cupertino_ui: ^1.0.2` where Cupertino widgets are used), and `package:flutter/material.dart` / `package:flutter/cupertino.dart` **no longer resolve**. There are zero of those imports left in the repo — keep it that way.

- widget / theme / painting / gesture imports come from **`package:material_ui/material_ui.dart`** — this is the default, use it for `StatelessWidget`, `BuildContext`, `Widget`, `Color`, `TextStyle`, `Colors`, `Curves`, `EdgeInsets`, `MaterialApp`, `Scaffold`, everything.
- **`package:cupertino_ui/cupertino_ui.dart`** only when you need actual Cupertino types (`CupertinoPage`, `CupertinoActivityIndicator`, `CupertinoTheme`, …). Don't add it "just in case" — it's on 2 of the repo's pubspecs, not all of them.
- **forbidden imports, anywhere**: `package:flutter/material.dart`, `package:flutter/cupertino.dart`. They do not exist on this SDK. `package:flutter/widgets.dart`, `package:flutter/services.dart`, `package:flutter/foundation.dart`, `package:flutter/rendering.dart` still ship with the SDK and are fine when you need only those.
- new module or new package? its `pubspec.yaml` gets `material_ui: ^1.1.1` under `dependencies` (and `cupertino_ui: ^1.0.2` only if it uses Cupertino types). Pin the same versions the rest of the repo uses — don't float them.
- domain layer stays UI-free: no `material_ui`, no `cupertino_ui`, no Flutter import at all in `domain/` (§10) — swapping the package name doesn't make a UI import allowed there.
- copying a snippet from an old commit, Stack Overflow, or any pre-3.47 source? Swap its `package:flutter/material.dart` line for `package:material_ui/material_ui.dart` before saving. This is the single most common mechanical error in this repo.

## 13. Package Isolation (verified clean as of now — keep it that way)

`packages/components`, `packages/core`, `packages/navigation`, `packages/platform_methods` must **never** depend on each other or on any `modules/*`. Before adding an import between these four, stop — it's wrong by construction. Shared code that needs to cross them belongs in `core` only, and even `core` must stay dependency-free of the other three.

## 14. Module Ownership & Ordering

- Pick one owner module per feature — see `docs/architecture/module_selection.md` for the ownership map and algorithm.
- Build order inside a module: domain (entity → repo interface → usecase) → data (model → datasource → repo impl) → presentation (bloc → page/mixin → widgets) → DI → router.
- New module: follow `docs/architecture/new_module_creation.md` exactly, and register in `packages/merge_dependencies/lib/merge_dependencies.dart`'s `_allContainer` — skipping this means DI/routes silently don't load.

## 15. DI Rules

- `registerLazySingleton`: datasources, repositories, usecases, and every `const` stateless collaborator registered under an instance name — `ModuleInteractor` impls (§7a), `PageFactory` impls (§8), `WidgetFactory<T>` impls (§8a).
- `registerFactory`: blocs only. A bloc is per-page state and must be fresh each time; a factory object is not.
- Anything registered under an `instanceName` is registered **by its interface type** (`PageFactory`, `WidgetFactory<XArgs>`, `ModuleInteractor<T, P>`), never by its concrete class — resolving by concrete class forces the consumer to import the owning module and defeats §7–8a.
- Register in dependency order, with a group comment per block, in exactly this order: `/// page factories` → `/// widget factories` → `/// data sources` → `/// repositories` → `/// usecases` → `/// interactors` → `/// bloc`. Factories come first because they hold no dependencies; interactors come after usecases because they wrap one.
- Only public barrel imports (`package:core/core.dart`), never `package:core/src/...`.

## 16. Quality Gate (before calling anything done)

Fast gate (changed files only — recommended during development):
```bash
./scripts/quick_check.sh
```

Full gate (entire repo):
```bash
dart fix --apply
dart format ./
flutter analyze
```

## 17. Definition of Done

- [ ] owner module stated + reason
- [ ] section 1 reference used (not an arbitrary module)
- [ ] bloc/event/state naming matches section 2 exactly, no `_onXxx`
- [ ] cross-module usecase → `ModuleInteractor`, cross-module page → `PageFactory`, cross-module widget → `WidgetFactory<T>` (§7–8a), not direct import
- [ ] interactor/widget-factory generics use only `core`-visible types (shared entity or plain Dart type), registered by interface type under an `InstanceNameKeys` key (§7a, §8a)
- [ ] route with input data uses a typed `Args` class + `state.extra! as XxxArgs`, no raw entity through `extra`, no fabricated fallback (§5)
- [ ] entity has no `fromMap`/`toMap`, model has both, list fields non-null (§10–11)
- [ ] API endpoints are module-local, not added to a global `ApiPaths` (§11)
- [ ] no forbidden API used: `Navigator 1.0`, `MediaQuery.of(context)`, `print()` (§12)
- [ ] every widget file imports `material_ui`/`cupertino_ui`; zero `package:flutter/material.dart` or `package:flutter/cupertino.dart` imports; new pubspec has `material_ui: ^1.1.1` (§12a)
- [ ] every new full-screen page route is `CupertinoRoute`, not plain `GoRoute` — or the shell/placeholder exception is stated (§5b)
- [ ] user-facing strings via `context.l10n.*`, not hardcoded (§12)
- [ ] bottom-sheet route uses own top-level folder + `MaterialSheetRoute` (never a handwritten `pageBuilder`/`MaterialSheetPage`) (§9)
- [ ] pagination (if any) uses page counter + scroll listener, no third-party pagination package (§6)
- [ ] no `setState` duplicating a rebuild `BlocBuilder`/`BlocConsumer` already does; `setState` used only where nothing else would rebuild that field (§3)
- [ ] no new dependency added between `components`/`core`/`navigation`/`platform_methods`
- [ ] DI + router wired, module registered in `merge_dependencies` if new
- [ ] fix/format/analyze clean
- [ ] touched files listed
