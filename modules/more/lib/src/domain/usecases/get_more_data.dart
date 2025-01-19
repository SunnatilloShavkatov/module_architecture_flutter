import 'package:core/core.dart';
import 'package:more/src/domain/repository/more_repository.dart';

final class GetMoreData extends UsecaseWithoutParams<void> {
  const GetMoreData(this._repo);

  final MoreRepository _repo;

  @override
  ResultFeatureVoid call() => _repo.getMoreData();
}
