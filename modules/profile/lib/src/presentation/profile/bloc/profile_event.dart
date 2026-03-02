part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();
}

final class ProfileInitialEvent extends ProfileEvent {
  const ProfileInitialEvent();

  @override
  List<Object?> get props => [];
}

final class UpdateProfilePressedEvent extends ProfileEvent {
  const UpdateProfilePressedEvent({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.specialization,
  });

  final String username;
  final String firstName;
  final String lastName;
  final String phone;
  final String specialization;

  @override
  List<Object?> get props => [username, firstName, lastName, phone, specialization];
}
