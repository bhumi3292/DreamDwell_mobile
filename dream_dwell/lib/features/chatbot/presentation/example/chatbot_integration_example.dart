import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:dream_dwell/features/splash_screen/presentation/widgets/header_nav.dart';
import 'package:dream_dwell/features/dashbaord/presentation/view/dashboard.dart';
import 'package:dream_dwell/features/explore/presentation/view/explore_page.dart';
import 'package:dream_dwell/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:dream_dwell/features/favourite/presentation/pages/favourite_page.dart';
import 'package:dream_dwell/features/booking/presentation/view/booking_page.dart';
import 'package:dream_dwell/features/profile/presentation/view/profile.dart';
import 'package:dream_dwell/app/service_locator/service_locator.dart';
import 'package:dream_dwell/features/chatbot/presentation/widget/chatbot_wrapper.dart';
import 'package:dream_dwell/features/chatbot/domain/use_case/send_chat_query_usecase.dart';

/// Example of how to integrate the chatbot into the HomeView
/// This shows how to wrap the existing HomeView with the ChatbotWrapper
class HomeViewWithChatbot extends StatefulWidget {
  const HomeViewWithChatbot({super.key});

  @override
  State<HomeViewWithChatbot> createState() => _HomeViewWithChatbotState();
}

class _HomeViewWithChatbotState extends State<HomeViewWithChatbot> {
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
      BlocProvider(
        create: (context) => serviceLocator<ExploreBloc>(),
        child: const ExplorePage(),
      ),
      const FavouritePage(),
      const BookingPage(),
      const ProfilePage(),
    ];

    return ChatbotWrapper(
      child: Scaffold(
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
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_outlined), label: 'Favourite'),
            BottomNavigationBarItem(icon: Icon(Icons.book_online), label: 'Booking'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

/// Example of how to integrate the chatbot into any other page
class AnyOtherPageWithChatbot extends StatelessWidget {
  const AnyOtherPageWithChatbot({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatbotWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Any Other Page'),
        ),
        body: const Center(
          child: Text('This page has the chatbot integrated!'),
        ),
      ),
    );
  }
}

/// Example of how to conditionally show/hide the chatbot
class ConditionalChatbotPage extends StatelessWidget {
  final bool showChatbot;
  
  const ConditionalChatbotPage({
    super.key,
    this.showChatbot = true,
  });

  @override
  Widget build(BuildContext context) {
    return ChatbotWrapper(
      showChatbot: showChatbot, // Control whether chatbot is shown
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Conditional Chatbot'),
        ),
        body: Center(
          child: Text(
            showChatbot 
                ? 'This page has the chatbot enabled!' 
                : 'This page has the chatbot disabled!',
          ),
        ),
      ),
    );
  }
} 