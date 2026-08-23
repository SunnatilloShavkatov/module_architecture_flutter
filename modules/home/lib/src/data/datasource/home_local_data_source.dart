import 'package:core/core.dart';

part 'home_local_data_source_impl.dart';

abstract interface class HomeLocalDataSource {
  const new();

  String? get locale;

  String get firstName;
}
