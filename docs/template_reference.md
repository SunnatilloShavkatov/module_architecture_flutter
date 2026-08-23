# TEMPLATE REFERENCE — copy-paste source of truth

Every file shape this project uses, written the way it must be written. **Clone from here.** Do not
invent a simpler shape, do not mix in a style you remember from another project, and do not copy a
module that disagrees with this file — some modules predate the current rules.

**How this file relates to `CLAUDE.md`:** `CLAUDE.md` states the rules and the *why*; this file is
the *what it looks like*. Every section below links back to the rule it implements. When the two
disagree, `CLAUDE.md` wins and this file is the bug — say so instead of following the older text.

Read order for any feature: **§0 non-negotiables → the section for the file you're writing → §12
self-check.**

| I'm writing…                               | Jump to | Rule                  |
|--------------------------------------------|---------|-----------------------|
| anything at all                            | §0      | `CLAUDE.md` §12a, §16 |
| entity / repo interface / usecase          | §1      | `CLAUDE.md` §10       |
| model / api paths / datasource / repo impl | §2      | `CLAUDE.md` §11       |
| bloc + event + state                       | §3      | `CLAUDE.md` §2        |
| mixin                                      | §4      | `CLAUDE.md` §3, §4    |
| page                                       | §5      | `CLAUDE.md` §4        |
| widget                                     | §6      | `CLAUDE.md` §12       |
| route args                                 | §7      | `CLAUDE.md` §5, §5a   |
| router                                     | §8      | `CLAUDE.md` §5b       |
| bottom sheet                               | §9      | `CLAUDE.md` §9        |
| DI                                         | §10     | `CLAUDE.md` §15       |
| cross-module factory / interactor          | §11     | `CLAUDE.md` §7–8a     |
| finished, checking my work                 | §12     | `CLAUDE.md` §17       |

---

## 0. NON-NEGOTIABLES — the four things agents get wrong every time

### 0.1 Constructor shorthand (Dart 3.47) — `const new()`, not `const ClassName()`

This repo is on Dart 3.47's constructor shorthand. **Declarations** omit the class name; **call
sites** are unchanged.

```
class LoginPage extends StatefulWidget {
  const new({super.key});                      // NOT: const LoginPage({super.key});
}

final class LoginBloc extends Bloc<LoginEvent, LoginState> {
  new(this._login) : super(const LoginInitialState());   // NOT: LoginBloc(this._login) : ...
}

final class InstanceNameKeys {
  const new _();                               // private ctor. NOT: const InstanceNameKeys._();
}

class UserModel extends UserEntity {
  const new({required super.id});
  factory fromMap(Map<String, dynamic> map) => UserModel(id: map['id'] as int?);   // NOT: factory UserModel.fromMap(...)
}
```

```
// call sites keep the class name — nothing changes here
const LoginPage();
UserModel.fromMap(json);
const AuthRouter();
```

Writing `const LoginPage({super.key});` inside `class LoginPage` is the single most common mechanical
error in this repo. Check every constructor you write.

### 0.2 UI imports — `material_ui`, never `package:flutter/material.dart` (`CLAUDE.md` §12a)

```dart
import 'package:material_ui/material_ui.dart';     // widgets, theme, painting, gestures — the default
import 'package:cupertino_ui/cupertino_ui.dart';   // only for real Cupertino types
```

`package:flutter/material.dart` and `package:flutter/cupertino.dart` **do not resolve** on this SDK.
`package:flutter/services.dart`, `foundation.dart`, `widgets.dart`, `rendering.dart` still do.

### 0.3 Barrel imports only (`CLAUDE.md` §12)

`package:components/components.dart`, `package:core/core.dart`, `package:navigation/navigation.dart`.
Never `package:core/src/...`. If a widget you need isn't exported from the barrel, add the export
line to the barrel — don't reach into `src/`.

### 0.4 Routes are `CupertinoRoute` / `MaterialSheetRoute`, never bare `GoRoute` (`CLAUDE.md` §5b)

A plain `GoRoute` renders with **no transition and no iOS swipe-back** in this app. See §8.

---

## 1. DOMAIN LAYER (`CLAUDE.md` §10 · `docs/domain_layer/`)

Build order inside a module: **domain → data → presentation → DI → router.**

