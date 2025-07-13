import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:dream_dwell/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:dream_dwell/cores/error/failure.dart';

// Generate mocks
@GenerateMocks([UserLoginUsecase])
import 'login_view_model_test.mocks.dart';

void main() {
  group('LoginViewModel Tests', () {
    late MockUserLoginUsecase mockLoginUsecase;
    late LoginViewModel loginViewModel;

    setUp(() {
      mockLoginUsecase = MockUserLoginUsecase();
      loginViewModel = LoginViewModel(loginUserUseCase: mockLoginUsecase);
    });

    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testStakeholder = 'Landlord';
    const testToken = 'test_token_123';

    test('initial state should be LoginState.initial()', () {
      // Assert
      expect(loginViewModel.state, equals(LoginState.initial()));
    });

    blocTest<LoginViewModel, LoginState>(
      'emits [LoginState with isLoading: true] when LoginWithEmailAndPasswordEvent is added',
      build: () {
        when(mockLoginUsecase.call(any))
            .thenAnswer((_) async => const Right('dummy_token'));
        return loginViewModel;
      },
      act: (bloc) => bloc.add(
        LoginWithEmailAndPasswordEvent(
          username: testEmail,
          password: testPassword,
          stakeholder: testStakeholder,
        ),
      ),
      expect: () => [
        isA<LoginState>().having((state) => state.isLoading, 'isLoading', isTrue),
        isA<LoginState>().having((state) => state.isLoading, 'isLoading', isFalse)
          .having((state) => state.isSuccess, 'isSuccess', isTrue)
          .having((state) => state.shouldNavigateToHome, 'shouldNavigateToHome', isTrue),
      ],
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [LoginState with isSuccess: true and shouldNavigateToHome: true] when login is successful',
      build: () {
        when(mockLoginUsecase.call(any))
            .thenAnswer((_) async => const Right(testToken));
        return loginViewModel;
      },
      act: (bloc) => bloc.add(
        LoginWithEmailAndPasswordEvent(
          username: testEmail,
          password: testPassword,
          stakeholder: testStakeholder,
        ),
      ),
      expect: () => [
        isA<LoginState>().having((state) => state.isLoading, 'isLoading', isTrue),
        isA<LoginState>().having((state) => state.isSuccess, 'isSuccess', isTrue)
            .having((state) => state.isLoading, 'isLoading', isFalse)
            .having((state) => state.shouldNavigateToHome, 'shouldNavigateToHome', isTrue),
      ],
      verify: (bloc) {
        verify(mockLoginUsecase.call(
          const LoginParams(
            email: testEmail,
            password: testPassword,
            stakeholder: testStakeholder,
          ),
        )).called(1);
      },
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [LoginState with error] when login fails',
      build: () {
        const failure = ServerFailure(message: 'Invalid credentials');
        when(mockLoginUsecase.call(any))
            .thenAnswer((_) async => const Left(failure));
        return loginViewModel;
      },
      act: (bloc) => bloc.add(
        LoginWithEmailAndPasswordEvent(
          username: testEmail,
          password: testPassword,
          stakeholder: testStakeholder,
        ),
      ),
      expect: () => [
        isA<LoginState>().having((state) => state.isLoading, 'isLoading', isTrue),
        isA<LoginState>().having((state) => state.error, 'error', 'Invalid credentials')
            .having((state) => state.isLoading, 'isLoading', isFalse)
            .having((state) => state.isSuccess, 'isSuccess', isFalse),
      ],
      verify: (bloc) {
        verify(mockLoginUsecase.call(
          const LoginParams(
            email: testEmail,
            password: testPassword,
            stakeholder: testStakeholder,
          ),
        )).called(1);
      },
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [LoginState with network error] when network fails',
      build: () {
        const failure = NetworkFailure(message: 'No internet connection');
        when(mockLoginUsecase.call(any))
            .thenAnswer((_) async => const Left(failure));
        return loginViewModel;
      },
      act: (bloc) => bloc.add(
        LoginWithEmailAndPasswordEvent(
          username: testEmail,
          password: testPassword,
          stakeholder: testStakeholder,
        ),
      ),
      expect: () => [
        isA<LoginState>().having((state) => state.isLoading, 'isLoading', isTrue),
        isA<LoginState>().having((state) => state.error, 'error', 'No internet connection')
            .having((state) => state.isLoading, 'isLoading', isFalse)
            .having((state) => state.isSuccess, 'isSuccess', isFalse),
      ],
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [LoginState with exception error] when exception occurs',
      build: () {
        when(mockLoginUsecase.call(any))
            .thenThrow(Exception('Unexpected error'));
        return loginViewModel;
      },
      act: (bloc) => bloc.add(
        LoginWithEmailAndPasswordEvent(
          username: testEmail,
          password: testPassword,
          stakeholder: testStakeholder,
        ),
      ),
      expect: () => [
        isA<LoginState>().having((state) => state.isLoading, 'isLoading', isTrue),
        isA<LoginState>().having((state) => state.error, 'error', 'Exception: Unexpected error')
            .having((state) => state.isLoading, 'isLoading', isFalse)
            .having((state) => state.isSuccess, 'isSuccess', isFalse),
      ],
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [LoginState with shouldNavigateToRegister: true] when NavigateToRegisterViewEvent is added',
      build: () => loginViewModel,
      act: (bloc) => bloc.add(NavigateToRegisterViewEvent()),
      expect: () => [
        isA<LoginState>().having((state) => state.shouldNavigateToRegister, 'shouldNavigateToRegister', isTrue),
      ],
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [LoginState with shouldNavigateToHome: true] when NavigateToHomeViewEvent is added',
      build: () => loginViewModel,
      act: (bloc) => bloc.add(NavigateToHomeViewEvent()),
      expect: () => [
        isA<LoginState>().having((state) => state.shouldNavigateToHome, 'shouldNavigateToHome', isTrue),
      ],
    );

    test('LoginWithEmailAndPasswordEvent should be equatable', () {
      // Arrange
      final event1 = LoginWithEmailAndPasswordEvent(
        username: testEmail,
        password: testPassword,
        stakeholder: testStakeholder,
      );
      final event2 = LoginWithEmailAndPasswordEvent(
        username: testEmail,
        password: testPassword,
        stakeholder: testStakeholder,
      );
      final event3 = LoginWithEmailAndPasswordEvent(
        username: 'different@example.com',
        password: testPassword,
        stakeholder: testStakeholder,
      );

      // Assert
      expect(event1, equals(event2));
      expect(event1, isNot(equals(event3)));
    });

    test('LoginState should be equatable', () {
      // Arrange
      const state1 = LoginState(
        isLoading: false,
        isSuccess: true,
        error: null,
        shouldNavigateToHome: false,
        shouldNavigateToRegister: false,
      );
      const state2 = LoginState(
        isLoading: false,
        isSuccess: true,
        error: null,
        shouldNavigateToHome: false,
        shouldNavigateToRegister: false,
      );
      const state3 = LoginState(
        isLoading: true,
        isSuccess: false,
        error: 'Error message',
        shouldNavigateToHome: false,
        shouldNavigateToRegister: false,
      );

      // Assert
      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });

    test('LoginState.initial should create default values', () {
      // Act
      const initialState = LoginState.initial();

      // Assert
      expect(initialState.isLoading, isFalse);
      expect(initialState.isSuccess, isFalse);
      expect(initialState.error, isNull);
      expect(initialState.shouldNavigateToHome, isFalse);
      expect(initialState.shouldNavigateToRegister, isFalse);
    });

    test('LoginState.copyWith should create new state with updated values', () {
      // Arrange
      const initialState = LoginState.initial();

      // Act
      final updatedState = initialState.copyWith(
        isLoading: true,
        error: 'Test error',
        shouldNavigateToHome: true,
      );

      // Assert
      expect(updatedState.isLoading, isTrue);
      expect(updatedState.isSuccess, isFalse);
      expect(updatedState.error, equals('Test error'));
      expect(updatedState.shouldNavigateToHome, isTrue);
      expect(updatedState.shouldNavigateToRegister, isFalse);
    });
  });
} 