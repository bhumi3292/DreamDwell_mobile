import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart';
import 'package:dream_dwell/features/auth/domain/repository/user_repository.dart';



abstract class IUserRemoteDatasource {
  Future<String> loginUser(String email, String password, String stakeholder);
  Future<void> registerUser(UserEntity user);
  Future<UserEntity> getCurrentUser();
}

// --- User Remote Repository Implementation ---


class UserRemoteRepository implements IUserRepository {
  final IUserRemoteDatasource _dataSource;


  UserRemoteRepository({required IUserRemoteDatasource dataSource})
      : _dataSource = dataSource;

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _dataSource.registerUser(user);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(
      String email, String password, String stakeholder) async {
    try {

      final token = await _dataSource.loginUser(email, password, stakeholder);
      return Right(token);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }



  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = await _dataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
