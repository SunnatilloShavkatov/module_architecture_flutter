import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart' show DebounceExtensions, FlatMapExtension, ThrottleExtensions;

// Custom transformer using RxDart to debounce events
EventTransformer<Event> throttle<Event>({Duration duration = const Duration(seconds: 1)}) =>
    (events, mapper) => events.throttleTime(duration, trailing: false).flatMap(mapper);

// Custom transformer using RxDart to debounce events
EventTransformer<Event> debounce<Event>({
  Duration duration = const Duration(seconds: 1),
  required bool Function() isBlocClosed,
}) =>
    (events, mapper) => events.debounceTime(duration).asyncExpand((event) async* {
      if (!isBlocClosed()) {
        yield* mapper(event);
      }
    });

/// Process only one event and ignore (drop) any new events
/// until the current event is done.
///
/// **Note**: dropped events never trigger the event handler.
EventTransformer<Event> droppable<Event>() =>
    (events, mapper) => events.transform(_ExhaustMapStreamTransformer(mapper));

class _ExhaustMapStreamTransformer<T> extends StreamTransformerBase<T, T> {
  _ExhaustMapStreamTransformer(this.mapper);

  final EventMapper<T> mapper;

  @override
  Stream<T> bind(Stream<T> stream) {
    late StreamSubscription<T> subscription;
    StreamSubscription<T>? mappedSubscription;

    final controller = StreamController<T>(
      onCancel: () async {
        await mappedSubscription?.cancel();
        return subscription.cancel();
      },
      sync: true,
    );

    subscription = stream.listen(
      (data) {
        if (mappedSubscription != null) {
          return;
        }
        final Stream<T> mappedStream;

        mappedStream = mapper(data);
        mappedSubscription = mappedStream.listen(
          controller.add,
          onError: controller.addError,
          onDone: () => mappedSubscription = null,
        );
      },
      onError: controller.addError,
      onDone: () => mappedSubscription ?? controller.close(),
    );

    return controller.stream;
  }
}