### 1.1 Entity — `domain/entities/user_entity.dart`

```dart
import 'package:core/core.dart';

class UserEntity extends Equatable {
  const new({
    required this.id,
    required this.email,
    required this.roles,
    this.phone,
  });

  final int? id;                 // scalar/object fields: nullable
  final String? email;
  final String? phone;
  final List<String> roles;      // list fields: non-null and required

  @override
  List<Object?> get props => [id, email, phone, roles];
}
```

No `fromMap`, no `toMap`, no `material_ui` import, no Flutter import at all. Ever.

### 1.2 Repository interface — `domain/repos/auth_repo.dart`

```dart
import 'package:auth/src/domain/entities/user_entity.dart';
import 'package:core/core.dart' show ResultFuture;

abstract interface class AuthRepo {
  const new();

  ResultFuture<UserEntity> login({required String email, required String password});
}
```

Folder name is `repo`/`repos`/`repository` — **match whatever the module already uses**, never mix
two spellings inside one module.

### 1.3 Usecase — `domain/usecases/login.dart`

```dart
import 'package:auth/src/domain/entities/user_entity.dart';
import 'package:auth/src/domain/repos/auth_repo.dart';
import 'package:core/core.dart' show ResultFuture, UsecaseWithParams;

final class Login extends UsecaseWithParams<UserEntity, LoginParams> {
  const new(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<UserEntity> call(LoginParams params) =>
      _repo.login(email: params.email, password: params.password);
}

final class LoginParams {
  const new({required this.email, required this.password});

  final String email;
  final String password;
}
```

- `final class`, `const` ctor, depends on the **interface**, one business operation per usecase.
- No params → `extends UsecaseWithoutParams<T>` and `call()` with no argument.
- Params class lives in the same file as its usecase, named `<Usecase>Params`.

---

## 2. DATA LAYER (`CLAUDE.md` §11 · `docs/data_layer/models.md`)

### 2.1 Model — `data/models/user_model.dart`

```dart
import 'package:auth/src/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const new({required super.id, required super.email, required super.roles, super.phone});

  factory fromMap(Map<String, dynamic> map) {
    final roles = <String>[];
    if (map['roles'] is List) {
      for (final role in map['roles'] as List) {
        if (role is String) roles.add(role);
      }
    }
    return UserModel(
      id: map['id'] as int?,          // nullable cast, no invented fallback
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      roles: roles,
    );
  }

  Map<String, dynamic> toMap() => {'id': id, 'email': email, 'phone': phone, 'roles': roles};
}
```

- Model extends entity — never the reverse.
- Lists: start empty, check `is List`, type-check each element before parsing.
- Scalars: `as String?` / `as int?`. `?? ''` or `?? 0` only when a stated business rule demands it —
  a fabricated default hides a backend contract change instead of surfacing it.
- Nested models: `if (item is Map<String, dynamic>) items.add(ItemModel.fromMap(item));`.

### 2.2 API paths — `data/datasource/auth_api_paths.dart`

```dart
final class AuthApiPaths {
  const new _();

  static const String login = '/api/v1/auth/login';
  static const String otpLogin = '/api/v1/auth/otp-login';
}
```

Module-local, always. Never add an endpoint to a shared/global `ApiPaths`.

### 2.3 Datasource — `data/datasource/auth_remote_data_source.dart` (+ `_impl.dart` as `part`)

```dart
import 'package:auth/src/data/datasource/auth_api_paths.dart';
import 'package:auth/src/data/models/user_model.dart';
import 'package:core/core.dart';

part 'auth_remote_data_source_impl.dart';

abstract interface class AuthRemoteDataSource {
  const new();

  Future<UserModel> login({required String email, required String password});
}
```

```dart
part of 'auth_remote_data_source.dart';

final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const new(this._networkProvider);

  final NetworkProvider _networkProvider;

  @override
  Future<UserModel> login({required String email, required String password}) async {
    try {
      final result = await _networkProvider.fetchMethod<Map<String, dynamic>>(
        AuthApiPaths.login,
        methodType: RMethodTypes.post,
        data: {'email': email, 'password': password},
      );
      return UserModel.fromMap(result.data ?? {});
    } on FormatException {
      throw ServerException.formatException(locale: _networkProvider.locale);
    } on ServerException {
      rethrow;
    } on Exception {
      rethrow;
    } on Error catch (error, stackTrace) {
      logMessage('ERROR: ', error: error, stackTrace: stackTrace);
      if (error is TypeError) {
        throw ServerException.typeError(locale: _networkProvider.locale);
      } else {
        throw ServerException.unknownError(locale: _networkProvider.locale);
      }
    }
  }
}
```

