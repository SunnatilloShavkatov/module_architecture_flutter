import 'package:core/core.dart' show Equatable;

class ProfileUserEntity extends Equatable {
  const ProfileUserEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.phone,
    this.username,
    this.specialization,
  });

  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String? phone;
  final String? username;
  final String? specialization;

  @override
  List<Object?> get props => [id, email, firstName, lastName, role, phone, username, specialization];
}
