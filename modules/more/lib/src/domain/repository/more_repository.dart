import 'package:core/core.dart';
import 'package:more/src/data/datasource/local/more_local_data_source_impl.dart';
import 'package:more/src/data/datasource/remote/more_remote_data_source.dart';

part 'package:more/src/data/repository/more_repository_impl.dart';

abstract class MoreRepository {
  const MoreRepository();

  ResultFuture<void> getMoreData();
}