That `try/on FormatException/on ServerException/on Exception/on Error` ladder is fixed boilerplate —
reproduce it in every datasource method, don't shorten it to a bare `catch`.

### 2.4 Repository impl — `data/repo/auth_repo_impl.dart`

```dart
import 'package:auth/src/data/datasource/auth_remote_data_source.dart';
import 'package:auth/src/domain/entities/user_entity.dart';
import 'package:auth/src/domain/repos/auth_repo.dart';
import 'package:core/core.dart';

final class AuthRepoImpl implements AuthRepo {
  const new(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<UserEntity> login({required String email, required String password}) async {
    try {
      final result = await _remoteDataSource.login(email: email, password: password);
      return Right(result);
    } on ServerException catch (e) {
      return Left(e.failure);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
```

Exception → `Failure` conversion happens **here** and nowhere else. Blocs never see an exception.

---

## 3. BLOC / EVENT / STATE (`CLAUDE.md` §2 · `docs/presentation_layer/page_bloc_widget_mixin_plan.md`)

Three files in `presentation/<feature>/bloc/`, wired with `part` — the bloc declares the parts, the
event and state files are `part of` it. (`modules/auth`'s two blocs use plain imports instead; they
predate this rule — use `part`.)

### 3.1 Bloc — `bloc/login_bloc.dart`

```dart
import 'package:auth/src/domain/entities/user_entity.dart';
import 'package:auth/src/domain/usecases/login.dart';
import 'package:core/core.dart';

part 'login_event.dart';
part 'login_state.dart';

final class LoginBloc extends Bloc<LoginEvent, LoginState> {
  new(this._login) : super(const LoginInitialState()) {
    on<SubmitLoginEvent>(_submitLoginHandler, transformer: throttle());
  }

  final Login _login;

  Future<void> _submitLoginHandler(SubmitLoginEvent event, Emitter<LoginState> emit) async {
    if (state is LoginLoadingState) {
      return;
    }
    emit(const LoginLoadingState());
    final result = await _login(LoginParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(LoginFailureState(message: failure.message)),
      (user) => emit(LoginSuccessState(user: user)),
    );
  }
}
```

Four things that are not optional:

1. **Handler name = `_<verb><Target>Handler`** — `_submitLoginHandler`, `_getProfileHandler`,
   `_sendOtpHandler`. **Never `_onXxx`**, never `_stateListener`, never `_homeLoadHandler`
   (verb second).
2. **Transformer on every event that calls a usecase**, chosen by what the backend call is:

   | Event triggers                           | Transformer    |
   |------------------------------------------|----------------|
   | POST/PATCH/PUT/DELETE (any write)        | `throttle()`   |
   | GET (load, list, refresh)                | `droppable()`  |
   | server-side search as the user types     | `debounce()`   |
   | must run strictly after the previous one | `sequential()` |
   | pure local UI echo, no usecase at all    | *(none)*       |

3. **Loading guard** `if (state is XxxLoadingState) return;` before `emit(const XxxLoadingState())`.
4. Bloc depends on **usecases** (or a `ModuleInteractor`, §11) — never a repo, datasource, or `Dio`.

### 3.2 Event — `bloc/login_event.dart`

```dart
part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const new();
}

final class SubmitLoginEvent extends LoginEvent {
  const new({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
```

Verb-first, explicit target, `Event` suffix: `GetProfileEvent`, `SubmitLoginEvent`,
`UpdateProfileEvent`, `DeletePaymentMethodEvent`, `RefreshHomeEvent`.

### 3.3 State — `bloc/login_state.dart`

```
part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const new();
}

final class LoginInitialState extends LoginState {
  const new();

  @override
  List<Object?> get props => [];
}

final class LoginLoadingState extends LoginState {
  const new();

  @override
  List<Object?> get props => [];
}

final class LoginSuccessState extends LoginState {
  const new({required this.user});

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

final class LoginFailureState extends LoginState {
  const new({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
```

