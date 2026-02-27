import 'package:core/core.dart';

part 'profile_remote_data_source_impl.dart';

abstract interface class ProfileRemoteDataSource {
  const ProfileRemoteDataSource();

  ResultVoid getMoreData();
}
