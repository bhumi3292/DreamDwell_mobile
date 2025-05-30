import 'package:flutter/material.dart';
import 'package:dream_dwell/features/splash_screen/presentation/widgets/header_nav.dart';
import 'package:dream_dwell/features/splash_screen/presentation/widgets/nav_bar.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: const Center(
          child: Text(
            "Welcome to the Dashboard",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003366),
            ),
          ),
        ),

      ),
    );
  }
}

