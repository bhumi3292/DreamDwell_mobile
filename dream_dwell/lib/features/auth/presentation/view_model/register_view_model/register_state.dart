import 'package:equatable/equatable.dart';

class RegisterUserState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? imageName;

  const RegisterUserState({
    required this.isLoading,
    required this.isSuccess,
    this.imageName,
  });

  const RegisterUserState.initial()
      : isLoading = false,
        isSuccess = false,
        imageName = null;

  RegisterUserState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? imageName,
  }) {
    return RegisterUserState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      imageName: imageName ?? this.imageName,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, imageName];
}
