# TEMPLATE REFERENCE (The Architectural Seed)

If this project is empty and you don't have an existing module like `auth` or `referral` to clone, use this file as your absolute **Source of Truth** for syntax and structure. **CLONE THIS EXACTLY** for any new feature. Do NOT invent your own simple representations. Use this exact level of complexity.

---

## 1. DOMAIN LAYER

### Elements (`domain/entities/referral_faq.dart`)
```dart
import 'package:base_dependencies/base_dependencies.dart';

class ReferralFAQ extends Equatable {
  const ReferralFAQ({required this.steps, required this.questions});

  final List<FaqStep> steps;
  final List<FaqStep> questions;

  @override
  List<Object?> get props => [steps, questions];
}

class FaqStep extends Equatable {
  const FaqStep({required this.file, required this.answer, required this.question});

  final String? file;
  final String? answer;
  final String? question;

  @override
  List<Object?> get props => [file, answer, question];
}
```

### Repo Interface (`domain/repository/auth_repository.dart`)
```dart
import 'package:auth/src/domain/entities/check_user_entity.dart' show CheckUserEntity;
import 'package:core/core.dart';

abstract interface class AuthRepository {
  const AuthRepository();

  ResultFuture<CheckUserEntity> checkUser({
    required String identity,
    required String deviceType,
    required String appVersion,
  });
}
```

### Usecase (`domain/usecases/check_user.dart`)
```dart
import 'package:auth/src/domain/entities/check_user_entity.dart' show CheckUserEntity;
import 'package:auth/src/domain/repository/auth_repository.dart';
import 'package:core/core.dart' show ResultFuture, UsecaseWithParams;

class CheckUser extends UsecaseWithParams<CheckUserEntity, CheckUserParams> {
  const CheckUser(this._repo);

  final AuthRepository _repo;

  @override
  ResultFuture<CheckUserEntity> call(CheckUserParams params) =>
      _repo.checkUser(identity: params.identity, deviceType: params.deviceType, appVersion: params.appVersion);
}

final class CheckUserParams {
  const CheckUserParams({required this.identity, required this.deviceType, required this.appVersion});

  final String identity;
  final String deviceType;
  final String appVersion;
}
```

---

## 2. DATA LAYER

### Model (`data/models/referral_faq_model.dart`)
```dart
import 'package:referral/src/domain/entities/referral_faq.dart';

class ReferralFAQModel extends ReferralFAQ {
  const ReferralFAQModel({required super.steps, required super.questions});

  factory ReferralFAQModel.fromMap(Map<String, dynamic> map) {
    final List<FaqStep> steps = [];
    final List<FaqStep> questions = [];
    if (map['steps'] != null && map['steps'] is List) {
      for (final step in map['steps']) {
        steps.add(FaqStepModel.fromMap(step));
      }
    }
    if (map['questions'] != null && map['questions'] is List) {
      for (final question in map['questions']) {
        questions.add(FaqStepModel.fromMap(question));
      }
    }
    return ReferralFAQModel(steps: steps, questions: questions);
  }
}

class FaqStepModel extends FaqStep {
  const FaqStepModel({super.file, super.answer, super.question});

  factory FaqStepModel.fromMap(Map<String, dynamic> map) =>
      FaqStepModel(file: map['file'], answer: map['answer'], question: map['question']);
}
```

### ApiPaths (`data/datasource/auth_api_paths.dart`)
```dart
final class AuthApiPaths {
  const AuthApiPaths._();
  static const String checkPhone = '/student/v1/auth/check-phone';
}
```

### DataSource Abstract (`data/datasource/auth_remote_data_source.dart`)
```dart
import 'package:auth/src/data/datasource/auth_api_paths.dart';
import 'package:auth/src/data/models/check_user_model.dart';
import 'package:core/core.dart';

part 'auth_remote_data_source_impl.dart';

abstract interface class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<CheckUserModel> checkUser({required String identity, required String deviceType, required String appVersion});
}
```

