// features/auth/presentation/view_model/register_view_model/register_event.dart
import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart'; // No longer needed here

abstract class RegisterUserEvent extends Equatable {
  const RegisterUserEvent();

  @override
  List<Object?> get props => [];
}

class RegisterNewUserEvent extends RegisterUserEvent {
  // Removed BuildContext context: The BLoC should not directly interact with UI context.
  final String fullName;
  final String email;
  final String phone;
  final String stakeholder;
  final String password;
  final String confirmPassword;

  const RegisterNewUserEvent({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.stakeholder,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [
    fullName,
    email,
    phone,
    stakeholder,
    password,
    confirmPassword,
  ];
}

// New event to clear any success/error messages after the UI has displayed them.
class ClearRegisterMessageEvent extends RegisterUserEvent {
  const ClearRegisterMessageEvent();

  @override
  List<Object?> get props => [];
}