import 'package:flutter/material.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart'; // Import UserEntity
import 'package:dream_dwell/features/add_property/presentation/view/add_property_presentation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dream_dwell/features/chat/presentation/page/chat_page.dart';
import 'package:dream_dwell/app/shared_pref/token_shared_prefs.dart';
import 'package:dream_dwell/app/service_locator/service_locator.dart';


class HeaderNav extends StatefulWidget implements PreferredSizeWidget {
  final UserEntity? user;
  final VoidCallback? onLandlordHomePressed;

  const HeaderNav({
    super.key,
    this.user,
    this.onLandlordHomePressed,
  });

  @override
  State<HeaderNav> createState() => _HeaderNavState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Standard AppBar height
}

class _HeaderNavState extends State<HeaderNav> {
  String? _role;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _role = prefs.getString('role');
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('HeaderNav user.stakeholder:  \u001b[33m \u001b[1m \u001b[4m${_role} \u001b[0m'); // DEBUG: print role
    return AppBar(
      backgroundColor: const Color(0xFF003366),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          debugPrint("Menu button pressed");
        },
      ),
      centerTitle: true,
      actions: [
        if ((_role?.trim().toLowerCase() == 'landlord'))
          IconButton(
            icon: const Icon(Icons.add_home_work_outlined, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddPropertyPresentation()),
              );
              widget.onLandlordHomePressed?.call();
              debugPrint("Landlord Home icon pressed (via callback)");
            },
          ),
        IconButton(
          icon: const Icon(Icons.message, color: Colors.white),
          onPressed: () async {
            // Get userId from shared preferences
            final result = await serviceLocator<TokenSharedPrefs>().getUserId();
            final userId = result.fold((failure) => null, (userId) => userId);
            if (userId != null && mounted) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChatPage(currentUserId: userId),
                ),
              );
            } else {
              // Optionally show a snackbar or dialog if userId is not available
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Unable to open chats: user not found.')),
                );
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.white),
          onPressed: () {
            debugPrint("Notifications button pressed");
          },
        ),
      ],
    );
  }
}
