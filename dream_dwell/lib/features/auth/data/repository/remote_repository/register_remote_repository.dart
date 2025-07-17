import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart'; // Ensure this path is correct
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart';
import 'package:dream_dwell/features/auth/domain/repository/user_repository.dart';
import 'package:dream_dwell/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:dream_dwell/cores/network/hive_service.dart';
import 'dart:io';
import 'package:dream_dwell/cores/network/api_service.dart';
import 'package:dream_dwell/features/auth/data/model/user_api_model.dart';

class UserRemoteRepository implements IUserRepository {
  final UserRemoteDatasource _dataSource;
  final HiveService _hiveService;
  final ApiService apiService;

  UserRemoteRepository({
    required UserRemoteDatasource dataSource,
    required HiveService hiveService,
    required this.apiService,
  })  : _dataSource = dataSource,
        _hiveService = hiveService;

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _dataSource.registerUser(user);
      return const Right(null);
    } catch (e) {
      // This will now correctly catch RemoteDatabaseFailure thrown from datasource
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
      // This will now correctly catch RemoteDatabaseFailure thrown from datasource
      return Left(RemoteDatabaseFailure(message: "Login failed: $e"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = await _dataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      // This will now correctly catch RemoteDatabaseFailure thrown from datasource
      return Left(RemoteDatabaseFailure(message: "Get current user failed: $e"));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File imageFile) async {
    try {
      // This call now relies on UserRemoteDatasourceImpl correctly handling Dio responses
      final newUrl = await _dataSource.uploadProfilePicture(imageFile);
      return Right(newUrl); // Returns the URL on success
    } catch (e) {
      // This catch block will properly handle the RemoteDatabaseFailure
      // that is thrown by UserRemoteDatasourceImpl on error.
      // The 'e' here will be an instance of RemoteDatabaseFailure.
      if (e is Failure) { // Check if it's one of your defined Failure types
        return Left(e); // Return the specific failure
      }
      // Fallback for any unexpected non-Failure exceptions
      return Left(RemoteDatabaseFailure(message: "Upload profile picture failed: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(String fullName, String email) async {
    try {
      final response = await apiService.dio.patch(
        '/users/me', // Adjust endpoint as needed
        data: {'fullName': fullName, 'email': email},
      );
      if (response.statusCode == 200) {
        final userApiModel = UserApiModel.fromJson(response.data);
        return Right(userApiModel.toEntity());
      } else {
        return Left(ServerFailure(message: 'Failed to update user'));
      }
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> logoutUser() async {
    try {
      await _hiveService.deleteToken();
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Failed to logout: ${e.toString()}"));
    }
  }
}