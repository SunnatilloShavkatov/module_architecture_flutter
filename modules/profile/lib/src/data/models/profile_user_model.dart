import 'package:profile/src/domain/entities/profile_user_entity.dart';

class ProfileUserModel extends ProfileUserEntity {
  const ProfileUserModel({required super.firstName, required super.phone});

  factory ProfileUserModel.fromMap(Map<String, dynamic> map) =>
      ProfileUserModel(firstName: map['firstName'] ?? '', phone: map['phone'] ?? '');

  Map<String, dynamic> toMap() => {'firstName': firstName, 'phone': phone};
}
