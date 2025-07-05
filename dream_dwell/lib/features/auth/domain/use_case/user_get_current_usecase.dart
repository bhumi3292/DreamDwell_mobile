import 'package:dartz/dartz.dart';
import 'package:dream_dwell/app/use_case/usecase.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart';
import 'package:dream_dwell/features/auth/domain/repository/user_repository.dart';


class UserGetCurrentUsecase implements UsecaseWithoutParams<UserEntity> {
  final IUserRepository _userRepository;

  UserGetCurrentUsecase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<Either<Failure, UserEntity>> call() {
    return _userRepository.getCurrentUser();
  }
}