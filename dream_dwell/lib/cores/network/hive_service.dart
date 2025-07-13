// lib/cores/network/hive_service.dart

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dream_dwell/app/constant/hive_table_const.dart';
import 'package:dream_dwell/features/auth/data/model/user_hive_model.dart';
import 'package:dream_dwell/features/add_property/data/model/property_model/property_hive_model.dart';
import 'package:dream_dwell/features/add_property/data/model/category_model/category_hive_model.dart';

class HiveService {
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/dream_dwell.db';
    Hive.init(path);

    if (!Hive.isAdapterRegistered(HiveTableConstant.userTableId)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.propertyTableId)) {
      Hive.registerAdapter(PropertyHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.categoryTableId)) {
      Hive.registerAdapter(CategoryHiveModelAdapter());
    }
  }

  // --- User/Auth Methods (No change needed) ---
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

  // Get current authenticated user
  Future<UserHiveModel?> getCurrentUser() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      return null;
    }
    
    // For now, we'll get the first user as the current user
    // In a real app, you'd decode the JWT token to get the user ID
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    try {
      if (box.isNotEmpty) {
        final currentUser = box.values.first;
        await box.close();
        return currentUser;
      }
      await box.close();
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      await box.close();
      return null;
    }
  }


  //=================================== Property Methods======================================
  Future<void> addProperty(PropertyHiveModel property) async {
    final box = await Hive.openBox<PropertyHiveModel>(HiveTableConstant.propertyBox);
    await box.put(property.id, property);
    await box.close();
  }

  Future<List<PropertyHiveModel>> getAllProperties() async {
    final box = await Hive.openBox<PropertyHiveModel>(HiveTableConstant.propertyBox);
    final properties = box.values.toList();
    await box.close();
    return properties;
  }

  //  Use PropertyHiveModel here
  Future<void> updateProperty(PropertyHiveModel property) async {
    final box = await Hive.openBox<PropertyHiveModel>(HiveTableConstant.propertyBox);
    await box.put(property.id, property); // Hive's put acts as upsert
    await box.close();
  }

  //  Use PropertyHiveModel here
  Future<PropertyHiveModel?> getPropertyById(String propertyId) async {
    final box = await Hive.openBox<PropertyHiveModel>(HiveTableConstant.propertyBox);
    final property = box.get(propertyId);
    await box.close();
    return property;
  }

  //  Use PropertyHiveModel
  Future<void> deletePropertyById(String propertyId) async {
    final box = await Hive.openBox<PropertyHiveModel>(HiveTableConstant.propertyBox);
    await box.delete(propertyId);
    await box.close();
  }

  //================================ Category Methods (No change needed)===========================================================================
  Future<void> addCategory(CategoryHiveModel category) async {
    final box = await Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryBox);
    await box.put(category.id, category); // Assuming 'id' is the unique key
    await box.close();
  }

  Future<List<CategoryHiveModel>> getAllCategories() async {
    final box = await Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryBox);
    final categories = box.values.toList();
    await box.close();
    return categories;
  }

  Future<void> updateCategory(CategoryHiveModel category) async {
    final box = await Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryBox);
    await box.put(category.id, category);
    await box.close();
  }

  Future<void> deleteCategoryById(String categoryId) async {
    final box = await Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryBox);
    await box.delete(categoryId);
    await box.close();
  }

  // --- Clear Methods (MODIFIED) ⭐ ---
  @override
  Future<void> clearAll() async {
    final userBox = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await userBox.clear();
    await userBox.close();

    // Use PropertyHiveModel here
    final propertyBox = await Hive.openBox<PropertyHiveModel>(HiveTableConstant.propertyBox);
    await propertyBox.clear();
    await propertyBox.close();

    final categoryBox = await Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryBox);
    await categoryBox.clear();
    await categoryBox.close();

    print('HiveService: All relevant data boxes cleared.');
  }

  // Modified clearUserData to call the comprehensive clearAll
  @override
  Future<void> clearUserData() async {
    await deleteToken();
    print('HiveService: Auth token deleted.');
    await clearAll(); // This now clears all data, not just user box
  }

  Future<void> close() async {
    await Hive.close();
  }
}