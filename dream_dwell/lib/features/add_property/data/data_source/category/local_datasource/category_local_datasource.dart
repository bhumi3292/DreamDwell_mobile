// lib/features/add_property/data/data_source/local_datasource/category_local_datasource.dart

import 'package:dream_dwell/cores/network/hive_service.dart';
import 'package:dream_dwell/features/add_property/data/data_source/category/category_data_source.dart'; // The interface
import 'package:dream_dwell/features/add_property/domain/entity/category/category_entity.dart'; // Domain entity
import 'package:dream_dwell/features/add_property/data/model/category_model/category_hive_model.dart'; // Hive model

class CategoryLocalDatasource implements ICategoryDataSource {
  final HiveService hiveService;

  CategoryLocalDatasource({required this.hiveService});

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      // Retrieve List<CategoryHiveModel> from HiveService
      final categoryHiveModels = await hiveService.getAllCategories();
      // Convert the list of Hive models to a list of domain entities
      final categories = categoryHiveModels.map((model) => model.toEntity()).toList();
      return categories;
    } catch (e) {
      throw Exception('Failed to get categories locally: $e');
    }
  }

  @override
  Future<void> addCategory(CategoryEntity category) async {
    try {
      // Convert domain entity to Hive model before storing
      final categoryHiveModel = CategoryHiveModel.fromEntity(category);
      await hiveService.addCategory(categoryHiveModel);
    } catch (e) {
      throw Exception('Failed to add category locally: $e');
    }
  }

  @override
  Future<void> updateCategory(CategoryEntity category) async {
    try {
      // Convert domain entity to Hive model before updating
      final updatedCategoryHiveModel = CategoryHiveModel.fromEntity(category);
      await hiveService.updateCategory(updatedCategoryHiveModel);
    } catch (e) {
      throw Exception('Failed to update category locally: $e');
    }
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    try {
      await hiveService.deleteCategoryById(categoryId);
    } catch (e) {
      throw Exception('Failed to delete category locally: $e');
    }
  }
}