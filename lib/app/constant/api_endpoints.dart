class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String serverAddress = "http://10.0.2.2:3001";

  // CORRECTED: Changed from "/api/v1/" to "/api/" to match backend routing
  static const String baseUrl = "$serverAddress/api/";
  static const String imageUrl = "$serverAddress/uploads/";

  // ---------- Auth ----------
  static const String register = "${baseUrl}auth/register";
  static const String login = "${baseUrl}auth/login";
  static const String getCurrentUser = "${baseUrl}auth/me";

  // ---------- User ----------
  static const String updateUser = "${baseUrl}user/update/";
  static const String deleteUser = "${baseUrl}user/delete/";

  // ---------- Profile ----------
  static const String uploadProfilePicture = "${baseUrl}auth/uploadImage";
}