import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart'; // Required for BuildContext

/// Abstract base class for all profile-related events.
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Event to request fetching the current user's profile data.
/// [context] is optional, useful for showing UI feedback like snackbars directly from the BLoC.
class FetchUserProfileEvent extends ProfileEvent {
  final BuildContext? context;

  const FetchUserProfileEvent({this.context});

  @override
  List<Object?> get props => [context];
}

/// Event to initiate the user logout process.
/// [context] is optional, useful for navigation or showing UI feedback.
class LogoutEvent extends ProfileEvent {
  final BuildContext? context;

  const LogoutEvent({this.context});

  @override
  List<Object?> get props => [context];
}

// You can add more events here as profile functionality expands, e.g.:
// class UpdateProfileEvent extends ProfileEvent {
//   final UserEntity updatedUser;
//   const UpdateProfileEvent({required this.updatedUser});
//   @override
//   List<Object?> get props => [updatedUser];
// }

// class UploadProfilePictureEvent extends ProfileEvent {
//   final XFile imageFile; // Assuming image_picker package
//   const UploadProfilePictureEvent({required this.imageFile});
//   @override
//   List<Object?> get props => [imageFile];
// }
