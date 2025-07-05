import 'package:dartz/dartz.dart';
import 'package:dream_dwell/app/use_case/usecase.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart';
import 'package:dream_dwell/features/auth/domain/repository/user_repository.dart';
 // Ensure this path is correct, previously was app/use_case/usecase.dart

class UserGetCurrentUsecase implements UsecaseWithoutParams<UserEntity> {
  final IUserRepository _userRepository;

  // CORRECTED: Changed 'studentRepository' to 'userRepository' to match the field name and call site.
  UserGetCurrentUsecase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<Either<Failure, UserEntity>> call() {
    return _userRepository.getCurrentUser();
  }
}