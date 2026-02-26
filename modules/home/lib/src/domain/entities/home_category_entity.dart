import 'package:core/core.dart' show Equatable;

class HomeCategoryEntity extends Equatable {
  const HomeCategoryEntity({required this.id, required this.name, required this.slug, this.icon});

  final int id;
  final String name;
  final String slug;
  final String? icon;

  @override
  List<Object?> get props => [id, name, slug, icon];
}