### DataSource Impl (`data/datasource/auth_remote_data_source_impl.dart`)
```dart
part of 'auth_remote_data_source.dart';

final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._networkProvider);

  final NetworkProvider _networkProvider;

  @override
  Future<CheckUserModel> checkUser({
    required String identity,
    required String deviceType,
    required String appVersion,
  }) async {
    try {
      final result = await _networkProvider.fetchMethod<Map<String, dynamic>>(
        AuthApiPaths.checkPhone,
        methodType: RMethodTypes.post,
        data: {'identity': identity, 'app_version': appVersion, 'device_type': deviceType},
      );
      return CheckUserModel.fromMap(result.data ?? {});
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

### Repo Impl (`data/repository/auth_repository_impl.dart`)
```dart
import 'package:auth/src/data/datasource/auth_remote_data_source.dart';
import 'package:auth/src/domain/entities/check_user_entity.dart';
import 'package:auth/src/domain/repository/auth_repository.dart';
import 'package:core/core.dart';

final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteSource);

  final AuthRemoteDataSource _remoteSource;

  @override
  ResultFuture<CheckUserEntity> checkUser({
    required String identity,
    required String deviceType,
    required String appVersion,
  }) async {
    try {
      final result = await _remoteSource.checkUser(identity: identity, deviceType: deviceType, appVersion: appVersion);
      return Right(result);
    } on ServerException catch (e) {
      return Left(e.failure);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
```

---

## 3. PRESENTATION LAYER

### BLoC (`presentation/login/bloc/login_bloc.dart`)
```dart
import 'package:auth/src/domain/entities/login_entity.dart';
import 'package:auth/src/domain/usecases/check_user.dart' show CheckUser, CheckUserParams;
import 'package:auth/src/domain/usecases/login.dart' show Login, LoginParams;
import 'package:base_dependencies/base_dependencies.dart';
import 'package:core/core.dart';
import 'package:platform_methods/platform_methods.dart';

part 'login_event.dart';
part 'login_state.dart';

final class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(
    this._checkUser,
    this._login,
    this._packageInfo,
    this._platformMethods,
    this._deviceInfoFunctions,
  ) : super(const LoginInitialState()) {
    on<LoginInitialEvent>(_initialHandler, transformer: throttle());
    on<CheckUserPressedEvent>(_checkUserHandler, transformer: throttle());
    on<LoginUserPressedEvent>(_phoneNumberPressedHandler, transformer: throttle());
  }

  final Login _login;
  final CheckUser _checkUser;
  final PackageInfo _packageInfo;
  final PlatformMethods _platformMethods;
  final DeviceInfoFunctions _deviceInfoFunctions;

  void _initialHandler(LoginInitialEvent event, Emitter<LoginState> emit) {
    emit(const LoginInitialState());
  }

  Future<void> _checkUserHandler(CheckUserPressedEvent event, Emitter<LoginState> emit) async {
    if (state is LoginLoadingState) return;
    emit(const LoginLoadingState());
    final result = await _checkUser(
      CheckUserParams(identity: event.identity, appVersion: event.appVersion, deviceType: Constants.currentDeviceType),
    );
    result.fold(
      (failure) => emit(CheckUserFailure(message: failure.message)),
      (next) => emit(CheckUserSuccessState(next.next)),
    );
  }

  Future<void> _phoneNumberPressedHandler(LoginUserPressedEvent event, Emitter<LoginState> emit) async {
    if (state is LoginLoadingState) return;
    emit(const LoginLoadingState());
    final fcmToken = await _deviceInfoFunctions.getFCMToken();
    final String? deviceId = await _platformMethods.getDeviceId();
    final deviceInfo = await _deviceInfoFunctions.fetchDeviceInfoJson(deviceId: deviceId);
    final result = await _login(
      LoginParams(
        fcmToken: fcmToken,
        deviceInfo: deviceInfo,
        identity: event.identity,
        password: event.password,
        deviceType: Constants.deviceType,
        packageInfo: _packageInfo.toJson,
      ),
    );
    result.fold(
      (failure) => emit(LoginFailureState(message: failure.message)),
      (login) {
        if ((login.token ?? '').isEmpty) {
          emit(const ProblemHasOccurredState());
        } else {
          emit(LoginSuccessState(login: login));
        }
      },
    );
  }
}
```

### Event & State (`presentation/login/bloc/login_event.dart` & `login_state.dart`)
```dart
// login_event.dart
part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();
}

