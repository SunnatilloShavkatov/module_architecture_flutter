part of 'home_local_data_source.dart';

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  const HomeLocalDataSourceImpl(this._localSource);

  final LocalSource _localSource;

  @override
  String? get locale => _localSource.locale;

  @override
  String get firstName => _localSource.firstName;
}
