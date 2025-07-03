
import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart';
import 'package:dream_dwell/features/auth/domain/repository/user_repository.dart';

class UserLocalRepository implements IUserRepository {
  final UserLocalDatasource _userLocalDatasource;

  UserLocalRepository({
    required UserLocalDatasource userLocalDatasource,
  }) : _userLocalDatasource = userLocalDatasource;

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    // TODO: implement loginStudent
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> loginUser(
      String username,
      String password,
      String stakeholder,
      ) async {
    try {
      final result = await _userLocalDatasource.loginUser(
        username,
        password,
        stakeholder
      );
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Failed to login: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _userLocalDatasource.registerUser(user);
      return Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Failed to register: $e"));
    }
  }




}
