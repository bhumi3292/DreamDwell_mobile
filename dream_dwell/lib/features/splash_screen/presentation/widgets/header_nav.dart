import 'package:flutter/material.dart';
import 'package:dream_dwell/features/auth/domain/entity/user_entity.dart'; // Import UserEntity
import 'package:dream_dwell/features/add_property/presentation/view/add_property_presentation.dart';


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
            icon: const Icon(Icons.add_box, color: Colors.white),
            onPressed: () {
              // Navigate to AddPropertyScreen
            },
          ),
       // if (user != null && user!.stakeholder == 'Landlord')
          IconButton(
            icon: const Icon(
              Icons.add_home_work_outlined,
              color: Colors.white,
              size: 24.0,
            ),
            onPressed: () {

              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddPropertyPresentation()),
              );
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
