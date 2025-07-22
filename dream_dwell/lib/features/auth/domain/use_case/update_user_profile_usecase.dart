import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart';
import 'package:dream_dwell/features/auth/domain/repository/user_repository.dart';

class UpdateUserProfileUsecase {
  final IUserRepository repository;

  UpdateUserProfileUsecase(this.repository);

  Future<Either<Failure, UserEntity>> call(
    String fullName, 
    String email, 
    String? phoneNumber,
    String? currentPassword,
    String? newPassword,
  ) async {
    return await repository.updateUser(
      fullName, 
      email, 
      phoneNumber,
      currentPassword,
      newPassword,
    );
  }
} 