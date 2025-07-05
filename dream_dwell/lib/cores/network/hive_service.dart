import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dream_dwell/app/constant/hive_table_const.dart';
import 'package:dream_dwell/features/auth/data/model/user_hive_model.dart';

class HiveService {
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/dream_dwell.db';
    Hive.init(path);
    if (!Hive.isAdapterRegistered(HiveTableConstant.userTableId)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }
  }

  Future<void> saveToken(String token) async {
    final box = await Hive.openBox<String>(HiveTableConstant.userBox);
    await box.put('authToken', token);
    await box.close();
  }

  Future<String?> getToken() async {
    final box = await Hive.openBox<String>(HiveTableConstant.userBox);
    final token = box.get('authToken');
    await box.close();
    return token;
  }

  Future<void> deleteToken() async {
    final box = await Hive.openBox<String>(HiveTableConstant.userBox);
    await box.delete('authToken');
    await box.close();
  }

  Future<void> registerUser(UserHiveModel user) async {
    print(user);
    print("call hive register");
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.put(user.userId, user);
    await box.close();
  }

  Future<UserHiveModel?> loginUser(String email, String password) async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    try {
      print("All users in box:");
      for (var user in box.values) {
        print(user);
      }
      final customer = box.values.firstWhere(
            (element) => element.email == email && element.password == password,
      );
      print("Login success: $customer");
      return customer;
    } catch (e) {
      print("Login error: $e");
      return null;
    } finally {
      await box.close();
    }
  }

  Future<List<UserHiveModel>> getAllUsers() async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    final users = box.values.toList();
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
    print('HiveService: User data box cleared.');
  }

  Future<void> clearUserData() async {
    await deleteToken();
    print('HiveService: Auth token deleted.');
    await clearAll();
  }

  Future<void> close() async {
    await Hive.close();
  }
}