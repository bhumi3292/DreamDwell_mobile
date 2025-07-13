import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:dream_dwell/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:dream_dwell/features/auth/domain/repository/user_repository.dart';
import 'package:dream_dwell/cores/error/failure.dart';

// Generate mocks
@GenerateMocks([IUserRepository])
import 'user_login_usecase_test.mocks.dart';

void main() {
  group('UserLoginUsecase Tests', () {
    late MockIUserRepository mockUserRepository;
    late UserLoginUsecase userLoginUsecase;

    setUp(() {
      mockUserRepository = MockIUserRepository();
      userLoginUsecase = UserLoginUsecase(userRepository: mockUserRepository);
    });

    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testStakeholder = 'Landlord';
    const testToken = 'test_token_123';

    test('should return token when login is successful', () async {
      // Arrange
      when(mockUserRepository.loginUser(testEmail, testPassword, testStakeholder))
          .thenAnswer((_) async => const Right(testToken));

      // Act
      final result = await userLoginUsecase.call(
        const LoginParams(
          email: testEmail,
          password: testPassword,
          stakeholder: testStakeholder,
        ),
      );

      // Assert
      expect(result, const Right(testToken));
      verify(mockUserRepository.loginUser(testEmail, testPassword, testStakeholder)).called(1);
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('should return failure when login fails', () async {
      // Arrange
      const failure = ServerFailure(message: 'Invalid credentials');
      when(mockUserRepository.loginUser(testEmail, testPassword, testStakeholder))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await userLoginUsecase.call(
        const LoginParams(
          email: testEmail,
          password: testPassword,
          stakeholder: testStakeholder,
        ),
      );

      // Assert
      expect(result, const Left(failure));
      verify(mockUserRepository.loginUser(testEmail, testPassword, testStakeholder)).called(1);
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('should handle empty email parameter', () async {
      // Arrange
      const emptyEmail = '';
      when(mockUserRepository.loginUser(emptyEmail, testPassword, testStakeholder))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Email is required')));

      // Act
      final result = await userLoginUsecase.call(
        const LoginParams(
          email: emptyEmail,
          password: testPassword,
          stakeholder: testStakeholder,
        ),
      );

      // Assert
      expect(result.isLeft(), isTrue);
      verify(mockUserRepository.loginUser(emptyEmail, testPassword, testStakeholder)).called(1);
    });

    test('should handle empty password parameter', () async {
      // Arrange
      const emptyPassword = '';
      when(mockUserRepository.loginUser(testEmail, emptyPassword, testStakeholder))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Password is required')));

      // Act
      final result = await userLoginUsecase.call(
        const LoginParams(
          email: testEmail,
          password: emptyPassword,
          stakeholder: testStakeholder,
        ),
      );

      // Assert
      expect(result.isLeft(), isTrue);
      verify(mockUserRepository.loginUser(testEmail, emptyPassword, testStakeholder)).called(1);
    });

    test('should handle empty stakeholder parameter', () async {
      // Arrange
      const emptyStakeholder = '';
      when(mockUserRepository.loginUser(testEmail, testPassword, emptyStakeholder))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Stakeholder is required')));

      // Act
      final result = await userLoginUsecase.call(
        const LoginParams(
          email: testEmail,
          password: testPassword,
          stakeholder: emptyStakeholder,
        ),
      );

      // Assert
      expect(result.isLeft(), isTrue);
      verify(mockUserRepository.loginUser(testEmail, testPassword, emptyStakeholder)).called(1);
    });

    test('should handle network failure', () async {
      // Arrange
      const networkFailure = NetworkFailure(message: 'No internet connection');
      when(mockUserRepository.loginUser(testEmail, testPassword, testStakeholder))
          .thenAnswer((_) async => const Left(networkFailure));

      // Act
      final result = await userLoginUsecase.call(
        const LoginParams(
          email: testEmail,
          password: testPassword,
          stakeholder: testStakeholder,
        ),
      );

      // Assert
      expect(result, const Left(networkFailure));
      verify(mockUserRepository.loginUser(testEmail, testPassword, testStakeholder)).called(1);
    });

    test('LoginParams should be equatable', () {
      // Arrange
      const params1 = LoginParams(
        email: testEmail,
        password: testPassword,
        stakeholder: testStakeholder,
      );
      const params2 = LoginParams(
        email: testEmail,
        password: testPassword,
        stakeholder: testStakeholder,
      );
      const params3 = LoginParams(
        email: 'different@example.com',
        password: testPassword,
        stakeholder: testStakeholder,
      );

      // Assert
      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
    });

    test('LoginParams.initial should create default values', () {
      // Act
      const initialParams = LoginParams.initial();

      // Assert
      expect(initialParams.email, equals(''));
      expect(initialParams.password, equals(''));
      expect(initialParams.stakeholder, equals(''));
    });
  });
} 