import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart';
import 'package:dream_dwell/features/auth/domain/repository/user_repository.dart';
import 'package:dream_dwell/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:dream_dwell/cores/network/hive_service.dart';
import 'dart:io';

class UserRemoteRepository implements IUserRepository {
  final UserRemoteDatasource _dataSource;
  final HiveService _hiveService;

  UserRemoteRepository({
    required UserRemoteDatasource dataSource,
    required HiveService hiveService,
  })  : _dataSource = dataSource,
        _hiveService = hiveService;

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _dataSource.registerUser(user);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: "Registration failed: $e"));
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(
      String email, String password, String stakeholder) async {
    try {
      final token = await _dataSource.loginUser(email, password, stakeholder);
      await _hiveService.saveToken(token); // Token saving is here
      return Right(token);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: "Login failed: $e"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = await _dataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: "Get current user failed: $e"));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File imageFile) async {
    try {
      final newUrl = await _dataSource.uploadProfilePicture(imageFile);
      return Right(newUrl);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: "Upload profile picture failed: $e"));
    }
  }

  // ⭐ CORE FIX: Change _hiveService.clearToken() to _hiveService.deleteToken() ⭐
  Future<Either<Failure, void>> logoutUser() async {
    try {
      await _hiveService.deleteToken(); // ⭐ CHANGED THIS LINE ⭐
      // If you also want to clear all user data (not just the token) on logout,
      // you could call _hiveService.clearUserData(); here instead.
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Failed to logout: $e"));
    }
  }
}