- Names: `XxxInitialState`, `XxxLoadingState`, `XxxSuccessState`/`XxxLoadedState`,
  `XxxFailureState`/`XxxErrorState` — always prefixed with the feature, never a bare `LoadingState`.
- Every concrete state overrides `props`, even when empty.
- **Multi-flow page** (one page, two independent async flows): group with intermediate sealed
  classes so the page can filter by family:

```
sealed class ProfileState extends Equatable { const new(); }

sealed class ProfileInfoState extends ProfileState { const new(); }
final class ProfileInfoLoadingState extends ProfileInfoState { ... }
final class ProfileInfoLoadedState extends ProfileInfoState { ... }

sealed class ProfileAvatarState extends ProfileState { const new(); }
final class ProfileAvatarLoadingState extends ProfileAvatarState { ... }
```

### 3.4 Pagination bloc (`CLAUDE.md` §6)

Two events, two handlers, both `droppable()`; two state families so page 2 doesn't show the
full-screen spinner. No pagination package, ever.

```
on<GetBusinessListEvent>(_getBusinessListHandler, transformer: droppable());          // page 1
on<GetPaginatedBusinessListEvent>(_getPaginatedBusinessListHandler, transformer: droppable());  // page n
```

```
// first load family
final class BusinessListLoadingState extends BusinessListState { ... }
final class BusinessListLoadedState extends BusinessListState { ... }
final class BusinessListErrorState extends BusinessListState { ... }
// pagination family — page 2+, never a full-page spinner
final class BusinessListPaginationLoadingState extends BusinessListState { ... }
final class BusinessListPaginationLoadedState extends BusinessListState { ... }
final class BusinessListPaginationErrorState extends BusinessListState { ... }
```

---

## 4. MIXIN (`CLAUDE.md` §3, §4)

`presentation/<feature>/mixin/<feature>_mixin.dart`, always `part of` the page. It owns controllers,
focus nodes, timers, local fields, the state listener, and disposal. It does **not** build widgets.

```dart
part of '../login_page.dart';

mixin LoginMixin on State<LoginPage> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController = TextEditingController();
  late final FocusNode _passwordFocus = FocusNode();
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordObscured = true;
  String? _errorMessage;

  LoginBloc get bloc => context.read<LoginBloc>();

  void _handleStates(BuildContext context, LoginState state) {
    if (state is LoginFailureState) {
      // No setState: the emission that fired this listener also reruns the
      // BlocConsumer's builder, which reads _errorMessage. See CLAUDE.md §3.
      _errorMessage = state.message;
    } else if (state is LoginSuccessState) {
      context.goNamed(Routes.mainHome);
    }
  }

  void _togglePasswordVisibility() {
    // setState IS required: nothing else rebuilds this — no bloc event follows.
    setState(() => _isPasswordObscured = !_isPasswordObscured);
  }

  void _loginPressed() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;                       // early-return branch: no emit follows
    }
    _errorMessage = null;           // branch that DOES emit: plain mutation, no setState
    bloc.add(SubmitLoginEvent(email: _emailController.text.trim(), password: _passwordController.text.trim()));
  }

  Future<void> _openSheet() async {
    final mode = await context.pushNamed<ThemeMode>(Routes.chooseThemeModeSheet);
    if (!mounted) return;           // mandatory after every await before touching context/setState
    if (mode != null) context.setThemeMode(mode);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }
}
```

**The `setState` decision — the #1 thing agents guess wrong (`CLAUDE.md` §3):**

| The field is…                                                                                 | Do                                   |
|-----------------------------------------------------------------------------------------------|--------------------------------------|
| read only inside a `BlocBuilder`/`BlocConsumer` builder that the upcoming emission will rerun | mutate it plainly, **no `setState`** |
| driving UI outside any Bloc widget, or changed on a path with no `bloc.add`/`emit` after it   | **`setState` required**              |
| both, in different branches of one method                                                     | decide per branch                    |

Pagination fields (`_list`, `_page`, `_isPaginating`, `_scrollController`) are the first row — the
listener mutates them and the builder reruns from the same emission:

