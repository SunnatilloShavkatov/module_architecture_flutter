import 'package:notifications/src/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.timestamp,
    required super.isRead,
    required super.type,
    super.timeAgo,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) => NotificationModel(
    id: '${map['id'] ?? ''}',
    title: map['title'] ?? '',
    message: map['message'] ?? '',
    timestamp: DateTime.tryParse(map['timestamp']?.toString() ?? '') ?? DateTime.now(),
    isRead: map['isRead'] ?? false,
    type: map['type'] ?? 'info',
    timeAgo: map['timeAgo'],
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
