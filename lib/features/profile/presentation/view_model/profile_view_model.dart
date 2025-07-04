import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:dream_dwell/cores/common/snackbar/snackbar.dart';
import 'package:dream_dwell/features/auth/domain/use_case/user_get_current_usecase.dart';
import 'package:dream_dwell/cores/network/hive_service.dart';

import 'profile_event.dart';
import 'profile_state.dart';


class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final UserGetCurrentUsecase _userGetCurrentUsecase;
  final HiveService _hiveService;

  ProfileViewModel({
    required UserGetCurrentUsecase userGetCurrentUsecase,
    required HiveService hiveService,
  })  : _userGetCurrentUsecase = userGetCurrentUsecase,
        _hiveService = hiveService,
        super(const ProfileState.initial()) {
    on<FetchUserProfileEvent>(_onFetchUserProfile);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onFetchUserProfile(
      FetchUserProfileEvent event,
      Emitter<ProfileState> emit,
      ) async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    ));

    final result = await _userGetCurrentUsecase.call();

    result.fold(
          (failure) {
        emit(state.copyWith(
          isLoading: false,
          user: null,
          errorMessage: failure.message,
        ));
        if (event.context != null) {
          showMySnackbar(
            context: event.context!,
            content: "Failed to load profile: ${failure.message}",
            isSuccess: false,
          );
        }
      },
          (userEntity) {
        emit(state.copyWith(
          isLoading: false,
          user: userEntity,
          successMessage: "Profile loaded successfully.",
        ));
      },
    );
  }

  Future<void> _onLogout(
      LogoutEvent event,
      Emitter<ProfileState> emit,
      ) async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
      isLogoutSuccess: false,
    ));

    try {
      await _hiveService.deleteToken();

      emit(state.copyWith(
        isLoading: false,
        user: null,
        successMessage: "Logged out successfully.",
        isLogoutSuccess: true,
      ));
      if (event.context != null) {
        showMySnackbar(
          context: event.context!,
          content: "You have been logged out.",
          isSuccess: true,
        );
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: "Logout failed: ${e.toString()}",
        isLogoutSuccess: false,
      ));
      if (event.context != null) {
        showMySnackbar(
          context: event.context!,
          content: "Logout failed: ${e.toString()}",
          isSuccess: false,
        );
      }
    }
  }
}
