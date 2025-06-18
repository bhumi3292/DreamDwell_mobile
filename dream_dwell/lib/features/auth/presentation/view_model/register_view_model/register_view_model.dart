import 'package:bloc/bloc.dart';
import 'package:dream_dwell/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/register_view_model/register_state.dart';

import '../../../../../../cores/common/snackbar/snackbar.dart';

class RegisterUserViewModel extends Bloc<RegisterNewUserEvent, RegisterUserState> {
  final UserRegisterUseCase _userRegisterUseCase;

  RegisterUserViewModel(this._userRegisterUseCase)
      : super(const RegisterUserState.initial()) {
    on<RegisterNewUserEvent>(_onRegisterUser);
  }

  Future<void> _onRegisterUser(
      RegisterNewUserEvent event,
      Emitter<RegisterUserState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _userRegisterUseCase(
      RegisterUserParams(
        fullName: event.fullName,
        email: event.email,
        phone: event.phone,
        stakeholder: event.stakeholder,
        password: event.password,
        confirmPassword: event.confirmPassword,
      ),
    );

    result.fold(
          (l) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showMySnackbar(
          context: event.context,
          content: l.message,
          isSuccess: false,
        );
      },
          (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackbar(
          context: event.context,
          content: "User registration successful",
          isSuccess: true,
        );
      },
    );
  }
}
