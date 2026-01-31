part of 'extension.dart';

/// Flutter extensions for boxes.
extension BoxX<T> on Box<T> {
  ValueListenable<Box<T>> listenable({List<String>? keys}) => _BoxListenable(this, keys?.toSet());
}

/// Flutter extensions for lazy boxes.
extension LazyBoxX<T> on LazyBox<T> {
  ValueListenable<LazyBox<T>> listenable({List<String>? keys}) => _BoxListenable(this, keys?.toSet());
}

class _BoxListenable<B extends BoxBase<dynamic>> extends ValueListenable<B> {
  _BoxListenable(this.box, this.keys);

  final B box;

  final Set<String>? keys;

  final List<VoidCallback> _listeners = <VoidCallback>[];

  StreamSubscription<BoxEvent>? _subscription;

  @override
  void addListener(VoidCallback listener) {
    if (_listeners.isEmpty) {
      if (keys != null) {
        _subscription = box.watch().listen((BoxEvent event) {
          if (keys!.contains(event.key)) {
            for (final VoidCallback listener in _listeners) {
              listener();
            }
          }
        });
      } else {
        _subscription = box.watch().listen((_) {
          for (final VoidCallback listener in _listeners) {
            listener();
          }
        });
      }
    }

    _listeners.add(listener);
  }

  @override
  Future<void> removeListener(VoidCallback listener) async {
    _listeners.remove(listener);

    if (_listeners.isEmpty) {
      await _subscription?.cancel();
      _subscription = null;
    }
  }

  @override
  B get value => box;
}
