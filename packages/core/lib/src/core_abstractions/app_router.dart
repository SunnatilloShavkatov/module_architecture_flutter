import 'package:core/src/core_abstractions/injector.dart';

abstract interface class AppRouter<T> {
  const AppRouter();

  List<T> getRouters(Injector di);
}
