part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => <Object?>[];
}

final class ProfileInitialState extends ProfileState {
  const ProfileInitialState();
}

sealed class LoadingState extends ProfileState {
  const LoadingState();
}

final class ProfileLoadingState extends LoadingState {
  const ProfileLoadingState();
}

sealed class SuccessState extends ProfileState {
  const SuccessState();
}

final class ProfileSuccessState extends SuccessState {
  const ProfileSuccessState({required this.user, required this.version});

  final ProfileUserEntity user;
  final PackageInfo version;

  @override
  List<Object?> get props => [user, version];
}

sealed class FailureState extends ProfileState {
  const FailureState();
}

final class ProfileFailureState extends FailureState {
  const ProfileFailureState({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
