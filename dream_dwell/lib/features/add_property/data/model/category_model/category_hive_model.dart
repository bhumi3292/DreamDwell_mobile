import 'package:dream_dwell/features/add_property/domain/entity/category/category_entity.dart';
import 'package:hive/hive.dart';

part 'category_hive_model.g.dart'; // Don't forget to run `flutter pub run build_runner build`

@HiveType(typeId: 2) // Ensure this typeId is unique across all your Hive models
class CategoryHiveModel extends CategoryEntity {
  @override
  @HiveField(0)
  final String? id; // Matches CategoryEntity.id (nullable)

  @override
  @HiveField(1)
  final String categoryName; // Matches CategoryEntity.categoryName (non-nullable)

  @override
  @HiveField(2)
  final DateTime? createdAt; // Matches CategoryEntity.createdAt (nullable)

  @override
  @HiveField(3)
  final DateTime? updatedAt; // Matches CategoryEntity.updatedAt (nullable)


  const CategoryHiveModel({
    this.id, // Nullable
    required this.categoryName, // Required
    this.createdAt, // Nullable
    this.updatedAt, // Nullable
  }) : super(
    id: id,
    categoryName: categoryName,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  // Factory constructor to create a CategoryHiveModel from a CategoryEntity
  factory CategoryHiveModel.fromEntity(CategoryEntity entity) {
    return CategoryHiveModel(
      id: entity.id,
      categoryName: entity.categoryName,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // Method to convert a CategoryHiveModel back to a CategoryEntity
  @override // Override the toEntity method if it exists in a base class, or just define it
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      categoryName: categoryName,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}