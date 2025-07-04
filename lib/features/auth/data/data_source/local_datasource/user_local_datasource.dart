import 'package:dream_dwell/cores/network/hive_service.dart';
import 'package:dream_dwell/features/auth/data/data_source/user_data_source.dart';
import 'package:dream_dwell/features/auth/data/model/user_hive_model.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart';

class UserLocalDatasource implements IUserDataSource {
  final HiveService _hiveService;

  UserLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<String> loginUser(String email, String password, String stakeholder) async {
    try {
      final user = await _hiveService.loginUser(email, password);
      if (user != null && user.password == password ) {
        return "Login successful";
      } else {
        throw Exception("Invalid email, password, or stakeholder");
      }
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  @override
  Future<void> registerUser(UserEntity user) async {
    try {
      final userHiveModel = UserHiveModel.fromEntity(user);
      await _hiveService.registerUser(userHiveModel);
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    try {
      final users = await _hiveService.getAllUsers();
      if (users.isNotEmpty) {
        return users.first.toEntity();
      } else {
        throw Exception("No current user found locally.");
      }
    } catch (e) {
      throw Exception("Failed to get current user: $e");
    }
  }
}
