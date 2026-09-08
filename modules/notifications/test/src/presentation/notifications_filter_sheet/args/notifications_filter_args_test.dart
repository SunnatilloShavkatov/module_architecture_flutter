import 'package:flutter_test/flutter_test.dart';
import 'package:notifications/src/presentation/notifications_filter_sheet/args/notifications_filter_args.dart';

void main() {
  test('parse reads selectedFilter from extra map', () {
    final args = NotificationsFilterArgs.parse(const {'selectedFilter': 'Unread'});

    expect(args.selectedFilter, 'Unread');
  });

  test('parse falls back to query parameters when extra is null', () {
    final args = NotificationsFilterArgs.parse(null, queryParameters: const {'selectedFilter': 'Read'});

    expect(args.selectedFilter, 'Read');
  });

  test('parse returns the default filter when nothing is provided', () {
    final args = NotificationsFilterArgs.parse(null);

    expect(args.selectedFilter, NotificationsFilterArgs.defaultFilter);
    expect(NotificationsFilterArgs.availableFilters, ['All', 'Unread', 'Read']);
  });

  test('toMap round-trips through parse', () {
    const original = NotificationsFilterArgs(selectedFilter: 'Unread');

    expect(NotificationsFilterArgs.parse(original.toMap()), original);
  });
}
