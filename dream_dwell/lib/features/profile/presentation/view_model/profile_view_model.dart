import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:dream_dwell/cores/common/snackbar/snackbar.dart';
import 'package:dream_dwell/features/auth/domain/use_case/user_get_current_usecase.dart'; // NEW
import 'package:dream_dwell/cores/network/hive_service.dart'; // For logout functionality

import 'profile_event.dart';
import 'profile_state.dart';

class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final UserGetCurrentUsecase _userGetCurrentUsecase;
  final HiveService _hiveService; // Inject HiveService for logout

  ProfileViewModel({
    required UserGetCurrentUsecase userGetCurrentUsecase,
    required HiveService hiveService,
  })  : _userGetCurrentUsecase = userGetCurrentUsecase,
        _hiveService = hiveService,
        super(const ProfileState.initial()) {
    on<FetchUserProfileEvent>(_onFetchUserProfile);
    on<LogoutEvent>(_onLogout);
  }

  /// Handles the [FetchUserProfileEvent] to load user data.
  Future<void> _onFetchUserProfile(
      FetchUserProfileEvent event,
      Emitter<ProfileState> emit,
      ) async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null, // Clear previous errors
      successMessage: null, // Clear previous success messages
    ));

    final result = await _userGetCurrentUsecase.call(); // Call the use case

    result.fold(
          (failure) {
        emit(state.copyWith(
          isLoading: false,
          user: null, // Clear user data on error
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
          errorMessage: null, // Clear any previous errors
        ));
        // You can optionally show a success snackbar here
        // if (event.context != null) {
        //   showMySnackbar(
        //     context: event.context!,
        //     content: "Profile loaded.",
        //     isSuccess: true,
        //   );
        // }
      },
    );
  }

  /// Handles the [LogoutEvent] to log the user out.
  Future<void> _onLogout(
      LogoutEvent event,
      Emitter<ProfileState> emit,
      ) async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
      isLogoutSuccess: false, // Reset logout success flag
    ));

    try {
      // Delete the authentication token from Hive
      await _hiveService.deleteToken();

      emit(state.copyWith(
        isLoading: false,
        user: null, // Clear user data after logout
        successMessage: "Logged out successfully.",
        isLogoutSuccess: true, // Set success flag for listener
        errorMessage: null, // Clear any previous errors
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