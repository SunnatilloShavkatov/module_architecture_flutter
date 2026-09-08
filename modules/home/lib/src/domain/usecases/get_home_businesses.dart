import 'package:core/core.dart';
import 'package:home/src/domain/entities/home_business_entity.dart';
import 'package:home/src/domain/repository/home_repository.dart';

class GetHomeBusinesses extends UsecaseWithoutParams<List<HomeBusinessEntity>> {
  const new(this._repo);

  final HomeRepository _repo;

  @override
  ResultFuture<List<HomeBusinessEntity>> call() => _repo.getBusinesses();
}
