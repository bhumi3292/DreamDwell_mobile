import 'package:flutter/material.dart';
import 'package:dream_dwell/features/splash_screen/presentation/screen/splash.dart';
import 'package:dream_dwell/view/login.dart';
import 'package:dream_dwell/view/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DreamDwell',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const Login(),
        '/signup': (context) => const Signup(),
        '/forget': (context) => Scaffold(body: Center(child: Text('Forgot Password Screen'))), // Placeholder
      },
    );
  }
}
