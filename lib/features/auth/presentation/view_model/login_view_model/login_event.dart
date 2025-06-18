import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
sealed class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;
  final String stakeholder;

  LoginButtonPressed({
    required this.email,
    required this.password,
    required this.stakeholder,
  });
}
