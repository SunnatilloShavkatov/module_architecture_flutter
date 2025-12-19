import 'package:core/core.dart';

abstract interface class MoreRepository {
  const MoreRepository();

  ResultFuture<void> getMoreData();
}