```dart
mixin BusinessListMixin on State<BusinessListPage> {
  final ScrollController _scrollController = ScrollController();
  static const int _pageSize = 20;

  List<BusinessEntity> _list = [];
  int _page = 1;
  bool _isPaginating = false;

  @override
  void initState() {
    super.initState();
    bloc.add(const GetBusinessListEvent(page: 1));
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_isPaginating || _list.isEmpty) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      bloc.add(GetPaginatedBusinessListEvent(page: _page));
    }
  }

  void _handleStates(BuildContext context, BusinessListState state) {
    if (state is BusinessListLoadedState) {
      _list = state.list;
      _page++;
      if (state.list.length < _pageSize) _isPaginating = true;   // short page => last page reached
    } else if (state is BusinessListPaginationLoadedState) {
      _list = {..._list, ...state.list}.toList();                        // set union dedupes
      _page++;
      if (state.list.length < _pageSize) _isPaginating = true;
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_scrollListener)
      ..dispose();
    super.dispose();
  }
}
```

---

## 5. PAGE (`CLAUDE.md` §4)

`presentation/<feature>/<feature>_page.dart`. `StatefulWidget`, `part` of its mixin, initial event in
`initState()`, `listenWhen`/`buildWhen` set explicitly.

```dart
import 'package:auth/src/presentation/login/bloc/login_bloc.dart';
import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:navigation/navigation.dart';

part 'mixin/login_mixin.dart';

class LoginPage extends StatefulWidget {
  const new({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with LoginMixin {
  @override
  Widget build(BuildContext context) => BlocConsumer<LoginBloc, LoginState>(
    listenWhen: (prev, curr) => curr is LoginFailureState || curr is LoginSuccessState,
    listener: _handleStates,
    builder: (context, state) => Scaffold(
      body: SafeAreaWithMinimum(
        minimum: Dimensions.kPaddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(context.l10n.loginTitle, style: context.textTheme.titleLarge),
            Dimensions.kGap20,
            CustomTextField(
              controller: _emailController,
              focusNode: _emailFocus,
              onChanged: (_) {},
              hintText: context.l10n.emailLabel,
              textInputType: TextInputType.emailAddress,
              validator: _emailValidator,
            ),
            if (_errorMessage != null) ...[
              Dimensions.kGap8,
              Text(_errorMessage!, style: TextStyle(color: context.colorScheme.error)),
            ],
            Dimensions.kGap12,
            CustomLoadingButton(
              isLoading: state is LoginLoadingState,
              onPressed: _loginPressed,
              child: Text(context.l10n.loginButton),
            ),
          ],
        ),
      ),
    ),
  );
}
```

Page rules:

- `initState()` dispatches the page's first event (`bloc.add(const GetProfileEvent())`) — unless a
  `PageFactory` already seeds it (§11).
- `BlocConsumer` when the page both listens and builds; `BlocListener` + `BlocBuilder` when the
  listening and building subtrees differ.
- **`listenWhen` for side effects** — filter to the states that navigate or show a snackbar, so a
  rebuild doesn't re-fire navigation.
- Tokens, not raw values: `Dimensions.kGap*` / `Dimensions.kPadding*` instead of `SizedBox`/
  `EdgeInsets`, `context.color.*` / `context.textStyle.*` / `context.textTheme.*` instead of
  hardcoded `Color`/`TextStyle`, `SafeAreaWithMinimum` instead of `SafeArea`,
  `CustomLoadingButton` instead of `ElevatedButton`, `ModalProgressHUD` for full-screen blocking.
- Every user-facing string is `context.l10n.<key>`. No literal text in the tree.
- Size from `context.width`/`context.height`/`context.padding`/`context.viewInsets` — **never**
  `MediaQuery.of(context)`.
- Navigation via `context.pushNamed`/`goNamed`/`pop` — **never** `Navigator.push`/`Navigator.pop`.
- Logging via the project logger (`logMessage`) — never `print()`.

---

## 6. WIDGET (`CLAUDE.md` §12)

`presentation/<feature>/widgets/business_card.dart`. `StatelessWidget`, data in through the
constructor, callbacks out. No bloc lookup, no repo, no datasource, no DI.

