import 'package:core/core.dart';
import 'package:home/src/domain/entities/home_business_entity.dart';
import 'package:home/src/domain/repository/home_repo.dart';

final class GetHomeBusinesses extends UsecaseWithoutParams<List<HomeBusinessEntity>> {
  const GetHomeBusinesses(this._repo);

  final HomeRepo _repo;

  @override
  ResultFuture<List<HomeBusinessEntity>> call() => _repo.getBusinesses();
}
