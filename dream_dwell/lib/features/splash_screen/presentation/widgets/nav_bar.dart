import 'package:flutter/material.dart';
import 'package:dream_dwell/view/dashboard.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
      // Navigate to Dashboard when Home is tapped
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
        break;
      case 1:
      // dashboard
        break;
      case 2:
      // favourite
        break;
      case 3:
      // profile
        break;
      case 4:
      //booking page
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
      backgroundColor: Colors.grey,
      currentIndex: _selectedIndex,
      selectedItemColor: const Color(0xFF003366),
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Favourite',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book_online),
          label: 'Booking',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
