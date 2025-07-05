class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // IMPORTANT: Use your actual server IP or domain.
  // For Android emulator, 'http://10.0.2.2:3001' is common.
  // For iOS simulator/physical device, use your machine's local IP (e.g., 'http://192.168.1.X:3001').
  static const String serverAddress = "http://10.0.2.2:3001";

  static const String baseUrl = "$serverAddress/api/";
  static const String imageUrl = "$serverAddress/uploads/"; // For serving uploaded images

  // ---------- Auth ----------
  static const String register = "${baseUrl}auth/register";
  static const String login = "${baseUrl}auth/login";
  static const String getCurrentUser = "${baseUrl}auth/me"; // Endpoint to get current user profile

  // ---------- User ----------
  static const String updateUser = "${baseUrl}user/update/";
  static const String deleteUser = "${baseUrl}user/delete/";

  // ---------- Profile ----------
  // Ensure your backend has this endpoint for profile picture upload
  // Based on your backend, this might be a separate route like '/upload/profile-picture'
  static const String uploadProfilePicture = "${baseUrl}auth/uploadImage"; // Assuming this is the correct endpoint
}