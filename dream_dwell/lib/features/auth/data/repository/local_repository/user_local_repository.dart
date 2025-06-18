import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart';
import 'package:dream_dwell/features/auth/domain/repository/user_repository.dart';

abstract class IUserLocalDatasource {
  Future<String> loginUser(String email, String password, String stakeholder); // Added stakeholder
  Future<void> registerUser(UserEntity user);
  Future<UserEntity> getCurrentUser();

}


abstract class IUserRepository {
  Future<Either<Failure, String>> loginUser(String email, String password, String stakeholder);
  Future<Either<Failure, void>> registerUser(UserEntity user);
  Future<Either<Failure, UserEntity>> getCurrentUser();

}

// --- User Local Repository Implementation ---
class UserLocalRepository implements IUserRepository {
  final UserLocalDatasource _userLocalDatasource;

  UserLocalRepository({
    required UserLocalDatasource userLocalDatasource,
  }) : _userLocalDatasource = userLocalDatasource;

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    // TODO: implement getCurrentUser logic (e.g., retrieve from local datasource)
    throw UnimplementedError('getCurrentUser has not been implemented in UserLocalRepository');
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
      return Left(LocalDatabaseFailure(message: "Failed to login locally: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _userLocalDatasource.registerUser(user);
      return Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Failed to register locally: $e"));
    }
  }

}
