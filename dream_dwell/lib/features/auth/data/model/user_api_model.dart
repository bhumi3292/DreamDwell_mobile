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
  final String phoneNumber;
  final String stakeholder;
  final String password;
  final String? confirmPassword;

  const UserApiModel({
    this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.stakeholder,
    required this.password,
    this.confirmPassword,
  });


  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  /// Serialize to JSON (API)
  /// This method will now correctly send 'phoneNumber' to the backend.
  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  /// Convert to domain entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId ?? '',
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      stakeholder: stakeholder,
      password: password,
      confirmPassword: confirmPassword ?? '',
    );
  }

  //Create from domain entity
  factory UserApiModel.fromEntity(UserEntity entity) {
    return UserApiModel(
      userId: (entity.userId?.isEmpty ?? true) ? null : entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      stakeholder: entity.stakeholder,
      password: entity.password,
      confirmPassword: entity.confirmPassword.isEmpty ? null : entity.confirmPassword,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    fullName,
    email,
    phoneNumber, // Updated here
    stakeholder,
    password,
    confirmPassword,
  ];
}
