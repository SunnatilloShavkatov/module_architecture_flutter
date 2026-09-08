import 'package:flutter_test/flutter_test.dart';
import 'package:notifications/src/data/models/notification_model.dart';
import 'package:notifications/src/domain/entities/notification_entity.dart';

void main() {
  final tTimestamp = DateTime(2024, 6, 1, 12);
  final tModel = NotificationModel(
    id: '1',
    title: 'Title',
    message: 'Message',
    timestamp: tTimestamp,
    isRead: true,
    type: 'general',
  );

  test('NotificationModel is a subclass of NotificationEntity', () {
    expect(tModel, isA<NotificationEntity>());
  });

  test('fromMap parses map correctly', () {
    final map = {
      'id': '1',
      'title': 'Title',
      'message': 'Message',
      'timestamp': tTimestamp.toIso8601String(),
      'isRead': true,
      'type': 'general',
    };

    final result = NotificationModel.fromMap(map);

    expect(result.id, '1');
    expect(result.title, 'Title');
    expect(result.isRead, isTrue);
  });

  test('toMap returns valid map', () {
    final result = tModel.toMap();

    expect(result['id'], '1');
    expect(result['title'], 'Title');
    expect(result['isRead'], isTrue);
  });
}
