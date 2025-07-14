import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import flutter_bloc

// Import your HeaderNav widget
import 'package:dream_dwell/features/splash_screen/presentation/widgets/header_nav.dart'; // Ensure this path is correct

// Import your BLoC and State for user profile
import 'package:dream_dwell/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:dream_dwell/features/profile/presentation/view_model/profile_state.dart';
import 'package:dream_dwell/features/profile/presentation/view_model/profile_event.dart'; // Needed to dispatch event

// Other page imports for BottomNavigationBar
import 'package:dream_dwell/features/dashbaord/dashboard.dart';
import 'package:dream_dwell/features/explore/presentation/view/explore_page.dart';
import 'package:dream_dwell/view/favourite.dart';
import 'package:dream_dwell/view/booking.dart';
import 'package:dream_dwell/features/profile/presentation/view/profile.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      DashboardPage(onSeeAllTap: () => _onItemTapped(1)),
      const ExplorePage(),
      const FavouritePage(),
      const BookingPage(),
      const ProfilePage(),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().add(FetchUserProfileEvent(context: context));
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Wrap HeaderNav in a PreferredSize widget with a BlocBuilder
      // This allows HeaderNav to rebuild when the ProfileState changes (e.g., user data loaded)
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<ProfileViewModel, ProfileState>(
          builder: (context, state) {
            // Debug: Print state information
            debugPrint("ProfileState - isLoading: ${state.isLoading}, user: ${state.user?.email}, stakeholder: ${state.user?.stakeholder}");
            
            // Pass the user entity from the ProfileState to the HeaderNav.
            // The HeaderNav will then use this user object to decide whether to show the icon.
            return HeaderNav(user: state.user);
          },
        ),
      ),
      body: pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        elevation: 12,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF003366),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensures all items are visible
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outlined), label: 'Favourite'),
          BottomNavigationBarItem(icon: Icon(Icons.book_online), label: 'Booking'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}