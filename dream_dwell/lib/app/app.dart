import 'package:dream_dwell/app/service_locator/service_locator.dart';
import 'package:dream_dwell/features/auth/domain/use_case/user_get_current_usecase.dart';
import 'package:dream_dwell/features/auth/presentation/view/login.dart';
import 'package:dream_dwell/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginViewModel>(
          create: (_) => serviceLocator<LoginViewModel>()
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Login(),
      ),
    );
  }
}