```dart
import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:material_ui/material_ui.dart';

class BusinessCard extends StatelessWidget {
  const new({required this.business, this.onTap, super.key});

  final BusinessEntity business;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: Dimensions.kBorderRadius12,
    child: Padding(
      padding: Dimensions.kPaddingAll12,
      child: Row(
        children: [
          Expanded(child: Text(business.name ?? '', style: context.textTheme.titleMedium)),
          Dimensions.kGap8,
          Icon(Icons.chevron_right, color: context.color.textSecondary),
        ],
      ),
    ),
  );
}
```

A widget that needs bloc state gets it passed in by the page, or is wrapped in its own
`BlocBuilder` by the page — it does not reach for `context.read` itself.

---

## 7. ROUTE ARGS (`CLAUDE.md` §5, §5a)

Any route carrying data gets a typed args class in `presentation/<feature>/args/<feature>_args.dart`.
Never pass a raw entity through `extra`, and never fabricate a fallback object.

### 7.1 Low-stakes route — plain args + bang cast

```dart
final class EditProfileArgs {
  const new({required this.user});

  final ProfileUserEntity user;
}
```

```
builder: (_, state) => EditProfilePage(args: state.extra! as EditProfileArgs),
```

### 7.2 Anything that matters — add `.parse()` (preferred default)

`extra` is in-memory only: **an orientation change can rebuild the route with `extra == null`**, and
deep links / push notifications arrive with no `extra` at all. Bang-casting then crashes a page that
was working a second earlier.

```
final class ChatArgs {
  const new({required this.chatId});

  const new.empty() : this(chatId: null);

  factory fromQueryParameters(Map<String, String> queryParameters) =>
      ChatArgs(chatId: queryParameters['chat_id']);

  factory parse(Object? extra, {required Map<String, String> queryParameters}) {
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
builder: (_, state) => MessagesPage(args: ChatArgs.parse(state.extra, queryParameters: state.uri.queryParameters)),
```

Unsure which? Use `.parse()`.

---

## 8. ROUTER (`CLAUDE.md` §5b) — `router/auth_router.dart`

```dart
import 'package:auth/src/presentation/login/bloc/login_bloc.dart';
import 'package:auth/src/presentation/login/login_page.dart';
import 'package:auth/src/presentation/otp_login/otp_login_page.dart';
import 'package:core/core.dart';
import 'package:navigation/navigation.dart';

final class AuthRouter implements AppRouter<RouteBase> {
  const new();

  @override
  List<GoRoute> getRouters(Injector di) => [
    // CupertinoRoute, not GoRoute: this app's MaterialApp comes from package:material_ui, so
    // go_router falls back to NoTransitionPage — no push animation, no iOS swipe-back.
    CupertinoRoute(
      path: Routes.login,
      name: Routes.login,
      builder: (_, _) => BlocProvider<LoginBloc>(create: (_) => di.get(), child: const LoginPage()),
    ),
    CupertinoRoute(
      path: Routes.otpLogin,
      name: Routes.otpLogin,
      builder: (_, state) => OtpLoginPage(args: OtpLoginArgs.parse(state.extra, queryParameters: state.uri.queryParameters)),
    ),
    // bottom sheet — never a hand-written pageBuilder + MaterialSheetPage
    MaterialSheetRoute(
      path: Routes.chooseThemeModeSheet,
      name: Routes.chooseThemeModeSheet,
      builder: (_, _) => const ChooseThemeModeSheet(),
    ),
  ];
}
```

| Destination                                             | Class                                                  |
|---------------------------------------------------------|--------------------------------------------------------|
| normal full-screen page (**the default**)               | `CupertinoRoute`                                       |
| bottom sheet                                            | `MaterialSheetRoute`                                   |
| full page that slides up (viewer, full-screen composer) | `SlideUpTransitionRoute` (add the barrel export first) |
| `StatefulShellRoute` branch root / placeholder route    | plain `GoRoute`                                        |

`pageBuilder:` never appears in a module router — that's what these classes own. Route names live in
`packages/navigation/lib/src/name_routes.dart`; add the constant there, then use it as both `path`
and `name`.

---

## 9. BOTTOM SHEET (`CLAUDE.md` §9) — `presentation/choose_theme_mode_sheet/choose_theme_mode_sheet.dart`

Own top-level folder, never nested inside another feature's folder.

