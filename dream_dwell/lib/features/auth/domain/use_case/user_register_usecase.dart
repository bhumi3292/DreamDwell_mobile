import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:dream_dwell/app/use_case/usecase.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart';
import 'package:dream_dwell/features/auth/domain/repository/user_repository.dart';

/// Params for registering a user
class RegisterUserParams extends Equatable {
  final String fullName;
  final String email;
  final String phone;
  final String stakeholder;
  final String password;
  final String confirmPassword;

  const RegisterUserParams({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.stakeholder,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [
    fullName,
    email,
    phone,
    stakeholder,
    password,
    confirmPassword,
  ];
}

/// Concrete failure for validation errors
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

/// User Registration Use Case
class UserRegisterUseCase
    implements UsecaseWithParams<void, RegisterUserParams> {
  final IUserRepository _userRepository;

  UserRegisterUseCase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) {
    if (params.password != params.confirmPassword) {
      return Future.value(Left(ValidationFailure(message: "Passwords do not match")));
    }

    final userEntity = UserEntity(
      fullName: params.fullName,
      email: params.email,
      phone: params.phone,
      stakeholder: params.stakeholder,
      password: params.password,
      confirmPassword: params.confirmPassword,
    );

    return _userRepository.registerUser(userEntity);
  }
}
