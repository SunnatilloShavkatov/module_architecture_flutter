part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();
}

final class ProfileInitialEvent extends ProfileEvent {
  const ProfileInitialEvent();

  @override
  List<Object?> get props => [];
}
