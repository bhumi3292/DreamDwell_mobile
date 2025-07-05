import 'package:dream_dwell/features/profile/presentation/view/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:dream_dwell/app/service_locator/service_locator.dart';
import 'package:dream_dwell/features/splash_screen/presentation/view/splash_view.dart';
import 'package:dream_dwell/features/splash_screen/presentation/widgets/theme.dart'; // Assuming this is getApplication()
import 'package:dream_dwell/features/auth/presentation/view/login.dart';
import 'package:dream_dwell/features/auth/presentation/view/signup.dart';
import 'package:dream_dwell/view/forgetPassword.dart'; // Make sure this path is correct
import 'package:dream_dwell/view/homeView.dart'; // Make sure this path is correct
import 'package:dream_dwell/features/dashbaord/dashboard.dart'; // Make sure this path is correct

// ViewModels
import 'package:dream_dwell/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:dream_dwell/features/profile/presentation/view_model/profile_view_model.dart'; // NEW

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginViewModel>(
          create: (_) => serviceLocator<LoginViewModel>(),
        ),
        BlocProvider<RegisterUserViewModel>(
          create: (_) => serviceLocator<RegisterUserViewModel>(),
        ),
        // Provide ProfileViewModel to the widget tree
        BlocProvider<ProfileViewModel>( // NEW
          create: (_) => serviceLocator<ProfileViewModel>(),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: getApplication(), // This uses the theme from splash_screen/presentation/widgets/theme.dart
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const SplashScreen()),
          GetPage(name: '/login', page: () => const Login()),
          GetPage(name: '/signup', page: () => const Signup()),
          GetPage(name: '/forget', page: () => const ForgetPassword()),
          GetPage(name: '/dashboard', page: () => const DashboardPage()),
          GetPage(name: '/home', page: () => const HomeView()),
          GetPage(name: '/profile', page: () => const ProfilePage()),
        ],
      ),
    );
  }
}