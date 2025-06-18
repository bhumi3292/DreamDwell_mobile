import 'package:dartz/dartz.dart';
import 'package:dream_dwell/app/use_case/login_params.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/auth/domain/repository/user_repository.dart';
import 'package:dream_dwell/app/use_case/usecase.dart';

class LoginUserUseCase implements UsecaseWithParams<String, LoginParams> {
  final IUserRepository _userRepository;

  LoginUserUseCase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<Either<Failure, String>> call(LoginParams params) {

    return _userRepository.loginUser(
      params.email,
      params.password,
      params.stakeholder,
    );
  }
}
