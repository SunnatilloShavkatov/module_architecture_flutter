import 'package:core/src/core_abstractions/injector.dart';

abstract interface class AppRouter<T> {
  const new();

  List<T> getRouters(Injector di);
}
