
import 'package:bloc/bloc.dart';
import 'package:dream_dwell/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/register_view_model/register_state.dart';



class RegisterUserViewModel extends Bloc<RegisterUserEvent, RegisterUserState> {
  final UserRegisterUseCase _userRegisterUseCase;

  RegisterUserViewModel(this._userRegisterUseCase)
      : super(const RegisterUserState.initial()) {
    on<RegisterNewUserEvent>(_onRegisterUser);
    on<ClearRegisterMessageEvent>(_onClearMessage);
  }


  void _onClearMessage(
      ClearRegisterMessageEvent event, Emitter<RegisterUserState> emit) {
    emit(state.copyWith(errorMessage: null, successMessage: null));
  }

  Future<void> _onRegisterUser(
      RegisterNewUserEvent event,
      Emitter<RegisterUserState> emit,
      ) async {

    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    ));

    // 2. Execute the registration use case
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
          (failure) {

        emit(state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: failure.message,
        ));

      },
          (_) {

        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          successMessage: "User registration successful",
        ));
      },
    );
  }
}