import 'package:core/core.dart';

part 'more_remote_data_source_impl.dart';

abstract interface class MoreRemoteDataSource {
  const MoreRemoteDataSource();

  ResultVoid getMoreData();
}
