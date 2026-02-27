import 'package:core/core.dart';

abstract interface class ProfileRepository {
  const ProfileRepository();

  ResultFuture<void> getMoreData();
}
