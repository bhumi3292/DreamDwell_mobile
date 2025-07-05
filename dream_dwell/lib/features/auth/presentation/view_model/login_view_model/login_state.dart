import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  const LoginState({
    required this.isLoading,
    required this.isSuccess,
    this.error,
  });

  const LoginState.initial()
      : isLoading = false,
        isSuccess = false,
        error = null;

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error, // Note: overwrite even if null
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, error];
}