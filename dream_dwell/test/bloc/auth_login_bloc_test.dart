import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:dream_dwell/cores/error/failure.dart';
import 'package:dream_dwell/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/login_view_model/login_state.dart';

@GenerateMocks([UserLoginUsecase])
import 'auth_login_bloc_test.mocks.dart';

void main() {
  late LoginViewModel loginViewModel;
  late MockUserLoginUsecase mockUserLoginUsecase;

  setUp(() {
    mockUserLoginUsecase = MockUserLoginUsecase();
    loginViewModel = LoginViewModel(loginUserUseCase: mockUserLoginUsecase);
  });

  group('LoginViewModel', () {
    test('initial state should be LoginState.initial()', () {
      expect(loginViewModel.state, const LoginState.initial());
    });

    blocTest<LoginViewModel, LoginState>(
      'emits [LoginState with isLoading: true, LoginState with isLoading: false, isSuccess: true, shouldNavigateToHome: true] when login is successful',
      build: () {
        when(mockUserLoginUsecase.call(any)).thenAnswer(
          (_) async => const Right('Success'), // Return a string instead of null
        );
        return loginViewModel;
      },
      act: (bloc) => bloc.add(LoginWithEmailAndPasswordEvent(
        username: 'test@example.com',
        password: 'password123',
        stakeholder: 'tenant',
      )),
      expect: () => [
        const LoginState(
          isLoading: true,
          isSuccess: false,
          error: null,
          shouldNavigateToHome: false,
          shouldNavigateToRegister: false,
        ),
        const LoginState(
          isLoading: false,
          isSuccess: true,
          error: null,
          shouldNavigateToHome: true,
          shouldNavigateToRegister: false,
        ),
      ],
      verify: (_) {
        verify(mockUserLoginUsecase.call(const LoginParams(
          email: 'test@example.com',
          password: 'password123',
          stakeholder: 'tenant',
        ))).called(1);
      },
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [LoginState with isLoading: true, LoginState with isLoading: false, isSuccess: false, error: message] when login fails',
      build: () {
        when(mockUserLoginUsecase.call(any)).thenAnswer(
          (_) async => const Left(AuthFailure(message: 'Invalid credentials')),
        );
        return loginViewModel;
      },
      act: (bloc) => bloc.add(LoginWithEmailAndPasswordEvent(
        username: 'test@example.com',
        password: 'wrongpassword',
        stakeholder: 'tenant',
      )),
      expect: () => [
        const LoginState(
          isLoading: true,
          isSuccess: false,
          error: null,
          shouldNavigateToHome: false,
          shouldNavigateToRegister: false,
        ),
        const LoginState(
          isLoading: false,
          isSuccess: false,
          error: 'Invalid credentials',
          shouldNavigateToHome: false,
          shouldNavigateToRegister: false,
        ),
      ],
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [LoginState with shouldNavigateToRegister: true] when NavigateToRegisterViewEvent is added',
      build: () => loginViewModel,
      act: (bloc) => bloc.add(NavigateToRegisterViewEvent()),
      expect: () => [
        const LoginState(
          isLoading: false,
          isSuccess: false,
          error: null,
          shouldNavigateToHome: false,
          shouldNavigateToRegister: true,
        ),
      ],
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [LoginState with shouldNavigateToHome: true] when NavigateToHomeViewEvent is added',
      build: () => loginViewModel,
      act: (bloc) => bloc.add(NavigateToHomeViewEvent()),
      expect: () => [
        const LoginState(
          isLoading: false,
          isSuccess: false,
          error: null,
          shouldNavigateToHome: true,
          shouldNavigateToRegister: false,
        ),
      ],
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [LoginState with isLoading: true, LoginState with isLoading: false, isSuccess: false, error: exception] when login throws exception',
      build: () {
        when(mockUserLoginUsecase.call(any)).thenThrow(
          Exception('Network error'),
        );
        return loginViewModel;
      },
      act: (bloc) => bloc.add(LoginWithEmailAndPasswordEvent(
        username: 'test@example.com',
        password: 'password123',
        stakeholder: 'tenant',
      )),
      expect: () => [
        const LoginState(
          isLoading: true,
          isSuccess: false,
          error: null,
          shouldNavigateToHome: false,
          shouldNavigateToRegister: false,
        ),
        const LoginState(
          isLoading: false,
          isSuccess: false,
          error: 'Exception: Network error',
          shouldNavigateToHome: false,
          shouldNavigateToRegister: false,
        ),
      ],
    );
  });
} 