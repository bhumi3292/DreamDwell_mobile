import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dream_dwell/app/constant/hive_table_const.dart';
import 'package:dream_dwell/features/auth/data/model/user_hive_model.dart';

class HiveService {
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/dream_dwell.db';
  }

  // Register user
  Future<void> registerUser(UserHiveModel user) async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.put(user.userId, user);
    await box.close();
  }

  // Login user
  Future<UserHiveModel?> loginUser(String email, String password) async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    try {
      final user = box.values.firstWhere(
            (u) => u.email == email && u.password == password,
      );
      await box.close();
      return user;
    } catch (e) {
      await box.close();
      return null;
    }
  }

  // Get all users
  Future<List<UserHiveModel>> getAllUsers() async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    final users = box.values.toList();
    await box.close();
    return users;
  }

  // Delete user by ID
  Future<void> deleteUser(String userId) async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.delete(userId);
    await box.close();
  }

  // Clear all Hive data
  Future<void> clearAll() async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.clear();
    await box.close();
  }

  // Close Hive manually
  Future<void> close() async {
    await Hive.close();
  }
}
