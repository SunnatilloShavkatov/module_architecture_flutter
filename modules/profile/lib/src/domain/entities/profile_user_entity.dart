import 'package:core/core.dart' show Equatable;

class ProfileUserEntity extends Equatable {
  const ProfileUserEntity({required this.firstName, required this.phone});

  final String firstName;
  final String phone;

  @override
  List<Object?> get props => [firstName, phone];
}
