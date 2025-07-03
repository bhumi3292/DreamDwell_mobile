import 'package:equatable/equatable.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart'; // Assuming your UserEntity path

/// Represents the state of the user profile view.
class ProfileState extends Equatable {
  final bool isLoading;
  final UserEntity? user; // The fetched user data
  final String? errorMessage;
  final String? successMessage;
  final bool isLogoutSuccess;

  const ProfileState({
    this.isLoading = false,
    this.user,
    this.errorMessage,
    this.successMessage,
    this.isLogoutSuccess = false,
  });

  /// Initial state when the profile page is first loaded.
  const ProfileState.initial()
      : isLoading = false,
        user = null,
        errorMessage = null,
        successMessage = null,
        isLogoutSuccess = false;

  /// Creates a copy of the current state with specified changes.
  ProfileState copyWith({
    bool? isLoading,
    UserEntity? user,
    String? errorMessage, // Make nullable for clearing
    String? successMessage, // Make nullable for clearing
    bool? isLogoutSuccess,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      // Use null to explicitly clear messages, otherwise keep existing
      errorMessage: errorMessage,
      successMessage: successMessage,
      isLogoutSuccess: isLogoutSuccess ?? this.isLogoutSuccess,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    user,
    errorMessage,
    successMessage,
    isLogoutSuccess,
  ];
}
