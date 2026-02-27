part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();
}

final class ProfileInitialState extends ProfileState {
  const ProfileInitialState();

  @override
  List<Object?> get props => [];
}

final class PackageVersionState extends ProfileState {
  const PackageVersionState({required this.version});

  final PackageInfo version;

  @override
  List<Object?> get props => [version];
}
