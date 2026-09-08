import 'package:core/core.dart';
import 'package:navigation/navigation.dart';
import 'package:profile/src/domain/entities/profile_user_entity.dart';

/// Input arguments of `Routes.editProfile`.
///
/// Never cast `state.extra` directly — on a deep link or a screen rebuild `extra` is null.
/// Always build the args through `parse()`, which accepts the typed instance, a plain map
/// and the query parameters.
final class EditProfileArgs extends Equatable {
  const new({required this.user});

  factory parse(Object? extra, {Map<String, String>? queryParameters}) {
    if (extra is EditProfileArgs) {
      return extra;
    }
    final map = normalizeExtraMap(extra);
    final qp = queryParameters ?? const <String, String>{};

    return EditProfileArgs(
      user: ProfileUserEntity(
        id: toNullableInt(map?['id'] ?? qp['id']) ?? 0,
        email: map?['email'] as String? ?? qp['email'] ?? '',
        firstName: map?['firstName'] as String? ?? qp['firstName'] ?? '',
        lastName: map?['lastName'] as String? ?? qp['lastName'] ?? '',
        role: map?['role'] as String? ?? qp['role'] ?? '',
        phone: map?['phone'] as String? ?? qp['phone'],
        username: map?['username'] as String? ?? qp['username'],
        specialization: map?['specialization'] as String? ?? qp['specialization'],
      ),
    );
  }

  final ProfileUserEntity user;

  Map<String, dynamic> toMap() => {
    'id': user.id,
    'email': user.email,
    'firstName': user.firstName,
    'lastName': user.lastName,
    'role': user.role,
    'phone': user.phone,
    'username': user.username,
    'specialization': user.specialization,
  };

  @override
  List<Object?> get props => [user];
}
