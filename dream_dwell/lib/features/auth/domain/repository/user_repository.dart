import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart';
import 'dart:io';

abstract interface class IUserRepository {
  Future<Either<Failure, void>> registerUser(UserEntity user);

  Future<Either<Failure, String>> loginUser(
      String email,
      String password,
      String stakeholder,
      );

  Future<Either<Failure, UserEntity>> getCurrentUser();
  Future<Either<Failure, String>> uploadProfilePicture(File imageFile);
}