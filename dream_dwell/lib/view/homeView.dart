import 'package:flutter/material.dart';
import 'package:dream_dwell/features/splash_screen/presentation/widgets/header_nav.dart';
import 'package:dream_dwell/view/dashboard.dart';
import 'package:dream_dwell/view/explore.dart';
import 'package:dream_dwell/view/favourite.dart';
import 'package:dream_dwell/view/booking.dart';
import 'package:dream_dwell/view/profile.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DashboardPage(onSeeAllTap: () => _onItemTapped(1)),
      const ExplorePage(),
      const FavouritePage(),
      const BookingPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      appBar: const HeaderNav(),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 12,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF003366),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outlined), label: 'Favourite'),
          BottomNavigationBarItem(icon: Icon(Icons.book_online), label: 'Booking'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

