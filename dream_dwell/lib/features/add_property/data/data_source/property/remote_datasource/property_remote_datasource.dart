// lib/features/add_property/data/data_source/remote_datasource/property_remote_datasource.dart

import 'package:dio/dio.dart';
import 'dart:io'; // For File
import 'package:dream_dwell/features/add_property/data/data_source/property/property_data_source.dart';
import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart';
import 'package:dream_dwell/app/constant/api_endpoints.dart';

class PropertyRemoteDatasource implements IPropertyDataSource {
  final Dio _dio;

  PropertyRemoteDatasource({required Dio dio}) : _dio = dio;

  // Helper method to create FormData for property and files
  Future<FormData> _createPropertyFormData(
      PropertyEntity property,
      List<String> imagePaths,
      List<String> videoPaths,
      ) async {
    // Create form data with property fields - match web API format
    final formData = FormData.fromMap({
      'title': property.title ?? '',
      'description': property.description ?? '',
      'location': property.location ?? '',
      'price': property.price?.toString() ?? '',
      'categoryId': property.categoryId ?? '',
      'bedrooms': property.bedrooms?.toString() ?? '',
      'bathrooms': property.bathrooms?.toString() ?? '',
      // Only add landlordId if it's not null
      if (property.landlordId != null) 'landlordId': property.landlordId!,
    });

    // Append images
    for (int i = 0; i < imagePaths.length; i++) {
      final path = imagePaths[i];
      if (path.isNotEmpty && File(path).existsSync()) {
        final file = File(path);
        final fileName = path.split('/').last;
        formData.files.add(MapEntry(
          "images",
          await MultipartFile.fromFile(
            path,
            filename: fileName,
            contentType: DioMediaType('image', 'jpeg'), // Adjust based on file type
          ),
        ));
      }
    }

    // Append videos
    for (int i = 0; i < videoPaths.length; i++) {
      final path = videoPaths[i];
      if (path.isNotEmpty && File(path).existsSync()) {
        final file = File(path);
        final fileName = path.split('/').last;
        formData.files.add(MapEntry(
          "videos",
          await MultipartFile.fromFile(
            path,
            filename: fileName,
            contentType: DioMediaType('video', 'mp4'), // Adjust based on file type
          ),
        ));
      }
    }
    
    return formData;
  }

  @override
  Future<void> addProperty(PropertyEntity property, List<String> imagePaths, List<String> videoPaths) async {
    try {
      print('=== ADD PROPERTY API CALL ===');
      // Validate required fields
      if (property.title == null || property.title!.isEmpty) {
        throw Exception('Property title is required');
      }
      if (property.location == null || property.location!.isEmpty) {
        throw Exception('Property location is required');
      }
      if (property.price == null || property.price! <= 0) {
        throw Exception('Property price is required and must be greater than 0');
      }
      if (property.categoryId == null || property.categoryId!.isEmpty) {
        throw Exception('Property category is required');
      }
      // Note: landlordId is optional - backend will handle this

      final formData = await _createPropertyFormData(property, imagePaths, videoPaths);
      
      print('Sending property data to: ${ApiEndpoints.createProperty}');
      print('Form data fields: ${formData.fields}');
      print('Form data files: ${formData.files.length} files');

      final response = await _dio.post(
        ApiEndpoints.createProperty,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Failed to add property: ${response.statusCode} - ${response.data}');
      }
      
      print('Property added successfully: ${response.data}');
      print('=== END ADD PROPERTY API CALL ===');
    } on DioException catch (e) {
      print('DioException in addProperty: ${e.message}');
      print('DioException type: ${e.type}');
      print('DioException response: ${e.response?.data}');
      print('DioException status: ${e.response?.statusCode}');
      
      String errorMessage = 'Failed to add property';
      
      if (e.response?.data != null && e.response!.data is Map) {
        final data = e.response!.data as Map;
        errorMessage = data['message'] ?? errorMessage;
      } else if (e.message != null) {
        errorMessage = e.message!;
      }
      
      throw Exception(errorMessage);
    } catch (e) {
      print('General exception in addProperty: $e');
      throw Exception('Failed to add property: $e');
    }
  }

  @override
  Future<List<PropertyEntity>> getProperties() async {
    try {
      final response = await _dio.get(ApiEndpoints.getAllProperties);
      
      if (response.statusCode != 200) {
        throw Exception('Failed to get properties: ${response.statusCode}');
      }

      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => PropertyEntity.fromJson(json)).toList();
    } on DioException catch (e) {
      print('DioException in getProperties: ${e.message}');
      String errorMessage = 'Failed to get properties';
      
      if (e.response?.data != null && e.response!.data is Map) {
        final data = e.response!.data as Map;
        errorMessage = data['message'] ?? errorMessage;
      }
      
      throw Exception(errorMessage);
    } catch (e) {
      print('General exception in getProperties: $e');
      throw Exception('Failed to get properties: $e');
    }
  }

  @override
  Future<PropertyEntity> getPropertyById(String propertyId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.getPropertyById}$propertyId');
      
      if (response.statusCode != 200) {
        throw Exception('Failed to get property: ${response.statusCode}');
      }

      final data = response.data['data'] ?? response.data;
      return PropertyEntity.fromJson(data);
    } on DioException catch (e) {
      print('DioException in getPropertyById: ${e.message}');
      String errorMessage = 'Failed to get property';
      
      if (e.response?.data != null && e.response!.data is Map) {
        final data = e.response!.data as Map;
        errorMessage = data['message'] ?? errorMessage;
      }
      
      throw Exception(errorMessage);
    } catch (e) {
      print('General exception in getPropertyById: $e');
      throw Exception('Failed to get property: $e');
    }
  }

  @override
  Future<void> updateProperty(String propertyId, PropertyEntity property, List<String> newImagePaths, List<String> newVideoPaths) async {
    try {
      final formData = await _createPropertyFormData(property, newImagePaths, newVideoPaths);
      
      final response = await _dio.put(
        '${ApiEndpoints.updateProperty}$propertyId',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update property: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException in updateProperty: ${e.message}');
      String errorMessage = 'Failed to update property';
      
      if (e.response?.data != null && e.response!.data is Map) {
        final data = e.response!.data as Map;
        errorMessage = data['message'] ?? errorMessage;
      }
      
      throw Exception(errorMessage);
    } catch (e) {
      print('General exception in updateProperty: $e');
      throw Exception('Failed to update property: $e');
    }
  }

  @override
  Future<void> deleteProperty(String propertyId) async {
    try {
      final response = await _dio.delete('${ApiEndpoints.deleteProperty}$propertyId');
      
      if (response.statusCode != 200) {
        throw Exception('Failed to delete property: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException in deleteProperty: ${e.message}');
      String errorMessage = 'Failed to delete property';
      
      if (e.response?.data != null && e.response!.data is Map) {
        final data = e.response!.data as Map;
        errorMessage = data['message'] ?? errorMessage;
      }
      
      throw Exception(errorMessage);
    } catch (e) {
      print('General exception in deleteProperty: $e');
      throw Exception('Failed to delete property: $e');
    }
  }
}