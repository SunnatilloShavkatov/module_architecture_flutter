import 'package:core/core.dart';
import 'package:profile/src/domain/repository/profile_repository.dart';

final class GetMoreData extends UsecaseWithoutParams<void> {
  const GetMoreData(this._repo);

  final ProfileRepository _repo;

  @override
  ResultFeatureVoid call() => _repo.getMoreData();
}
