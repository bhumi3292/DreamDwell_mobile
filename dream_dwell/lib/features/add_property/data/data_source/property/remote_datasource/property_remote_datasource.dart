// lib/features/add_property/data/data_source/remote_datasource/property_remote_datasource.dart


import 'package:dio/dio.dart';
import 'dart:io'; // For File
import 'package:dream_dwell/features/add_property/data/data_source/property/property_data_source.dart';
import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart';


class PropertyRemoteDatasource implements IPropertyDataSource {
  final Dio _dio;
  // You might have a base URL here or configure it in your Dio instance
  // For example: final String _baseUrl = 'http://your-api-base-url.com/api/v1';

  PropertyRemoteDatasource({required Dio dio}) : _dio = dio;

  // Helper method to create FormData for property and files
  Future<FormData> _createPropertyFormData(
      PropertyEntity property,
      List<String> imagePaths,
      List<String> videoPaths,
      ) async {
    final formData = FormData.fromMap(property.toJson()); // Use toJson from PropertyEntity

    // Append images
    for (String path in imagePaths) {
      if (path.isNotEmpty && File(path).existsSync()) {
        formData.files.add(MapEntry(
          "images", // This key must match your backend's expected field name for images (e.g., an array of files)
          await MultipartFile.fromFile(path, filename: path.split('/').last),
        ));
      }
    }

    // Append videos
    for (String path in videoPaths) {
      if (path.isNotEmpty && File(path).existsSync()) {
        formData.files.add(MapEntry(
          "videos", // This key must match your backend's expected field name for videos
          await MultipartFile.fromFile(path, filename: path.split('/').last),
        ));
      }
    }
    return formData;
  }


  @override
  Future<void> addProperty(PropertyEntity property, List<String> imagePaths, List<String> videoPaths) async {
    try {
      final formData = await _createPropertyFormData(property, imagePaths, videoPaths);
      final response = await _dio.post(
        '/properties', // Your API endpoint for adding properties
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data', // Essential for file uploads
            // Add authorization token if needed:
            // 'Authorization': 'Bearer YOUR_AUTH_TOKEN',
          },
        ),
      );

      if (response.statusCode != 201) { // 201 Created is typical for successful POST
        throw Exception('Failed to add property: ${response.statusCode} - ${response.data}');
      }
      // Optionally, process response data if your API returns the created property
      print('Property added successfully: ${response.data}');
    } on DioException catch (e) {
      throw Exception('Failed to add property (Dio Error): ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Failed to add property: $e');
    }
  }

  @override
  Future<List<PropertyEntity>> getProperties() async {
    try {
      final response = await _dio.get('/properties'); // Your API endpoint for getting all properties

      if (response.statusCode == 200) {
        // Handle the API response structure where properties are wrapped in a 'data' array
        final responseData = response.data;
        List<dynamic> jsonList;
        
        if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
          // API returns { success: true, message: "...", data: [...] }
          jsonList = responseData['data'] as List<dynamic>;
        } else if (responseData is List) {
          // API returns direct array
          jsonList = responseData;
        } else {
          throw Exception('Unexpected response format: ${response.data}');
        }
        
        return jsonList.map((json) => PropertyEntity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get properties: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to get properties (Dio Error): ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Failed to get properties: $e');
    }
  }

  @override
  Future<PropertyEntity> getPropertyById(String propertyId) async {
    try {
      final response = await _dio.get('/properties/$propertyId'); // API endpoint for getting property by ID

      if (response.statusCode == 200) {
        return PropertyEntity.fromJson(response.data);
      } else if (response.statusCode == 404) {
        throw Exception('Property with ID $propertyId not found.');
      } else {
        throw Exception('Failed to get property by ID: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to get property by ID (Dio Error): ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Failed to get property by ID: $e');
    }
  }

  @override
  Future<void> updateProperty(String propertyId, PropertyEntity property, List<String> newImagePaths, List<String> newVideoPaths) async {
    try {
      // For updates, you might want to differentiate between existing files (sent as URLs)
      // and new files (sent as MultipartFile). This example assumes you're sending
      // the complete list of current files (URLs if existing, and new files as MultipartFile).
      // Backend should handle file replacement/addition based on this.

      // If your backend expects a specific format for update (e.g., PATCH with only changed fields,
      // or a full PUT with all fields and then separate file upload endpoints),
      // you'll need to adjust this. This assumes a PUT with a full FormData payload.

      final formData = await _createPropertyFormData(property, newImagePaths, newVideoPaths);

      final response = await _dio.put(
        '/properties/$propertyId', // API endpoint for updating a property
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            // 'Authorization': 'Bearer YOUR_AUTH_TOKEN',
          },
        ),
      );

      if (response.statusCode != 200) { // 200 OK is typical for successful PUT
        throw Exception('Failed to update property: ${response.statusCode} - ${response.data}');
      }
      print('Property updated successfully: ${response.data}');
    } on DioException catch (e) {
      throw Exception('Failed to update property (Dio Error): ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Failed to update property: $e');
    }
  }

  @override
  Future<void> deleteProperty(String propertyId) async {
    try {
      final response = await _dio.delete('/properties/$propertyId'); // API endpoint for deleting property by ID

      if (response.statusCode != 200 && response.statusCode != 204) { // 200 OK or 204 No Content
        throw Exception('Failed to delete property: ${response.statusCode} - ${response.data}');
      }
      print('Property with ID $propertyId deleted successfully.');
    } on DioException catch (e) {
      throw Exception('Failed to delete property (Dio Error): ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Failed to delete property: $e');
    }
  }
}