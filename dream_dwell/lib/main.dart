// main.dart
import 'package:dream_dwell/cores/network/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:dream_dwell/app/app.dart';
import 'package:dream_dwell/app/service_locator/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize DI and Hive
  await initDependencies();
  await HiveService().init();

  runApp(const MyApp());
}
