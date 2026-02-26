import 'package:home/src/domain/entities/home_category_entity.dart';

class HomeCategoryModel extends HomeCategoryEntity {
  const HomeCategoryModel({required super.id, required super.name, required super.slug, super.icon});

  factory HomeCategoryModel.fromMap(Map<String, dynamic> map) =>
      HomeCategoryModel(id: map['id'] ?? 0, name: map['name'] ?? '', slug: map['slug'] ?? '', icon: map['icon']);

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'slug': slug, 'icon': icon};
}
