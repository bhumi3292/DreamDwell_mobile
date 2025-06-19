import 'package:dream_dwell/cores/network/hive_service.dart';
import 'package:dream_dwell/features/auth/data/model/user_hive_model.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart';
import 'package:dream_dwell/features/auth/data/data_source/user_data_source.dart'; // Assuming this is `IUserDataSource`

/// Implements the [IUserDataSource] interface for local data operations using Hive.
class UserLocalDatasource implements IUserDataSource {
  final HiveService _hiveService;

  /// Constructor with dependency injection for [HiveService].
  UserLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<void> registerUser(UserEntity user) async {
    // Convert domain entity to Hive model
    final userHiveModel = UserHiveModel.fromEntity(user);
    await _hiveService.registerUser(userHiveModel);
  }

  @override
  Future<String> loginUser(
      String email, String password, String stakeholder) async {
    final user = await _hiveService.loginUser(email, password);
    // Check if user exists and if credentials/stakeholder match
    if (user != null && user.stakeholder == stakeholder) {
      return "Login successful";
    }
    // If no user or mismatch, throw an exception
    throw Exception("Invalid credentials or stakeholder type.");
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    // In a local-only setup without explicit session management,
    // we can return the first user found or throw if no users exist.
    // In a real application, you might store the ID of the logged-in user
    // in another Hive box or shared preferences.
    final users = await _hiveService.getAllUsers();
    if (users.isNotEmpty) {
      return users.first.toEntity(); // Convert Hive model back to domain entity
    }
    throw Exception("No current user found locally. Please log in.");
  }
}