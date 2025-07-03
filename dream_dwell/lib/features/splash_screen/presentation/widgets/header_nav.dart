import 'package:flutter/material.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart'; // Import UserEntity


class HeaderNav extends StatelessWidget implements PreferredSizeWidget {
  final UserEntity? user;
  final VoidCallback? onLandlordHomePressed;

  const HeaderNav({
    super.key,
    this.user,
    this.onLandlordHomePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF003366),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          // TODO: Implement action to open a drawer or navigate to a main menu.
          debugPrint("Menu button pressed");
        },
      ),
      centerTitle: true,
      actions: [

        if (user != null && user!.stakeholder == 'Landlord')
          IconButton(
            icon: const Icon(
              Icons.home,
              color: Colors.white,
              size: 24.0,
            ),
            onPressed: () {
              // INVOKE CALLBACK: If the callback is provided, execute it.
              // This allows the parent widget to handle the navigation.
              onLandlordHomePressed?.call();
              debugPrint("Landlord Home icon pressed (via callback)");
            },
          ),
        IconButton(
          icon: const Icon(Icons.message, color: Colors.white),
          onPressed: () {
            // TODO: Implement navigation to a messages/chat screen.
            debugPrint("Messages button pressed");
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.white),
          onPressed: () {
            // TODO: Implement navigation to a notifications screen.
            debugPrint("Notifications button pressed");
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Standard AppBar height
}
