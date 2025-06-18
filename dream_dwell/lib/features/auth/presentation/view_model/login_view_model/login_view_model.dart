import 'package:dream_dwell/app/use_case/login_params.dart';
import 'package:dream_dwell/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dream_dwell/model/login_auth.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase loginUserUseCase;

  LoginViewModel({required this.loginUserUseCase})
    : super(LoginState.initial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  void _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final result = await loginUserUseCase.call(
        LoginParams(
          email: event.email,
          password: event.password,
          stakeholder: event.stakeholder,
        ),
      );
      result.fold(
        (error) => state.copyWith(
          isLoading: false,
          error: error.message,
          isSuccess: false,
        ),
        (success) => state.copyWith(isLoading: false, isSuccess: true),
      );
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, isSuccess: false, error: e.toString()),
      );
    }
  }
}
