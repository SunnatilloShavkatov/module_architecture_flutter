import 'package:core/core.dart';
import 'package:home/src/domain/entities/home_category_entity.dart';
import 'package:home/src/domain/repository/home_repository.dart';

class GetHomeCategories extends UsecaseWithoutParams<List<HomeCategoryEntity>> {
  const new(this._repo);

  final HomeRepository _repo;

  @override
  ResultFuture<List<HomeCategoryEntity>> call() => _repo.getCategories();
}
