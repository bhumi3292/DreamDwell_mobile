import 'package:dream_dwell/app/service_locator/service_locator.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import your views
import 'package:dream_dwell/features/splash_screen/presentation/view/splash_view.dart';
import 'package:dream_dwell/features/splash_screen/presentation/widgets/theme.dart';
import 'package:dream_dwell/features/auth/presentation/view/login.dart';
import 'package:dream_dwell/features/auth/presentation/view/signup.dart';
import 'package:dream_dwell/view/forgetPassword.dart';
import 'package:dream_dwell/view/homeView.dart';
import 'package:dream_dwell/view/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginViewModel>(
          create: (_) => serviceLocator<LoginViewModel>(),
        ),
        // Add other global BlocProviders here if needed
      ],
      child: GetMaterialApp(
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
      ),
    );
  }
}