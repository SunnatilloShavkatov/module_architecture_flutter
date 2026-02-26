import 'package:core/core.dart';
import 'package:home/src/domain/entities/home_category_entity.dart';
import 'package:home/src/domain/repository/home_repo.dart';

final class GetHomeCategories extends UsecaseWithoutParams<List<HomeCategoryEntity>> {
  const GetHomeCategories(this._repo);

  final HomeRepo _repo;

  @override
  ResultFuture<List<HomeCategoryEntity>> call() => _repo.getCategories();
}
