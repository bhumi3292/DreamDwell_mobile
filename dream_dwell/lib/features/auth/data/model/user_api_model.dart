import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;

  final String fullName;
  final String email;
  final String phone;
  final String stakeholder;
  final String password;
  final String? confirmPassword;

  const UserApiModel({
    this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.stakeholder,
    required this.password,
    this.confirmPassword,
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  //to domain entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId ?? '',
      fullName: fullName,
      email: email,
      phone: phone,
      stakeholder: stakeholder,
      password: password,
      confirmPassword: confirmPassword ?? '',
    );
  }

  /// Create from domain entity
  factory UserApiModel.fromEntity(UserEntity entity) {
    return UserApiModel(
      userId: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      phone: entity.phone,
      stakeholder: entity.stakeholder,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    fullName,
    email,
    phone,
    stakeholder,
    password,
    confirmPassword,
  ];
}
