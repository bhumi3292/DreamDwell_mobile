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
    context.read<ProfileViewModel>().add(FetchUserProfileEvent(context: context));
  }

  Future<void> _pickImage(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        context.read<ProfileViewModel>().add(
          UploadProfilePictureEvent(imageFile: File(pickedFile.path), context: context),
        );
      }
    } catch (e) {
      showMySnackbar(
        context: context,
        content: 'Failed to pick image: ${e.toString()}',
        isSuccess: false,
      );
    }
  }

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
            Navigator.of(context).pushReplacementNamed('/login');
          }
          if (state.errorMessage != null && !state.isLoading) {
            print("Profile Page Error: ${state.errorMessage}");
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

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _pickImage(context), // Tap to pick image
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.grey.shade200,
                        // Use NetworkImage if profilePicture is available and not empty
                        backgroundImage: (user.profilePicture != null && user.profilePicture!.isNotEmpty)
                            ? NetworkImage(user.profilePicture!) as ImageProvider<Object>?
                            : null, // No image, no backgroundImage
                        child: (user.profilePicture == null || user.profilePicture!.isEmpty)
                            ? Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.grey.shade600,
                        )
                            : null, // If image exists, no child icon
                      ),
                      if (state.isUploadingImage) // Show loading indicator during upload
                        const CircularProgressIndicator(),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildProfileInfoRow(
                          icon: Icons.person_outline,
                          label: 'Full Name',
                          value: user.fullName,
                        ),
                        const Divider(),
                        _buildProfileInfoRow(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: user.email,
                        ),
                        const Divider(),
                        _buildProfileInfoRow(
                          icon: Icons.phone,
                          label: 'Phone Number',
                          value: user.phoneNumber ?? 'N/A', // Handle nullable
                        ),
                        const Divider(),
                        _buildProfileInfoRow(
                          icon: Icons.assignment_ind_outlined,
                          label: 'Stakeholder',
                          value: user.stakeholder ?? 'N/A', // Handle nullable
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
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
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text('Logout', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileInfoRow({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}