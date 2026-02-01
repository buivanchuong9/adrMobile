import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/sign_in_screen.dart';

void main() {
  runApp(const AdasApp());
}

class AdasApp extends StatelessWidget {
  const AdasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADAS Fleet Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SignInScreen(),
    );
  }
}
