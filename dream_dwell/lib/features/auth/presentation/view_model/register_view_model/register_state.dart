// features/auth/presentation/view_model/register_view_model/register_state.dart
import 'package:equatable/equatable.dart';

class RegisterUserState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? imageName; // Existing field
  final String? errorMessage; // New: to convey specific error messages
  final String? successMessage; // New: to convey specific success messages

  const RegisterUserState({
    this.isLoading = false, // Set default for convenience
    this.isSuccess = false, // Set default for convenience
    this.imageName,
    this.errorMessage,
    this.successMessage,
  });

  // Updated initial constructor to use defaults
  const RegisterUserState.initial()
      : isLoading = false,
        isSuccess = false,
        imageName = null,
        errorMessage = null,
        successMessage = null;

  RegisterUserState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? imageName,
    String? errorMessage, // Make nullable to allow clearing
    String? successMessage, // Make nullable to allow clearing
  }) {
    return RegisterUserState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      imageName: imageName ?? this.imageName,
      errorMessage: errorMessage, // We explicitly set this to null to clear it
      successMessage: successMessage, // We explicitly set this to null to clear it
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSuccess,
    imageName,
    errorMessage,
    successMessage,
  ];
}