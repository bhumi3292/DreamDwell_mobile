class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);

  // Base URLs (use 10.0.2.2 for Android emulator)
  static const String serverAddress = "http://10.0.2.2:3000";

  static const String baseUrl = "$serverAddress/api/v1/";
  static const String imageUrl = "$serverAddress/uploads/";

  // ---------- Auth ----------
  static const String register = "auth/register";
  static const String login = "auth/login";
  static const String getCurrentUser = "auth/me";

  // ---------- User ----------
  static const String updateUser = "user/update/";
  static const String deleteUser = "user/delete/";

  // ---------- Profile ----------
  static const String uploadProfilePicture = "auth/uploadImage";

// ---------- Future Property Routes (For Scaling) ----------
// static const String createProperty = "property/create";
// static const String getAllProperties = "property";
// static const String updateProperty = "property/update/";
// static const String deleteProperty = "property/delete/";
}
