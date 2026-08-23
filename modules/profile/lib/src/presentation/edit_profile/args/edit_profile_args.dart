import 'package:profile/src/domain/entities/profile_user_entity.dart';

final class EditProfileArgs {
  const new({required this.user});

  final ProfileUserEntity user;
}
