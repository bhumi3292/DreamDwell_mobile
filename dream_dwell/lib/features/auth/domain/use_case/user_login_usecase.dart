import 'package:dartz/dartz.dart';
import 'package:dream_dwell/app/use_case/login_params.dart';
import 'package:dream_dwell/app/use_case/usecase.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:dream_dwell/features/auth/domain/repository/user_repository.dart';


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
