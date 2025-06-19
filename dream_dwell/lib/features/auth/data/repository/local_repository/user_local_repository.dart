import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart'; // Assuming Failure and LocalDatabaseFailure exist
import 'package:dream_dwell/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart';
import 'package:dream_dwell/features/auth/domain/repository/user_repository.dart'; // Corrected import


class UserLocalRepository implements IUserRepository {
  final UserLocalDatasource _userLocalDatasource;

  UserLocalRepository({
    required UserLocalDatasource userLocalDatasource,
  }) : _userLocalDatasource = userLocalDatasource;

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = await _userLocalDatasource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Failed to get current user locally: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(
      String email,
      String password,
      String stakeholder,
      ) async {
    try {
      final result = await _userLocalDatasource.loginUser(
        email,
        password,
        stakeholder,
      );
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Failed to login locally: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _userLocalDatasource.registerUser(user);
      return Right(null); // Return success (void)
    } catch (e) {
      // Catch any exception from the datasource and wrap it in a LocalDatabaseFailure
      return Left(LocalDatabaseFailure(message: "Failed to register locally: ${e.toString()}"));
    }
  }
}