import 'package:dio/dio.dart';
import 'package:dream_dwell/app/constant/api_endpoints.dart';
import 'package:dream_dwell/cores/network/api_service.dart';
import 'package:dream_dwell/features/auth/data/data_source/user_data_source.dart';
import 'package:dream_dwell/features/auth/data/model/user_api_model.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart';

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

      if (response.statusCode == 200) {
        // Assume the response body is a JSON object representing the user
        final userApiModel = UserApiModel.fromJson(response.data);
        return userApiModel.toEntity();
      } else {
        throw Exception("Failed to fetch user: ${response.statusCode} ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch user: ${e.error}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}