```dart
import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:navigation/navigation.dart';

class ChooseThemeModeSheet extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => SafeAreaWithMinimum(
    minimum: Dimensions.kPaddingAll16,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(context.l10n.chooseThemeMode, textAlign: TextAlign.center, style: context.textTheme.headlineLarge),
        Dimensions.kGap32,
        CustomLoadingButton(onPressed: () => context.pop(ThemeMode.dark), child: Text(context.l10n.darkMode)),
        Dimensions.kGap16,
        CustomLoadingButton(onPressed: () => context.pop(ThemeMode.light), child: Text(context.l10n.lightMode)),
      ],
    ),
  );
}
```

Caller: `final mode = await context.pushNamed<ThemeMode>(Routes.chooseThemeModeSheet);` then
`if (!mounted) return;`. Route name ends in `...Sheet`. Sheet with async state gets its own bloc in
`presentation/<name>_sheet/bloc/`, same rules as §3.

---

## 10. DI (`CLAUDE.md` §15 · `docs/architecture/dependency_injection.md`) — `di/auth_injection.dart`

```dart
import 'package:auth/src/data/datasource/auth_local_data_source.dart';
import 'package:auth/src/data/datasource/auth_remote_data_source.dart';
import 'package:auth/src/data/repo/auth_repo_impl.dart';
import 'package:auth/src/domain/repos/auth_repo.dart';
import 'package:auth/src/domain/usecases/login.dart';
import 'package:auth/src/domain/usecases/otp_login.dart';
import 'package:auth/src/presentation/login/bloc/login_bloc.dart';
import 'package:core/core.dart';

final class AuthInjection implements Injection {
  const new();

  @override
  void registerDependencies({required Injector di}) {
    di
      /// page factories — only if this module exposes a page to another module (§11.1)
      /// data sources
      ..registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(di.get()))
      ..registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(di.get()))
      /// repositories
      ..registerLazySingleton<AuthRepo>(() => AuthRepoImpl(di.get(), di.get()))
      /// usecases
      ..registerLazySingleton(() => Login(di.get()))
      ..registerLazySingleton(() => OtpLogin(di.get()))
      /// interactors
      ..registerLazySingleton<ModuleInteractor<UserSession, NoParams>>(
        () => GetSessionInteractor(di.get()),
        instanceName: InstanceNameKeys.getSessionInteractor,
      )
      /// bloc
      ..registerFactory(() => LoginBloc(di.get()))
      ..registerFactory(() => OtpLoginBloc(di.get()));
  }
}
```

- `registerFactory` → **blocs only**. Everything else is `registerLazySingleton`.
- Anything with an `instanceName` is registered **by its interface type**, never by the concrete class.
- Group comment order: page factories → widget factories → data sources → repositories → usecases →
  interactors → bloc.
- Module container ties injection + router together, and a **new module must be added to
  `packages/merge_dependencies/lib/merge_dependencies.dart`'s `_allContainer`** or nothing loads:

```dart
final class AuthContainer implements ModuleContainer {
  const new();

  @override
  Injection? get injection => const AuthInjection();

  @override
  AppRouter<Object>? get router => const AuthRouter();
}
```

---

## 11. CROSS-MODULE (`CLAUDE.md` §7–8a)

Never add another module's package to your `pubspec.yaml` to reuse something. Pick by what crosses:

| Crossing the boundary                      | Use                      |
|--------------------------------------------|--------------------------|
| a whole page the router navigates to       | `PageFactory`            |
| a widget the consumer embeds in its layout | `WidgetFactory<T>`       |
| an operation/data, no UI                   | `ModuleInteractor<T, P>` |

### 11.1 `PageFactory` — `modules/home/lib/src/home_page_factory.dart` (module root)

```dart
import 'package:core/core.dart';
import 'package:home/src/presentation/main/bloc/home_bloc.dart';
import 'package:home/src/presentation/main/home_page.dart';
import 'package:material_ui/material_ui.dart';

final class HomePageFactory implements PageFactory {
  const new();

  @override
  Widget create(Injector di) => BlocProvider<HomeBloc>(
    lazy: false,
    create: (_) => di.get<HomeBloc>()..add(const GetHomeEvent()),
    child: const HomePage(),
  );
}
```

Consumer: `di.get<PageFactory>(instanceName: InstanceNameKeys.homeFactory).create(di)` — and its
`pubspec.yaml` must not list `home`.

