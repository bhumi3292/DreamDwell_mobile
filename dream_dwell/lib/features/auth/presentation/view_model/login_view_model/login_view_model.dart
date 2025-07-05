import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:dream_dwell/features/auth/domain/use_case/user_login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase loginUserUseCase;

  LoginViewModel({required this.loginUserUseCase}) : super(LoginState.initial()) {
    on<LoginWithEmailAndPasswordEvent>(_onLoginWithEmailAndPassword);
  }

  void _onLoginWithEmailAndPassword(
      LoginWithEmailAndPasswordEvent event,
      Emitter<LoginState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null)); // Clear previous error

    try {
      final result = await loginUserUseCase.call(
        LoginParams(
          email: event.username,
          password: event.password,
          stakeholder: event.stakeholder, // Use the stakeholder from the event
        ),
      );

      result.fold(
            (error) {
          emit(state.copyWith(
            isLoading: false,
            isSuccess: false,
            error: error.message,
          ));
          ScaffoldMessenger.of(event.context).showSnackBar(
            SnackBar(
              content: Text('Login failed: ${error.message}'),
              backgroundColor: Colors.red,
            ),
          );
        },
            (success) {
          emit(state.copyWith(
            isLoading: false,
            isSuccess: true,
          ));
          ScaffoldMessenger.of(event.context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacementNamed(event.context, '/home');
        },
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        error: e.toString(),
      ));
      ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}