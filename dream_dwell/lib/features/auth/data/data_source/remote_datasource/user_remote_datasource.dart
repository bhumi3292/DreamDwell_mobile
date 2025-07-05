import 'package:dio/dio.dart';
import 'package:dream_dwell/app/constant/api_endpoints.dart';
import 'package:dream_dwell/cores/network/api_service.dart';
import 'package:dream_dwell/features/auth/data/data_source/user_data_source.dart';
import 'package:dream_dwell/features/auth/data/model/user_api_model.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart';
import 'dart:io';

class UserRemoteDatasource implements IUserDataSource {
  final ApiService _apiService;

  UserRemoteDatasource({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<void> registerUser(UserEntity user) async {
    try {
      final model = UserApiModel.fromEntity(user);
      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: model.toJson(),
      );
      if (response.statusCode != 201) {
        throw Exception('Registration failed with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to register user: ${e.error}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<String> loginUser(String email, String password, String stakeholder) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {
          "email": email,
          "password": password,
          "stakeholder": stakeholder,
        },
      );
      if (response.statusCode == 200) {
        final token = response.data['token'];
        if (token == null || (token as String).isEmpty) {
          throw Exception("Login successful but no token was received.");
        }
        return token;
      } else {
        throw Exception("Login failed: ${response.statusCode} ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception('Failed to login: ${e.error}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.getCurrentUser);
      print('DEBUG: Full Response from /auth/me: ${response.data}');
      print('DEBUG: Type of response.data: ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        // ⭐⭐ PRIMARY FIX HERE: Access the nested 'user' object ⭐⭐
        // Based on your backend's loginUser, it nests the user under 'user' key.
        // Assuming /auth/me does the same.
        if (response.data is Map<String, dynamic> && response.data.containsKey('user')) {
          final userApiModel = UserApiModel.fromJson(response.data['user']);
          return userApiModel.toEntity();
        } else {
          // Fallback if 'user' key is not present (e.g., if backend sends user directly)
          // This should ideally not be hit if backend is consistent.
          final userApiModel = UserApiModel.fromJson(response.data);
          return userApiModel.toEntity();
        }
      } else {
        throw Exception("Failed to fetch user: ${response.statusCode} ${response.statusMessage}");
      }
    } on DioException catch (e) {
      print('DEBUG ERROR: DioException in getCurrentUser: ${e.response?.data ?? e.message}');
      throw Exception('Failed to fetch user: ${e.error}');
    } catch (e) {
      print('DEBUG ERROR: Unexpected error in getCurrentUser: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<String> uploadProfilePicture(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "profilePicture": await MultipartFile.fromFile(imageFile.path, filename: fileName),
      });

      final response = await _apiService.dio.post(
        ApiEndpoints.uploadProfilePicture,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming backend returns new URL under 'profilePictureUrl' or similar
        return response.data['profilePictureUrl'] as String;
      } else {
        throw Exception("Failed to upload profile picture: ${response.statusCode} ${response.statusMessage}");
      }
    } on DioException catch (e) {
      print('DEBUG ERROR: DioException in uploadProfilePicture: ${e.response?.data ?? e.message}');
      throw Exception('Failed to upload profile picture: ${e.error}');
    } catch (e) {
      print('DEBUG ERROR: Unexpected error in uploadProfilePicture: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}