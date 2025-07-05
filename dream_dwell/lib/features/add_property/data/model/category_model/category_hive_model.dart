import 'package:hive/hive.dart';
import 'package:dream_dwell/features/add_property/domain/entity/category/category_entity.dart';

part 'category_hive_model.g.dart';

@HiveType(typeId: 0)
class CategoryHiveModel extends CategoryEntity {
  @HiveField(0)
  final String id_;
  @HiveField(1)
  final String name_;

  const CategoryHiveModel({
    required this.id_,
    required this.name_,
  }) : super(categoryId: id_, categoryName: name_);

  factory CategoryHiveModel.fromEntity(CategoryEntity entity) {
    return CategoryHiveModel(
      id_: entity.categoryId,
      name_: entity.categoryName,
    );
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      categoryId: id_,
      categoryName: name_,
    );
  }
}