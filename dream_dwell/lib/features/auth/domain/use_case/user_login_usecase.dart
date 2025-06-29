import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:dream_dwell/app/use_case/usecase.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/auth/domain/repository/user_repository.dart'; // <- Updated

/// Parameters required for user login
class LoginParams extends Equatable {
  final String email;
  final String password;
  final String stakeholder;

  const LoginParams({
    required this.email,
    required this.password,
    required this.stakeholder,
  });

  /// Initial default state (empty credentials)
  const LoginParams.initial()
      : email = '',
        password = '',
        stakeholder = '';

  @override
  List<Object?> get props => [email, password, stakeholder];
}

/// Use case to handle user login functionality
class UserLoginUsecase implements UsecaseWithParams<String, LoginParams> {
  final IUserRepository _userRepository; // ✅ Use interface

  UserLoginUsecase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    return await _userRepository.loginUser(
      params.email,
      params.password,
      params.stakeholder,
    );
  }
}
