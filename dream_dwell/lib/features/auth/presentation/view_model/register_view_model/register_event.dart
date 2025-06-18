import 'dart:io';
import 'package:flutter/material.dart';

@immutable
sealed class RegisterUserEvent {}

class UploadUserImageEvent extends RegisterUserEvent {
  final File file;

  UploadUserImageEvent({required this.file});
}

class RegisterNewUserEvent extends RegisterUserEvent {
  final BuildContext context;
  final String fullName;
  final String email;
  final String phone;
  final String stakeholder;
  final String password;
  final String confirmPassword;
  final String? image;

  RegisterNewUserEvent({
    required this.context,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.stakeholder,
    required this.password,
    required this.confirmPassword,
    this.image,
  });
}
