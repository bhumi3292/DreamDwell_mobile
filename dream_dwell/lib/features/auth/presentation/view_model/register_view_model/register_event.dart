import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class RegisterUserEvent extends Equatable {
  const RegisterUserEvent();

  @override
  List<Object?> get props => [];
}

class RegisterNewUserEvent extends RegisterUserEvent {
  final String fullName;
  final String email;
  final String phone;
  final String stakeholder;
  final String password;
  final String confirmPassword;
  final BuildContext? context; // optional, for snackbar

  const RegisterNewUserEvent({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.stakeholder,
    required this.password,
    required this.confirmPassword,
    this.context,
  });

  @override
  List<Object?> get props => [
    fullName,
    email,
    phone,
    stakeholder,
    password,
    confirmPassword,
    context,
  ];
}

class ClearRegisterMessageEvent extends RegisterUserEvent {
  const ClearRegisterMessageEvent();

  @override
  List<Object?> get props => [];
}
