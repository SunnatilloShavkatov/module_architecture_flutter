import 'package:core/core.dart' show Equatable;

class NotificationEntity extends Equatable {
  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isRead,
    required this.type,
    this.timeAgo,
  });

  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String type;
  final String? timeAgo;

  @override
  List<Object?> get props => [id, title, message, timestamp, isRead, type, timeAgo];
}
