import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dream_dwell/app/constant/hive_table_const.dart';
import 'package:dream_dwell/features/auth/data/model/user_hive_model.dart';

class HiveService {
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    // Specifies the path for the Hive database files.
    final path = '${directory.path}/dream_dwell.db';

    Hive.init(path);
    // Register the UserHiveModelAdapter if it hasn't been registered yet.
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }
  }

  // ========== Authentication Token Management Methods ==========

  Future<void> saveToken(String token) async {
    // Open the Hive box dedicated for user data or tokens.
    // Using HiveTableConstant.userBox is a common practice if
    // tokens are tied to user sessions.
    final box = await Hive.openBox<String>(HiveTableConstant.userBox);
    await box.put('authToken', token); // Store the token
    await box.close();
  }

  /// Retrieves the authentication token from the Hive box.
  /// Returns `null` if no token is found.
  Future<String?> getToken() async {
    final box = await Hive.openBox<String>(HiveTableConstant.userBox);
    final token = box.get('authToken'); // Retrieve the token
    await box.close();
    return token;
  }

  /// Deletes the stored authentication token from the Hive box.
  /// This should typically be called during logout.
  Future<void> deleteToken() async {
    final box = await Hive.openBox<String>(HiveTableConstant.userBox);
    await box.delete('authToken'); // Remove the token
    await box.close();
  }

  // ========== Existing User Data Management Methods ==========

  Future<void> registerUser(UserHiveModel user) async {
    print(user);
    print("call hive register");
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.put(user.userId, user); // Store user data with userId as key
    await box.close();
  }


  Future<UserHiveModel?> loginUser(String email, String password) async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    try {
      print("All users in box:");
      for (var user in box.values) {
        print(user); // Assumes UserHiveModel has a useful toString()
      }

      // Find the first user that matches both email and password.
      final customer = box.values.firstWhere(
            (element) => element.email == email && element.password == password,
        // If no element satisfies the test, a StateError is thrown.
        // You could use orElse: () => null if you prefer not to throw.
      );

      print("Login success: $customer");
      return customer;
    } catch (e) {
      print("Login error: $e"); // Log any error during the search/login process
      return null;
    } finally {
      await box.close(); // Ensure the box is closed
    }
  }

  Future<List<UserHiveModel>> getAllUsers() async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    final users = box.values.toList(); // Get all values as a list
    await box.close();
    return users;
  }

  Future<void> deleteUser(String userId) async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.delete(userId);
    await box.close();
  }

  Future<void> clearAll() async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.clear();
    await box.close();
  }

  Future<void> close() async {
    await Hive.close();
  }
}
