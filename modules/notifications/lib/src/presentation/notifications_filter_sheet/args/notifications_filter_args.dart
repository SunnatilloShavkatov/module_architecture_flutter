import 'package:core/core.dart';
import 'package:navigation/navigation.dart';

/// Input arguments of `Routes.notificationsFilterSheet`.
///
/// Never cast `state.extra` directly — on a deep link or a screen rebuild `extra` is null.
/// Always build the args through `parse()`, which falls back to the query parameters.
final class NotificationsFilterArgs extends Equatable {
  const new({this.selectedFilter = defaultFilter});

  factory parse(Object? extra, {Map<String, String>? queryParameters}) {
    final map = normalizeExtraMap(extra);
    final qp = queryParameters ?? const <String, String>{};

    return NotificationsFilterArgs(
      selectedFilter: map?['selectedFilter'] as String? ?? qp['selectedFilter'] ?? defaultFilter,
    );
  }

  /// Stable, non-translatable filter identifiers — the sheet returns one of these,
  /// the UI label is resolved through l10n at render time.
  static const String all = 'All';
  static const String unread = 'Unread';
  static const String read = 'Read';

  static const String defaultFilter = all;
  static const List<String> availableFilters = [all, unread, read];

  final String selectedFilter;

  Map<String, dynamic> toMap() => {'selectedFilter': selectedFilter};

  @override
  List<Object?> get props => [selectedFilter];
}
