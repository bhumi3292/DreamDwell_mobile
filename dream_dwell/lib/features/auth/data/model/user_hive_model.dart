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
  final String phoneNumber;

  @HiveField(4)
  final String stakeholder;

  @HiveField(5)
  final String password;

  @HiveField(6)
  final String confirmPassword;

  UserHiveModel({
    String? userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.stakeholder,
    required this.password,
    required this.confirmPassword,
  }) : userId = userId ?? const Uuid().v4();

  // Initial Constructor
  const UserHiveModel.initial()
      : userId = '',
        fullName = '',
        email = '',
        phoneNumber = '',
        stakeholder = '',
        password = '',
        confirmPassword = '';

  // From Entity
  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      userId: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      stakeholder: entity.stakeholder,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
    );
  }

  // To Entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      stakeholder: stakeholder,
      password: password,
      confirmPassword: confirmPassword,
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
  ];
}
