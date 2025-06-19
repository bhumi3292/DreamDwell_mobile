import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dream_dwell/app/constant/hive_table_const.dart';
import 'package:dream_dwell/features/auth/data/model/user_hive_model.dart';

class HiveService {
  /// Initialize Hive and register adapters
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/dream_dwell.db'; // Add a DB filename for clarity

    Hive.init(path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }
  }

  /// Register a new user
  Future<void> registerUser(UserHiveModel user) async {
    print(user);
    print("call hive register");
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.put(user.userId, user);
    await box.close();
  }

  /// Login user by matching email and password
  Future<UserHiveModel?> loginUser(String email, String password) async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    try {
      // Print all users in the box
      print("All users in box:");
      for (var user in box.values) {
        print(user); // This assumes your User model has a toString() method
      }

      // Try to find the matching user
      final customer = box.values.firstWhere(
            (element) => element.email == email && element.password == password,
        // orElse: () => null, // Prevents exception if not found
      );

      if (customer != null) {
        print("Login success: $customer");
        return customer;
      } else {
        print("Login failed: Invalid email or password");
        return null;
      }
    } catch (e) {
      print("Login error: $e");
      return null;
    } finally {
      await box.close();
    }

  }

  /// Get all users
  Future<List<UserHiveModel>> getAllUsers() async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    final users = box.values.toList();
    await box.close();
    return users;
  }

  /// Delete a user by ID
  Future<void> deleteUser(String userId) async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.delete(userId);
    await box.close();
  }

  /// Clear all users from the Hive box
  Future<void> clearAll() async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.clear();
    await box.close();
  }

  /// Close Hive instance
  Future<void> close() async {
    await Hive.close();
  }
}
