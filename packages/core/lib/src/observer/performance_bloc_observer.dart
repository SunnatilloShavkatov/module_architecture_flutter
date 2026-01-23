import 'package:core/src/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Performance monitoring observer for Bloc events.
///
/// Tracks event processing time and logs warnings for slow events.
/// Statistics are stored in-memory with a maximum limit to prevent memory leaks.
///
/// **Environment**: Debug and Profile modes only.
/// **Memory**: Uses LRU eviction to limit statistics storage.
final class PerformanceBlocObserver extends BlocObserver {
  /// Creates a performance observer.
  ///
  /// [slowThresholdMs]: Threshold in milliseconds to consider an event "slow" (default: 100ms)
  /// [maxStatisticsEntries]: Maximum number of statistics entries to keep (default: 1000)
  PerformanceBlocObserver({
    this.slowThresholdMs = _defaultSlowThresholdMs,
    this.maxStatisticsEntries = _defaultMaxStatisticsEntries,
  });

  /// Default threshold for slow events (100ms)
  static const int _defaultSlowThresholdMs = 100;

  /// Default maximum statistics entries (1000)
  static const int _defaultMaxStatisticsEntries = 1000;

  /// Threshold in milliseconds to consider an event "slow"
  final int slowThresholdMs;

  /// Maximum number of statistics entries to keep (LRU eviction)
  final int maxStatisticsEntries;

  /// Statistics storage - instance-based, not global
  final Map<String, List<int>> _statistics = <String, List<int>>{};
  final Map<String, Stopwatch> _eventTimers = <String, Stopwatch>{};

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);

    // Only track in debug/profile mode
    if (kReleaseMode) {
      return;
    }

    final key = '${bloc.hashCode}_${event.hashCode}';
    _eventTimers[key] = Stopwatch()..start();
  }

  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);

    if (kReleaseMode) {
      return;
    }

    final key = '${bloc.hashCode}_${transition.event.hashCode}';
    final stopwatch = _eventTimers.remove(key);

    if (stopwatch != null) {
      stopwatch.stop();
      final ms = stopwatch.elapsedMilliseconds;
      final blocName = '${bloc.runtimeType}_${transition.event.runtimeType}';

      _updateStatistics(blocName, ms);

      if (ms > slowThresholdMs) {
        logMessage('⚠️ [PERF] SLOW | $blocName | ${ms}ms');
      } else {
        logMessage('✓ [PERF] $blocName | ${ms}ms');
      }
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    // Clean up any pending timers for this bloc
    _eventTimers.removeWhere((key, _) => key.startsWith('${bloc.hashCode}_'));
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    // Clean up any pending timers when bloc closes
    _eventTimers.removeWhere((key, _) => key.startsWith('${bloc.hashCode}_'));
    super.onClose(bloc);
  }

  /// Update statistics with LRU eviction
  void _updateStatistics(String blocName, int ms) {
    _statistics.putIfAbsent(blocName, () => <int>[]).add(ms);

    // Evict oldest entry if limit exceeded
    if (_statistics.length > maxStatisticsEntries) {
      final oldestKey = _statistics.keys.first;
      _statistics.remove(oldestKey);
    }
  }

  /// Print performance statistics summary.
  ///
  /// Call this manually from DevTools or during debugging.
  void printStatistics() {
    if (_statistics.isEmpty) {
      logMessage('[PERF] No statistics collected');
      return;
    }

    logMessage('[PERF] ═══ Performance Statistics ═══');
    _statistics.forEach((name, times) {
      final avg = times.reduce((a, b) => a + b) / times.length;
      final max = times.reduce((a, b) => a > b ? a : b);
      final min = times.reduce((a, b) => a < b ? a : b);
      logMessage(
        '[PERF] $name | Avg: ${avg.toStringAsFixed(1)}ms | '
        'Min: ${min}ms | Max: ${max}ms | Count: ${times.length}',
      );
    });
  }

  /// Clear all statistics (useful for testing)
  void clearStatistics() {
    _statistics.clear();
    _eventTimers.clear();
  }
}
