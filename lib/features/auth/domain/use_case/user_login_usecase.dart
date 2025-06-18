import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:dream_dwell/app/use_case/usecase.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/auth/data/repository/local_repository/user_local_repository.dart';

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
  final UserLocalRepository _userRepository;

  UserLoginUsecase({required UserLocalRepository userRepository})
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
