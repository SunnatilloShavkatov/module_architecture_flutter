import 'package:core/core.dart';
import 'package:navigation/navigation.dart';

final class NotificationDetailArgs extends Equatable {
  const new({required this.id, required this.title, required this.message});

  factory parse(Object? extra, {Map<String, String>? queryParameters}) {
    final map = normalizeExtraMap(extra);
    final qp = queryParameters ?? const <String, String>{};

    return NotificationDetailArgs(
      id: map?['id'] as String? ?? qp['id'] ?? '',
      title: map?['title'] as String? ?? qp['title'] ?? '',
      message: map?['message'] as String? ?? qp['message'] ?? '',
    );
  }

  final String id;
  final String title;
  final String message;

  Map<String, dynamic> toMap() => {'id': id, 'title': title, 'message': message};

  @override
  List<Object?> get props => [id, title, message];
}
