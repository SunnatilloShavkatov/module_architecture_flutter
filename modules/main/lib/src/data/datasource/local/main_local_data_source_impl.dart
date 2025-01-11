import "package:core/core.dart";

part "main_local_data_source.dart";

class MainLocalDataSourceImpl implements MainLocalDataSource {
  MainLocalDataSourceImpl(this.localSource);

  final LocalSource localSource;
}
