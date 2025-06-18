import 'package:dream_dwell/cores/network/hive_service.dart';
import 'package:dream_dwell/features/auth/data/model/user_hive_model.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart';
import 'package:dream_dwell/features/auth/data/data_source/user_data_source.dart';

class UserLocalDatasource implements IUserDataSource {
  final HiveService _hiveService;

  UserLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<void> registerUser(UserEntity user) async {
    final userHiveModel = UserHiveModel.fromEntity(user);
    await _hiveService.registerUser(userHiveModel);
  }

  @override
  Future<String> loginUser(String email, String password, String stakeholder) async {
    final user = await _hiveService.loginUser(email, password);
    if (user != null &&
        user.password == password &&
        user.stakeholder == stakeholder) {
      return "Login successful";
    }
    throw Exception("Invalid credentials or stakeholder.");
  }

  @override
  Future<UserEntity> getCurrentUser() {
    throw UnimplementedError();
  }
}
