import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart';
import 'package:dream_dwell/features/auth/domain/repository/user_repository.dart';
import 'dart:io'; // For File, if you want to add uploadProfilePicture to local repo

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
      return Left(LocalDatabaseFailure(message: "Failed to get current user from local: $e"));
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

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File imageFile) {
    // This is a local repository. It typically doesn't handle image uploads.
    // You might return an UnimplementedError or a specific failure.
    return Future.value(Left(LocalDatabaseFailure(message: "Image upload not supported by local repository")));
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(String fullName, String email) async {
    return Future.error(UnimplementedError('Local updateUser not implemented'));
  }
}