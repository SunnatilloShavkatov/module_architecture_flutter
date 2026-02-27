part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();
}

final class GetPackageVersionEvent extends ProfileEvent {
  const GetPackageVersionEvent();

  @override
  List<Object?> get props => [];
}
