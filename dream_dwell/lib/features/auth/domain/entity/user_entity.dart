import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String stakeholder;
  final String password;
  final String confirmPassword;

  const UserEntity({
    this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.stakeholder,
    required this.password,
    required this.confirmPassword,
  });

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
