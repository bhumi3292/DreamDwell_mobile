import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart'; // Assuming UserEntity path
import 'package:dream_dwell/cores/common/snackbar/snackbar.dart'; // For snackbar utility

// Imports for your Profile BLoC
import 'package:dream_dwell/features/profile/presentation/view_model/profile_event.dart';
import 'package:dream_dwell/features/profile/presentation/view_model/profile_state.dart';
import 'package:dream_dwell/features/profile/presentation/view_model/profile_view_model.dart';

// Assuming you have a login page route
// import 'package:dream_dwell/features/auth/presentation/view/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Dispatch an event to fetch user profile data when the page initializes.
    context.read<ProfileViewModel>().add(FetchUserProfileEvent(context: context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Use BlocConsumer to listen to state changes and rebuild the UI
      body: BlocConsumer<ProfileViewModel, ProfileState>(
        listener: (context, state) {
          // Listen for logout success to navigate to the login page
          if (state.isLogoutSuccess) {
            // Optional: You can also show a snackbar here if not already handled by ViewModel
            // showMySnackbar(context: context, content: state.successMessage!, isSuccess: true);
            Navigator.of(context).pushReplacementNamed('/login'); // Navigate to login page
          }
          // Listen for errors from fetching profile or other operations
          if (state.errorMessage != null && !state.isLoading) {
            // SnackBar already shown by ViewModel, but can add more logic here if needed
            print("Profile Page Error: ${state.errorMessage}");
          }
        },
        builder: (context, state) {
          // Show loading indicator
          if (state.isLoading && state.user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          // Show error message if loading failed and no user data
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
                        // Retry fetching profile
                        context.read<ProfileViewModel>().add(FetchUserProfileEvent(context: context));
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }
          // Display profile content when data is loaded
          final UserEntity? user = state.user; // Get user data from state

          // Fallback for when user is null (e.g., initial state before fetch, or after error/logout)
          if (user == null) {
            return const Center(
              child: Text("No profile data available. Please log in."),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar & Profile Info Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      // TODO: Implement dynamic profile image loading if available in UserEntity
                      // For now, using a placeholder or default image
                      backgroundImage: AssetImage("assets/images/google.png"), // Default image
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            user.fullName, // Dynamic full name
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email, // Dynamic email
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          // Optionally display phone number or stakeholder
                          if (user.phoneNumber.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              user.phoneNumber,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                          if (user.stakeholder.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              user.stakeholder,
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
                        // TODO: Dispatch an event to navigate to an edit profile page
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Profile Options
                _buildListItem(Icons.settings, "Settings", onTap: () {
                  print("Settings clicked");
                  // TODO: Implement navigation to settings
                }),
                _buildListItem(Icons.payment, "Payments", onTap: () {
                  print("Payments clicked");
                  // TODO: Implement navigation to payments
                }),
                _buildListItem(Icons.receipt_long, "Billing Details", onTap: () {
                  print("Billing Details clicked");
                  // TODO: Implement navigation to billing details
                }),
                _buildListItem(Icons.person_outline, "My Account", onTap: () {
                  print("My Account clicked");
                  // TODO: Implement navigation to my account details
                }),
                _buildListItem(
                  Icons.logout,
                  "Logout",
                  isLogout: true,
                  onTap: () {
                    // Show confirmation dialog on logout tap
                    showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog( // Use dialogContext to avoid conflicts
                        title: const Text("Confirm Logout"),
                        content: const Text("Are you sure you want to exit?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext), // Close dialog
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(dialogContext); // Close dialog
                              // Dispatch LogoutEvent to the BLoC
                              // The BlocConsumer listener will handle the actual navigation
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
