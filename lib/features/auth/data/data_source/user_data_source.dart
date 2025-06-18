import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart';

/// Defines the contract for user-related data operations at the data source level.
/// This interface abstracts how user data is fetched, stored, or updated,
/// irrespective of whether it's from a local database or a remote API.
abstract interface class IUserDataSource {
  /// Registers a new user.
  /// Throws an exception on failure.
  Future<void> registerUser(UserEntity userData);

  /// Attempts to log in a user.
  /// Returns a success message string on success.
  /// Throws an exception on failure (e.g., invalid credentials).
  Future<String> loginUser(String email, String password, String stakeholder);

  /// Retrieves the current user's entity.
  /// Throws an exception if no user is found or an error occurs.
  Future<UserEntity> getCurrentUser();
}