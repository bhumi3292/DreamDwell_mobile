import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Feature imports
import 'package:dream_dwell/features/splash_screen/presentation/screen/splash.dart';
import 'package:dream_dwell/features/splash_screen/presentation/widgets/theme.dart';
import 'package:dream_dwell/features/splash_screen/presentation/widgets/nav_bar.dart';

// View imports
import 'package:dream_dwell/view/login.dart';
import 'package:dream_dwell/view/signup.dart';
import 'package:dream_dwell/view/forgetPassword.dart';
import 'package:dream_dwell/view/homeView.dart';
import 'package:dream_dwell/view/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplication(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => const Login()),
        GetPage(name: '/signup', page: () => const Signup()),
        GetPage(name: '/forget', page: () => const ForgetPassword()),
        GetPage(name: '/dashboard', page: () => const DashboardPage()),
        GetPage(name: '/home', page: () => const HomeView()),
      ],
    );
  }
}
