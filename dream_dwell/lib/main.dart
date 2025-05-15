import 'package:dream_dwell/view/splash.dart';
import 'package:flutter/material.dart';
import 'package:dream_dwell/view/login.dart';

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
        fontFamily: 'Roboto', // Optional: set a global font
      ),
      home: SplashScreen(),
      routes: {
        'Splash': (context) => const PlaceholderScreen(title: 'Splash'),

      },
    );
  }
}

// Temporary placeholders for navigation targets
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('This is the $title')),
    );
  }
}
