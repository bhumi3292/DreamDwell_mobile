import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart';
import 'package:dream_dwell/cores/common/snackbar/snackbar.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'dart:io'; // For File

// Imports for your Profile BLoC
import 'package:dream_dwell/features/profile/presentation/view_model/profile_event.dart';
import 'package:dream_dwell/features/profile/presentation/view_model/profile_state.dart';
import 'package:dream_dwell/features/profile/presentation/view_model/profile_view_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker(); // Initialize ImagePicker

  @override
  void initState() {
    super.initState();
    // Dispatch an event to fetch user profile data when the page initializes.
    // The context is passed to allow the ViewModel to show snackbars.
    context.read<ProfileViewModel>().add(FetchUserProfileEvent(context: context));
  }

  // --- Image Picker Functionality ---
  // Method to show camera/gallery options as a bottom sheet
  Future<void> _showImagePickerDialog(BuildContext context) async {
    if (!mounted) return;

    return showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  Navigator.of(bc).pop(); // Close the bottom sheet
                  _pickImage(ImageSource.gallery, context); // Call pick image from gallery
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(bc).pop(); // Close the bottom sheet
                  _pickImage(ImageSource.camera, context); // Call pick image from camera
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Method to pick image from chosen source (gallery or camera)
  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (!mounted) return; // Check mounted after async operation

      if (pickedFile != null) {
        context.read<ProfileViewModel>().add(
          UploadProfilePictureEvent(imageFile: File(pickedFile.path), context: context),
        );
      } else {
        showMySnackbar(
          context: context,
          content: 'Image picking cancelled.',
          isSuccess: false,
        );
      }
    } catch (e) {
      if (!mounted) return; // Check mounted after async operation

      showMySnackbar(
        context: context,
        content: 'Failed to pick image: ${e.toString()}',
        isSuccess: false,
      );
    }
  }
  // --- End Image Picker Functionality ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<ProfileViewModel, ProfileState>(
        listener: (context, state) {
          if (state.isLogoutSuccess) {
            if (mounted) {
              Navigator.of(context).pushReplacementNamed('/login');
            }
          }
          if (state.errorMessage != null && !state.isLoading) {
            if (mounted) {
              print("Profile Page Error: ${state.errorMessage}");
              // showMySnackbar(context: context, content: state.errorMessage!, isSuccess: false); // Optional: if ViewModel doesn't handle it
            }
          }
          if (!state.isUploadingImage && state.successMessage != null && state.successMessage!.contains('Profile picture updated')) {
            if (mounted) {
              showMySnackbar(
                context: context,
                content: 'Profile picture updated successfully!',
                isSuccess: true,
              );
              context.read<ProfileViewModel>().add(FetchUserProfileEvent(context: context));
            }
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null && state.user == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 50),
                    const SizedBox(height: 10),
                    Text(
                      state.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileViewModel>().add(FetchUserProfileEvent(context: context));
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }
          final UserEntity? user = state.user;

          if (user == null) {
            return const Center(
              child: Text("No profile data available. Please log in."),
            );
          }

          return Padding( // Changed SingleChildScrollView back to Padding as per image (fixed height header)
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
              children: [
                // Avatar & Profile Info Row - MATCHING THE IMAGE LAYOUT
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start of their cross axis
                  children: [
                    // Profile Picture with tap detection
                    GestureDetector(
                      onTap: () => _showImagePickerDialog(context),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: CachedNetworkImageProvider(
                              "http://10.0.2.2:3001${user.profilePicture}",
                            ),
                          ),
                          if (state.isUploadingImage)
                            const CircularProgressIndicator(),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 12, // Smaller camera icon
                              backgroundColor: Theme.of(context).primaryColor,
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8), // Small space for alignment
                          Text(
                            user.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              user.phoneNumber!,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                          if (user.stakeholder != null && user.stakeholder!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              user.stakeholder!,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.purple),
                      onPressed: () {
                        print("Edit button clicked");
                        showMySnackbar(context: context, content: "Edit profile tapped!", isSuccess: true);
                        // TODO: Dispatch an event to navigate to an edit profile page
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Profile Options
                _buildListItem(Icons.settings, "Settings", onTap: () {
                  print("Settings clicked");
                  showMySnackbar(context: context, content: "Settings tapped!", isSuccess: true);
                }),
                _buildListItem(Icons.payment, "Payments", onTap: () {
                  print("Payments clicked");
                  showMySnackbar(context: context, content: "Payments tapped!", isSuccess: true);
                }),
                _buildListItem(Icons.receipt_long, "Billing Details", onTap: () {
                  print("Billing Details clicked");
                  showMySnackbar(context: context, content: "Billing Details tapped!", isSuccess: true);
                }),
                _buildListItem(Icons.person_outline, "My Account", onTap: () {
                  print("My Account clicked");
                  showMySnackbar(context: context, content: "My Account tapped!", isSuccess: true);
                }),
                _buildListItem(
                  Icons.logout,
                  "Logout",
                  isLogout: true,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text("Confirm Logout"),
                        content: const Text("Are you sure you want to exit?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              context.read<ProfileViewModel>().add(LogoutEvent(context: context));
                            },
                            child: const Text("Yes"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Helper method to build consistent list tiles for profile options.
  Widget _buildListItem(
      IconData icon,
      String title, {
        bool isLogout = false,
        VoidCallback? onTap,
      }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Icon(icon, color: isLogout ? Colors.red : Colors.black),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isLogout ? Colors.red : Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }
}