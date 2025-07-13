// lib/features/add_property/data/data_source/remote_datasource/category_remote_datasource.dart

import 'package:dio/dio.dart';
import 'package:dream_dwell/features/add_property/data/data_source/category/category_data_source.dart';
import 'package:dream_dwell/features/add_property/domain/entity/category/category_entity.dart'; // Domain entity

import 'package:dream_dwell/features/add_property/data/model/category_model/category_api_model.dart';

class CategoryRemoteDatasource implements ICategoryDataSource {
  final Dio _dio;

  CategoryRemoteDatasource({required Dio dio}) : _dio = dio;

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      final response = await _dio.get('/categories');
      
      print('Category API Response: ${response.data}');
      print('Response type: ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        // Handle the response structure: { success: true, data: [...] }
        final responseData = response.data;
        if (responseData is Map<String, dynamic> && responseData['success'] == true) {
          final List<dynamic> jsonList = responseData['data'];
          print('Categories from data field: $jsonList');
          return jsonList.map((json) {
            print('Processing category JSON: $json');
            return CategoryApiModel.fromJson(json).toEntity();
          }).toList();
        } else if (responseData is List) {
          // Fallback for direct array response
          print('Categories as direct array: $responseData');
          return responseData.map((json) {
            print('Processing category JSON: $json');
            return CategoryApiModel.fromJson(json).toEntity();
          }).toList();
        } else {
          throw Exception('Invalid response format: ${response.data}');
        }
      } else {
        throw Exception('Failed to get categories: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      print('DioException in getCategories: ${e.response?.data ?? e.message}');
      throw Exception('Failed to get categories (Dio Error): ${e.response?.data ?? e.message}');
    } catch (e) {
      print('Exception in getCategories: $e');
      throw Exception('Failed to get categories: $e');
    }
  }

  @override
  Future<void> addCategory(CategoryEntity category) async {
    try {
      final categoryApiModel = CategoryApiModel.fromEntity(category);
      final requestData = categoryApiModel.toJson();
      print('Adding category with data: $requestData');
      
      final response = await _dio.post(
        '/categories',
        data: requestData,
      );

      print('Add category response: ${response.data}');
      print('Response status: ${response.statusCode}');

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Failed to add category: ${response.statusCode} - ${response.data}');
      }
      print('Category added successfully: ${response.data}');
    } on DioException catch (e) {
      print('DioException in addCategory: ${e.response?.data ?? e.message}');
      throw Exception('Failed to add category (Dio Error): ${e.response?.data ?? e.message}');
    } catch (e) {
      print('Exception in addCategory: $e');
      throw Exception('Failed to add category: $e');
    }
  }

  @override
  Future<void> updateCategory(CategoryEntity category) async {
    try {
      if (category.id == null) {
        throw Exception('Category ID cannot be null for update operation.');
      }
      final updatedCategoryApiModel = CategoryApiModel.fromEntity(category);
      final response = await _dio.put(
        '/categories/${category.id}', // API endpoint for updating by ID
        data: updatedCategoryApiModel.toJson(), // Use API model's toJson()
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update category: ${response.statusCode} - ${response.data}');
      }
      print('Category updated successfully: ${response.data}');
    } on DioException catch (e) {
      throw Exception('Failed to update category (Dio Error): ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    try {
      final response = await _dio.delete('/categories/$categoryId'); // API endpoint for deleting by ID

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete category: ${response.statusCode} - ${response.data}');
      }
      print('Category with ID $categoryId deleted successfully.');
    } on DioException catch (e) {
      throw Exception('Failed to delete category (Dio Error): ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }
}