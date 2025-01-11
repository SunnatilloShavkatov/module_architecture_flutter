import "package:core/core.dart";

part "more_local_data_source.dart";

class MoreLocalDataSourceImpl implements MoreLocalDataSource {
  MoreLocalDataSourceImpl(this.localSource);

  final LocalSource localSource;
}
