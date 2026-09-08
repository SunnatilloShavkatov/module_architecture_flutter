import 'package:notifications/src/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const new({
    required super.id,
    required super.title,
    required super.message,
    required super.timestamp,
    required super.isRead,
    required super.type,
    super.timeAgo,
  });

  factory fromMap(Map<String, dynamic> map) => NotificationModel(
    id: '${map['id'] ?? ''}',
    title: map['title'] as String? ?? '',
    message: map['message'] as String? ?? '',
    timestamp: DateTime.tryParse(map['timestamp']?.toString() ?? '') ?? DateTime.now(),
    isRead: map['isRead'] as bool? ?? false,
    type: map['type'] as String? ?? 'info',
    timeAgo: map['timeAgo'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'message': message,
    'timestamp': timestamp.toIso8601String(),
    'isRead': isRead,
    'type': type,
    'timeAgo': timeAgo,
  };
}
