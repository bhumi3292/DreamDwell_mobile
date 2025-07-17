import 'package:cached_network_image/cached_network_image.dart';
import 'package:dream_dwell/app/constant/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart';
import 'package:dream_dwell/cores/common/snackbar/snackbar.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'dart:io'; // For File
import 'dart:typed_data'; // For Uint8List
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart' as img; // For image processing
import 'package:path_provider/path_provider.dart'; // For getTemporaryDirectory

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
    // Fetch user profile on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().add(FetchUserProfileEvent(context: context));
    });
  }

  // --- Image Picker Functionality ---
  Future<void> _showImagePickerDialog(BuildContext context) async {
    if (!mounted) return;

    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Choose Photo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Supported formats: JPEG, PNG, GIF, HEIC, WebP',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildImageOption(
                        icon: Icons.photo_library,
                        title: 'Gallery',
                        subtitle: 'Choose from gallery',
                        onTap: () {
                          Navigator.of(bc).pop();
                          _pickImage(ImageSource.gallery, context);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildImageOption(
                        icon: Icons.camera_alt,
                        title: 'Camera',
                        subtitle: 'Take a photo',
                        onTap: () {
                          Navigator.of(bc).pop();
                          _pickImage(ImageSource.camera, context);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // Method to pick image from chosen source (gallery or camera)
  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85, // Reduce quality to reduce file size
        maxWidth: 800, // Limit width
        maxHeight: 800, // Limit height
      );
      
      if (!mounted) return; // Check mounted after async operation

      if (pickedFile != null) {
        try {
          // Validate and convert image if needed
          final File processedImage = await _processImage(File(pickedFile.path));
          
          // Clear the current profile image cache before uploading new one
          await _clearProfileImageCache();
          
          context.read<ProfileViewModel>().add(
            UploadProfilePictureEvent(imageFile: processedImage, context: context),
          );
        } catch (e) {
          if (!mounted) return;
          showMySnackbar(
            context: context,
            content: e.toString(),
            isSuccess: false,
          );
        }
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

  // Method to process and validate image
  Future<File> _processImage(File imageFile) async {
    try {
      // Check file extension
      final String extension = imageFile.path.split('.').last.toLowerCase();
      final List<String> supportedFormats = ['jpg', 'jpeg', 'png', 'gif', 'heic', 'webp'];
      
      if (!supportedFormats.contains(extension)) {
        throw Exception('Unsupported image format. Please select JPEG, PNG, GIF, HEIC, or WebP image.');
      }
      
      // Read the image
      final List<int> imageBytes = await imageFile.readAsBytes();
      
      // Convert to Uint8List for image processing
      final Uint8List imageData = Uint8List.fromList(imageBytes);
      
      // Decode the image
      final img.Image? originalImage = img.decodeImage(imageData);
      
      if (originalImage == null) {
        throw Exception('Failed to decode image. Please try another image.');
      }
      
      // Resize image if it's too large
      img.Image resizedImage = originalImage;
      if (originalImage.width > 800 || originalImage.height > 800) {
        resizedImage = img.copyResize(originalImage, width: 800, height: 800);
      }
      
      // Convert to JPEG format for consistency
      final List<int> jpegBytes = img.encodeJpg(resizedImage, quality: 85);
      
      // Create a temporary file with proper JPEG extension
      final String tempDir = (await getTemporaryDirectory()).path;
      final String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String tempPath = '$tempDir/$fileName';
      final File processedFile = File(tempPath);
      
      // Write the processed image
      await processedFile.writeAsBytes(jpegBytes);
      
      // Verify the file was created and has the correct extension
      if (!await processedFile.exists()) {
        throw Exception('Failed to create processed image file.');
      }
      
      print('DEBUG: Processed image path: ${processedFile.path}');
      print('DEBUG: Processed image extension: ${processedFile.path.split('.').last}');
      print('DEBUG: Processed image size: ${await processedFile.length()} bytes');
      
      return processedFile;
    } catch (e) {
      print('Error processing image: $e');
      // If processing fails, return the original file
      return imageFile;
    }
  }

  // Method to clear profile image cache
  Future<void> _clearProfileImageCache() async {
    try {
      final user = context.read<ProfileViewModel>().state.user;
      if (user?.profilePicture != null && user!.profilePicture!.isNotEmpty) {
        final imageUrl = "http://192.168.1.6:3001${user.profilePicture}";
        await DefaultCacheManager().removeFile(imageUrl);
      }
    } catch (e) {
      print('Error clearing image cache: $e');
    }
  }
  // --- End Image Picker Functionality ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showMySnackbar(context: context, content: "Edit profile tapped!", isSuccess: true);
            },
          ),
        ],
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
              showMySnackbar(context: context, content: state.errorMessage!, isSuccess: false);
            }
          }
          if (!state.isUploadingImage && state.successMessage != null && state.successMessage!.contains('Profile picture updated')) {
            if (mounted) {
              showMySnackbar(
                context: context,
                content: 'Profile picture updated successfully!',
                isSuccess: true,
              );
              // The view model will automatically refresh the user data
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
          print(user?.profilePicture);

          if (user == null) {
            return const Center(
              child: Text("No profile data available. Please log in."),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header Section
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Profile Picture
                        GestureDetector(
                          onTap: () => _showImagePickerDialog(context),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 4),
                                ),
                                child: user.profilePicture != null && user.profilePicture!.isNotEmpty
                                    ? ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: "http://10.0.2.2:3001${user.profilePicture}",
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Container(
                                            width: 100,
                                            height: 100,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.person, size: 50, color: Colors.white),
                                          ),
                                          errorWidget: (context, url, error) => Container(
                                            width: 100,
                                            height: 100,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.person, size: 50, color: Colors.white),
                                          ),
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.grey[300],
                                        child: const Icon(Icons.person, size: 50, color: Colors.white),
                                      ),
                              ),
                              if (state.isUploadingImage)
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  child: const CircularProgressIndicator(color: Colors.white),
                                ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Theme.of(context).primaryColor,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // User Info
                        Text(
                          user.fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        if (user.stakeholder != null && user.stakeholder!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              user.stakeholder!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // Profile Stats Section
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.favorite,
                          title: 'Favourites',
                          value: '12',
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.visibility,
                          title: 'Profile Views',
                          value: '156',
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.star,
                          title: 'Rating',
                          value: '4.8',
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),

                // Menu Options Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Account Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildMenuItem(
                              icon: Icons.person_outline,
                              title: 'Edit Profile',
                              subtitle: 'Update your personal information',
                              onTap: () {
                                _showEditProfileDialog(context, user);
                              },
                            ),
                            _buildDivider(),
                            _buildMenuItem(
                              icon: Icons.settings,
                              title: 'Settings',
                              subtitle: 'App preferences and notifications',
                              onTap: () {
                                showMySnackbar(context: context, content: "Settings tapped!", isSuccess: true);
                              },
                            ),
                            _buildDivider(),
                            _buildMenuItem(
                              icon: Icons.payment,
                              title: 'Payments',
                              subtitle: 'Manage payment methods',
                              onTap: () {
                                showMySnackbar(context: context, content: "Payments tapped!", isSuccess: true);
                              },
                            ),
                            _buildDivider(),
                            _buildMenuItem(
                              icon: Icons.receipt_long,
                              title: 'Billing Details',
                              subtitle: 'View billing history',
                              onTap: () {
                                showMySnackbar(context: context, content: "Billing Details tapped!", isSuccess: true);
                              },
                            ),
                            _buildDivider(),
                            _buildMenuItem(
                              icon: Icons.help_outline,
                              title: 'Help & Support',
                              subtitle: 'Get help and contact support',
                              onTap: () {
                                showMySnackbar(context: context, content: "Help & Support tapped!", isSuccess: true);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Logout Section
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: _buildMenuItem(
                          icon: Icons.logout,
                          title: 'Logout',
                          subtitle: 'Sign out of your account',
                          isLogout: true,
                          onTap: () {
                            _showLogoutDialog(context);
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isLogout = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isLogout ? Colors.red.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isLogout ? Colors.red : Colors.grey[700],
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isLogout ? Colors.red : Colors.black,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: isLogout ? Colors.red : Colors.grey[400],
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 56, right: 16),
      child: Divider(color: Colors.grey[200], height: 1),
    );
  }

  void _showEditProfileDialog(BuildContext context, UserEntity user) {
    final TextEditingController _nameController = TextEditingController(text: user.fullName);
    final TextEditingController _emailController = TextEditingController(text: user.email);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Edit Profile"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final updatedName = _nameController.text;
              final updatedEmail = _emailController.text;

              if (updatedName.isEmpty || updatedEmail.isEmpty) {
                showMySnackbar(
                  context: context,
                  content: "Name and Email cannot be empty.",
                  isSuccess: false,
                );
                return;
              }

              context.read<ProfileViewModel>().add(
                UpdateUserProfileEvent(
                  context: context,
                  fullName: updatedName,
                  email: updatedEmail,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to sign out of your account?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ProfileViewModel>().add(LogoutEvent(context: context));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}