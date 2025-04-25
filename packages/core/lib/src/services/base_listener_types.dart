import 'dart:async';

enum BaseListenerTypes { initial, progressUpdate, purchaseSuccess }

class BaseUpdateListenerData<T> {
  BaseUpdateListenerData({required this.type, required this.object});

  final BaseListenerTypes type;
  final T object;
}

class BaseUpdateListener {
  final StreamController<BaseUpdateListenerData<dynamic>> updateListenerStream =
      StreamController<BaseUpdateListenerData<dynamic>>.broadcast();

  BaseListenerTypes? _lastType;

  void sinkUpdateListener<T>({
    BaseListenerTypes type = BaseListenerTypes.initial,
    T? object,
  }) {
    _lastType = type;
    updateListenerStream.add(BaseUpdateListenerData(type: type, object: object));
  }

  BaseListenerTypes? get lastType => _lastType;
}
