part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const new();
}

final class ProfileInitialEvent extends ProfileEvent {
  const new();

  @override
  List<Object?> get props => [];
}

final class UpdateProfilePressedEvent extends ProfileEvent {
  const new({
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