### 11.2 `WidgetFactory<T>` — `presentation/<feature>/factory/task_item_factory.dart`

```dart
import 'package:core/core.dart' show TaskItemArgs, WidgetFactory;
import 'package:material_ui/material_ui.dart';
import 'package:system/src/presentation/reminder/widgets/task_item.dart';

final class TaskItemFactory implements WidgetFactory<TaskItemArgs> {
  const new();

  @override
  Widget create(TaskItemArgs args) => TaskItem(task: args.task, onTap: args.onTap);
}
```

Args class lives in `packages/core/lib/src/entities/` (both modules must be able to name it).
Consumer resolves once into a `late final` field, not inside `build()`.

### 11.3 `ModuleInteractor<T, P>` — `domain/interactor/get_profile_interactor.dart`

```dart
import 'package:core/core.dart' show Either, Failure, ModuleInteractor, NoParams, ProfileUser;
import 'package:profile/src/domain/usecases/get_profile.dart';

final class GetProfileInteractor implements ModuleInteractor<ProfileUser, NoParams> {
  const new(this._getProfile);

  final GetProfile _getProfile;

  @override
  Future<Either<Failure, ProfileUser>> call(NoParams params) => _getProfile();
}
```

Thin adapter over an existing usecase. `T` and `P` must be types the consumer can already see — a
shared type in `packages/core/lib/src/entities/` or a plain Dart type; flatten to
`Map<String, dynamic>` via `Model.fromEntity(x).toMap()` when the entity isn't worth promoting.
Consumer's bloc field is typed as `ModuleInteractor<T, P>` itself.

---

## 12. SELF-CHECK BEFORE SAYING "DONE"

```bash
dart fix --apply && dart format ./ && flutter analyze
```

The mistakes that actually happen, in the order they happen:

| Symptom in the code                                              | Fix                        | Rule       |
|------------------------------------------------------------------|----------------------------|------------|
| `const LoginPage({super.key});` inside `class LoginPage`         | `const new({super.key});`  | §0.1       |
| `import 'package:flutter/material.dart';`                        | `package:material_ui/...`  | §0.2       |
| `GoRoute(` for a real page                                       | `CupertinoRoute(`          | §0.4, §8   |
| `GoRoute(pageBuilder: ... MaterialSheetPage(...))`               | `MaterialSheetRoute(`      | §9         |
| handler named `_onSubmit` / `_homeLoadHandler`                   | `_submitLoginHandler`      | §3.1       |
| `on<CreateXEvent>(h)` with no transformer                        | add `throttle()`           | §3.1       |
| GET event using `throttle()`                                     | `droppable()`              | §3.1       |
| bare `LoadingState` / `SuccessState`                             | `XxxLoadingState`          | §3.3       |
| `setState` inside a `_handleStates` whose builder already reruns | plain mutation             | §4         |
| local toggle mutated without `setState`                          | wrap in `setState`         | §4         |
| `context` used after `await` with no `mounted` check             | `if (!mounted) return;`    | §4         |
| `state.extra! as XArgs` on a chat/payment/form route             | `XArgs.parse(...)`         | §7.2       |
| fabricated fallback entity when `extra` is missing               | delete it, crash instead   | §7         |
| `fromMap` with `?? ''` / `?? 0` on every field                   | `as String?` / `as int?`   | §2.1       |
| `fromMap`/`toMap` on an entity                                   | move to the model          | §1.1, §2.1 |
| endpoint added to a global `ApiPaths`                            | module-local `XxxApiPaths` | §2.2       |
| `MediaQuery.of(context)`                                         | `context.width` etc.       | §5         |
| `Navigator.push` / `Navigator.pop`                               | `context.pushNamed`/`pop`  | §5         |
| hardcoded user-facing string                                     | `context.l10n.<key>`       | §5         |
| `print(...)`                                                     | `logMessage(...)`          | §5         |
| another module's package in `pubspec.yaml` for one usecase       | `ModuleInteractor`         | §11        |
| `registerFactory` for a `PageFactory`                            | `registerLazySingleton`    | §10        |
| new module missing from `_allContainer`                          | register it                | §10        |

Then report: owner module + reason, and the list of touched files.
