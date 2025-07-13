import 'package:flutter_test/flutter_test.dart';
import 'package:dream_dwell/app/constant/api_endpoints.dart';

void main() {
  group('API Endpoints Configuration Tests', () {
    testWidgets('API endpoints are correctly configured', (WidgetTester tester) async {
      // Test that the base URL is properly constructed
      expect(ApiEndpoints.baseUrl, contains('http://'));
      expect(ApiEndpoints.baseUrl, contains('/api/'));
      
      // Test that image URL is properly constructed
      expect(ApiEndpoints.imageUrl, contains('http://'));
      expect(ApiEndpoints.imageUrl, contains('/uploads/'));
    });

    testWidgets('Auth endpoints are properly formatted', (WidgetTester tester) async {
      // Test register endpoint
      expect(ApiEndpoints.register, contains('/api/auth/register'));
      
      // Test login endpoint
      expect(ApiEndpoints.login, contains('/api/auth/login'));
      
      // Test get current user endpoint
      expect(ApiEndpoints.getCurrentUser, contains('/api/auth/me'));
    });

    testWidgets('Property endpoints are properly formatted', (WidgetTester tester) async {
      // Test create property endpoint
      expect(ApiEndpoints.createProperty, contains('/api/properties'));
      
      // Test get all properties endpoint
      expect(ApiEndpoints.getAllProperties, contains('/api/properties'));
      
      // Test get property by ID endpoint (should end with /)
      expect(ApiEndpoints.getPropertyById, contains('/api/properties/'));
      
      // Test update property endpoint (should end with /)
      expect(ApiEndpoints.updateProperty, contains('/api/properties/'));
      
      // Test delete property endpoint (should end with /)
      expect(ApiEndpoints.deleteProperty, contains('/api/properties/'));
    });

    testWidgets('Category endpoints are properly formatted', (WidgetTester tester) async {
      // Test create category endpoint
      expect(ApiEndpoints.createCategory, contains('/api/categories'));
      
      // Test get all categories endpoint
      expect(ApiEndpoints.getAllCategories, contains('/api/categories'));
      
      // Test get category by ID endpoint (should end with /)
      expect(ApiEndpoints.getCategoryById, contains('/api/categories/'));
      
      // Test update category endpoint (should end with /)
      expect(ApiEndpoints.updateCategory, contains('/api/categories/'));
      
      // Test delete category endpoint (should end with /)
      expect(ApiEndpoints.deleteCategory, contains('/api/categories/'));
    });

    testWidgets('User endpoints are properly formatted', (WidgetTester tester) async {
      // Test update user endpoint (should end with /)
      expect(ApiEndpoints.updateUser, contains('/api/user/update/'));
      
      // Test delete user endpoint (should end with /)
      expect(ApiEndpoints.deleteUser, contains('/api/user/delete/'));
    });

    testWidgets('Profile endpoints are properly formatted', (WidgetTester tester) async {
      // Test upload profile picture endpoint
      expect(ApiEndpoints.uploadProfilePicture, contains('/api/auth/uploadImage'));
    });

    testWidgets('Timeout configurations are reasonable', (WidgetTester tester) async {
      // Test that connection timeout is reasonable (not too short, not too long)
      expect(ApiEndpoints.connectionTimeout.inSeconds, greaterThan(10));
      expect(ApiEndpoints.connectionTimeout.inSeconds, lessThan(60));
      
      // Test that receive timeout is reasonable
      expect(ApiEndpoints.receiveTimeout.inSeconds, greaterThan(10));
      expect(ApiEndpoints.receiveTimeout.inSeconds, lessThan(60));
    });

    testWidgets('Server addresses are valid URLs', (WidgetTester tester) async {
      // Test that server addresses are valid URLs
      expect(ApiEndpoints.androidEmulatorAddress, startsWith('http://'));
      expect(ApiEndpoints.iosSimulatorAddress, startsWith('http://'));
      expect(ApiEndpoints.localNetworkAddress, startsWith('http://'));
      
      // Test that they contain port numbers
      expect(ApiEndpoints.androidEmulatorAddress, contains(':3001'));
      expect(ApiEndpoints.iosSimulatorAddress, contains(':3001'));
      expect(ApiEndpoints.localNetworkAddress, contains(':3001'));
    });
  });
} 