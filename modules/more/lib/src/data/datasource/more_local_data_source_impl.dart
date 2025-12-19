// ignore_for_file: unused_field

import 'package:core/core.dart';

part 'more_local_data_source.dart';

class MoreLocalDataSourceImpl implements MoreLocalDataSource {
  const MoreLocalDataSourceImpl(this._localSource);

  final LocalSource _localSource;
}
