import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/constant/hive_table_const.dart' show HiveTableConstant;

part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? phoneNumber; // Made nullable to match UserEntity

  @HiveField(4)
  final String? stakeholder; // Made nullable to match UserEntity

  @HiveField(5)
  final String password; // Keep for local login logic if needed

  @HiveField(6)
  final String confirmPassword; // Keep for local login logic if needed

  @HiveField(7)
  final String? profilePicture;


  UserHiveModel({
    String? userId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.stakeholder,
    required this.password,
    required this.confirmPassword,
    this.profilePicture,
  }) : userId = userId ?? const Uuid().v4();

  const UserHiveModel.initial()
      : userId = '',
        fullName = '',
        email = '',
        phoneNumber = null,
        stakeholder = null,
        password = '',
        confirmPassword = '',
        profilePicture = null;

  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      userId: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      stakeholder: entity.stakeholder,
      // Pass password/confirmPassword from entity, assuming they are available for local storage
      password: entity.password ?? '',
      confirmPassword: entity.confirmPassword ?? '',
      profilePicture: entity.profilePicture,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      stakeholder: stakeholder,
      password: password,
      confirmPassword: confirmPassword,
      profilePicture: profilePicture,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    fullName,
    email,
    phoneNumber,
    stakeholder,
    password,
    confirmPassword,
    profilePicture,
  ];
}