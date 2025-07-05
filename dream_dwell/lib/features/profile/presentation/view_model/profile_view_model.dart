import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dream_dwell/cores/common/snackbar/snackbar.dart';
import 'package:dream_dwell/cores/network/hive_service.dart';
import 'package:dream_dwell/features/auth/domain/use_case/user_get_current_usecase.dart';
import 'package:dream_dwell/features/profile/domain/use_case/upload_profile_picture_usecase.dart';
import 'package:dream_dwell/features/profile/presentation/view_model/profile_event.dart';
import 'package:dream_dwell/features/profile/presentation/view_model/profile_state.dart';

class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final UserGetCurrentUsecase userGetCurrentUsecase;
  final UploadProfilePictureUsecase uploadProfilePictureUsecase;
  final HiveService hiveService;

  ProfileViewModel({
    required this.userGetCurrentUsecase,
    required this.uploadProfilePictureUsecase,
    required this.hiveService,
  }) : super(const ProfileState.initial()) {
    on<FetchUserProfileEvent>(_onFetchUserProfile);
    on<UploadProfilePictureEvent>(_onUploadProfilePicture);
    on<UpdateLocalUserEvent>(_onUpdateLocalUser);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onFetchUserProfile(
      FetchUserProfileEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, successMessage: null));

    final result = await userGetCurrentUsecase.call();

    result.fold(
          (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
        showMySnackbar(
          context: event.context,
          content: 'Failed to load profile: ${failure.message}',
          isSuccess: false,
        );
      },
          (userEntity) {
        emit(state.copyWith(isLoading: false, user: userEntity));
      },
    );
  }

  Future<void> _onUploadProfilePicture(
      UploadProfilePictureEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isUploadingImage: true, errorMessage: null, successMessage: null));

    final result = await uploadProfilePictureUsecase.call(event.imageFile);

    result.fold(
          (failure) {
        emit(state.copyWith(isUploadingImage: false, errorMessage: failure.message));
        showMySnackbar(
          context: event.context,
          content: 'Failed to upload image: ${failure.message}',
          isSuccess: false,
        );
      },
          (newProfilePictureUrl) {
        final updatedUser = state.user?.copyWith(profilePicture: newProfilePictureUrl);
        emit(state.copyWith(
          isUploadingImage: false,
          user: updatedUser,
          successMessage: 'Profile picture updated!',
        ));
        showMySnackbar(
          context: event.context,
          content: 'Profile picture updated successfully!',
          isSuccess: true,
        );
      },
    );
  }

  void _onUpdateLocalUser(UpdateLocalUserEvent event, Emitter<ProfileState> emit) {
    if (event.profilePictureUrl != null && state.user != null) {
      final updatedUser = state.user!.copyWith(profilePicture: event.profilePictureUrl);
      emit(state.copyWith(user: updatedUser));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, successMessage: null, isLogoutSuccess: false));
    try {
      await hiveService.clearUserData();

      emit(state.copyWith(
        isLoading: false,
        isLogoutSuccess: true,
        user: null,
        successMessage: "Logged out successfully!",
      ));
      showMySnackbar(
        context: event.context,
        content: 'Logged out successfully!',
        isSuccess: true,
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isLogoutSuccess: false,
        errorMessage: 'Logout failed: $e',
      ));
      showMySnackbar(
        context: event.context,
        content: 'Logout failed: $e',
        isSuccess: false,
      );
    }
  }
}