// Mocks generated by Mockito 5.4.5 from annotations
// in dream_dwell/test/unit/user_login_usecase_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;
import 'dart:io' as _i7;

import 'package:dartz/dartz.dart' as _i2;
import 'package:dream_dwell/cores/error/failure.dart' as _i5;
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart'
    as _i6;
import 'package:dream_dwell/features/auth/domain/repository/user_repository.dart'
    as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [IUserRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockIUserRepository extends _i1.Mock implements _i3.IUserRepository {
  MockIUserRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, void>> registerUser(
          _i6.UserEntity? user) =>
      (super.noSuchMethod(
        Invocation.method(
          #registerUser,
          [user],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, void>>.value(
            _FakeEither_0<_i5.Failure, void>(
          this,
          Invocation.method(
            #registerUser,
            [user],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, void>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, String>> loginUser(
    String? email,
    String? password,
    String? stakeholder,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #loginUser,
          [
            email,
            password,
            stakeholder,
          ],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, String>>.value(
            _FakeEither_0<_i5.Failure, String>(
          this,
          Invocation.method(
            #loginUser,
            [
              email,
              password,
              stakeholder,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, String>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.UserEntity>> getCurrentUser() =>
      (super.noSuchMethod(
        Invocation.method(
          #getCurrentUser,
          [],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.UserEntity>>.value(
            _FakeEither_0<_i5.Failure, _i6.UserEntity>(
          this,
          Invocation.method(
            #getCurrentUser,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.UserEntity>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, String>> uploadProfilePicture(
          _i7.File? imageFile) =>
      (super.noSuchMethod(
        Invocation.method(
          #uploadProfilePicture,
          [imageFile],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, String>>.value(
            _FakeEither_0<_i5.Failure, String>(
          this,
          Invocation.method(
            #uploadProfilePicture,
            [imageFile],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, String>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.UserEntity>> updateUser(
    String? fullName,
    String? email,
    String? phoneNumber,
    String? currentPassword,
    String? newPassword,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUser,
          [
            fullName,
            email,
            phoneNumber,
            currentPassword,
            newPassword,
          ],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.UserEntity>>.value(
            _FakeEither_0<_i5.Failure, _i6.UserEntity>(
          this,
          Invocation.method(
            #updateUser,
            [
              fullName,
              email,
              phoneNumber,
              currentPassword,
              newPassword,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.UserEntity>>);
}
