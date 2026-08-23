part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const new();

  @override
  List<Object?> get props => <Object?>[];
}

final class ProfileInitialState extends ProfileState {
  const new();
}

sealed class LoadingState extends ProfileState {
  const new();
}

final class ProfileLoadingState extends LoadingState {
  const new();
}

final class ProfileUpdatingState extends LoadingState {
  const new();
}

sealed class SuccessState extends ProfileState {
  const new();
}

final class ProfileSuccessState extends SuccessState {
  const new({required this.user, required this.version});

  final ProfileUserEntity user;
  final PackageInfo version;

  @override
  List<Object?> get props => [user, version];
}

final class ProfileUpdatedState extends SuccessState {
  const new({required this.user, required this.version});

  final ProfileUserEntity user;
  final PackageInfo version;

  @override
  List<Object?> get props => [user, version];
}

sealed class FailureState extends ProfileState {
  const new();
}

final class ProfileFailureState extends FailureState {
  const new({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
