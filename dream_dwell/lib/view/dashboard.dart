import 'package:flutter/material.dart';
import 'package:dream_dwell/features/splash_screen/presentation/widgets/nav_bar.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(

        child: Text(

          "Welcome to the Dashboard",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF003366),
            // Changed for visibility
          ),
        ),
      ),

      bottomNavigationBar: const NavBar(),
    );
  }
}