final class LoginInitialEvent extends LoginEvent {
  const LoginInitialEvent();
  @override
  List<Object?> get props => [];
}

final class LoginUserPressedEvent extends LoginEvent {
  const LoginUserPressedEvent({required this.identity, required this.password});
  final String identity;
  final String password;
  @override
  List<Object?> get props => [identity, password];
}

final class CheckUserPressedEvent extends LoginEvent {
  const CheckUserPressedEvent({required this.identity, required this.appVersion});
  final String identity;
  final String appVersion;
  @override
  List<Object?> get props => [identity, appVersion];
}

// login_state.dart
part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object?> get props => <Object?>[];
}

final class LoginInitialState extends LoginState { const LoginInitialState(); }

sealed class LoadingState extends LoginState { const LoadingState(); }
final class LoginLoadingState extends LoadingState { const LoginLoadingState(); }

sealed class SuccessState extends LoginState { const SuccessState(); }
final class LoginSuccessState extends SuccessState {
  const LoginSuccessState({required this.login});
  final LoginEntity login;
  @override
  List<Object?> get props => [login];
}
final class CheckUserSuccessState extends SuccessState {
  const CheckUserSuccessState(this.next);
  final String next;
  @override
  List<Object?> get props => [next];
}

sealed class FailureState extends LoginState { const FailureState(); }
final class LoginFailureState extends FailureState {
  const LoginFailureState({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
final class CheckUserFailure extends FailureState {
  const CheckUserFailure({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
final class ProblemHasOccurredState extends FailureState { const ProblemHasOccurredState(); }
```

### Mixin (`presentation/login/mixin/login_mixin.dart`)
```dart
// ignore_for_file: discarded_futures, document_ignores
part of '../login_page.dart';

enum LoginStep { checkUser, login }

mixin LoginMixin on State<LoginPage> {
  late LoginStep _step = LoginStep.checkUser;
  late final GlobalKey<FormState> _formKeyIdentity = GlobalKey<FormState>();
  late final GlobalKey<FormState> _formKeyPassword = GlobalKey<FormState>();
  late final TextEditingController _identityController = TextEditingController();
  late final FocusNode _identityFocus = FocusNode();
  late final TextEditingController _passwordController = TextEditingController();
  late final FocusNode _passwordFocus = FocusNode();

  void _handleStates(_, LoginState state) {
    if (state is LoginInitialState) {
      _step = LoginStep.checkUser;
      _passwordController.clear();
    } else if (state is CheckUserSuccessState) {
      if (state.next == LoginStep.login.name) {
        _step = LoginStep.login;
        Future<void>.microtask(_passwordFocus.requestFocus);
      } else {
        showErrorMessage(context, message: context.localizations.userNotFound);
      }
    } else if (state is LoginSuccessState) {
      context.goNamed(Routes.placementStart);
    } else if (state is LoginFailureState || state is CheckUserFailure) {
      showErrorMessage(context, message: (state as dynamic).message);
    } else if (state is ProblemHasOccurredState) {
      showErrorMessage(context, message: context.localizations.problemHasOccurred);
    }
  }

  void _loginPressed() {
    if (_step == LoginStep.checkUser) {
      _checkUser();
    } else {
      _login();
    }
  }

  Future<void> _checkUser() async {
    final packageInfo = await AppInjector.instance.getAsync<PackageInfo>();
    if (!mounted) return;
    if (_formKeyIdentity.currentState!.validate()) {
      bloc.add(CheckUserPressedEvent(identity: _identityController.text.trim(), appVersion: packageInfo.version));
    }
  }

  void _login() {
    if (_formKeyIdentity.currentState!.validate() && _formKeyPassword.currentState!.validate()) {
      _identityFocus.unfocus();
      _passwordFocus.unfocus();
      bloc.add(LoginUserPressedEvent(identity: _identityController.text.trim(), password: _passwordController.text.trim()));
    }
  }

  @override
  void dispose() {
    _identityController.dispose();
    _identityFocus.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  LoginBloc get bloc => context.read<LoginBloc>();
  LocalSource get localSource => AppInjector.instance.get<LocalSource>();
}
```

### Page (`presentation/login/login_page.dart`)
```dart
import 'dart:async';
import 'package:auth/src/domain/entities/login_entity.dart';
import 'package:auth/src/presentation/login/bloc/login_bloc.dart';
import 'package:base_dependencies/base_dependencies.dart';
import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

part 'mixin/login_mixin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with LoginMixin {
  @override
  Widget build(BuildContext context) => BlocListener<LoginBloc, LoginState>(
    listenWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
    listener: _handleStates,
    child: Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        shape: Dimensions.kShapeZero,
        backgroundColor: context.color.bgBrandSecondary,
      ),
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (prev, curr) => curr is CheckUserSuccessState || curr is LoginInitialState,
        builder: (_, state) => Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: Dimensions.kPaddingAll16.copyWith(bottom: context.viewInsets.bottom + 16),
                children: <Widget>[
                  Text(context.localizations.welcome, style: context.textStyle.geistW700x30),
                  Dimensions.kGap24,
                  Form(
                    key: _formKeyIdentity,
                    child: EmailPhoneTextField(
                      focusNode: _identityFocus,
                      controller: _identityController,
                      titleText: context.localizations.emailOrPhoneNumber,
                    ),
                  ),
                  if (_step == LoginStep.login) ...<Widget>[
                    Dimensions.kGap24,
                    Form(
                      key: _formKeyPassword,
                      child: CustomPasswordTextField(
                        focusNode: _passwordFocus,
                        controller: _passwordController,
                        titleText: context.localizations.password,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: SafeAreaWithMinimum(
        minimum: Dimensions.kPaddingAll16,
        child: BlocBuilder<LoginBloc, LoginState>(
          buildWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
          builder: (_, state) => CustomLoadingButton(
            onPressed: _loginPressed,
            isLoading: state is LoadingState,
            child: Text(_step == LoginStep.login ? context.localizations.logIn : context.localizations.continueText),
          ),
        ),
      ),
    ),
  );
}
```

---

## 4. DI INJECTION (`auth_injection.dart`)
```dart
import 'package:auth/src/data/datasource/auth_remote_data_source.dart';
import 'package:auth/src/data/repository/auth_repository_impl.dart';
import 'package:auth/src/domain/repository/auth_repository.dart';
import 'package:auth/src/domain/usecases/check_user.dart' show CheckUser;
import 'package:auth/src/presentation/login/bloc/login_bloc.dart';
import 'package:core/core.dart';

final class AuthInjection implements Injection {
  const AuthInjection();

  @override
  void registerDependencies({required Injector di}) {
    di
      /// data sources
      ..registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(di.get()))
      /// repositories
      ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(di.get()))
      /// use cases
      ..registerLazySingleton<CheckUser>(() => CheckUser(di.get()))
      /// bloc
      ..registerFactory(() => LoginBloc(di.get(), di.get(), di.get(), di.get(), di.get(), di.get()));
  }
}
```

---

## 5. ROUTER (`auth_router.dart`)
```dart
import 'package:auth/src/presentation/login/bloc/login_bloc.dart';
import 'package:auth/src/presentation/login/login_page.dart';
import 'package:core/core.dart';
import 'package:navigation/navigation.dart';

final class AuthRouter implements AppRouter<RouteBase> {
  const AuthRouter();

  @override
  List<GoRoute> getRouters(Injector di) => [
    GoRoute(
      path: Routes.login,
      name: Routes.login,
      builder: (_, _) => BlocProvider<LoginBloc>(create: (_) => di.get(), child: const LoginPage()),
    ),
  ];
}
```
