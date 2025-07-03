import 'package:flutter/material.dart';
import 'package:dream_dwell/app/app.dart';
import 'package:dream_dwell/app/service_locator/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();
  runApp(const MyApp());
}
