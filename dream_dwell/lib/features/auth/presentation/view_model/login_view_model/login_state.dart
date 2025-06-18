class LoginState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  LoginState({
    required this.isLoading,
    required this.isSuccess,
    this.error,
  });

  factory LoginState.initial() => LoginState(isLoading: false, isSuccess: false);

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }
}
