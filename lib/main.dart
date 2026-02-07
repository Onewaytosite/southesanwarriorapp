import 'package:flutter/material.dart';
import 'pin_screen.dart';

void main() {
  runApp(const PasswordApp());
}

class PasswordApp extends StatelessWidget {
  const PasswordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Secure Pass 2026',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1C1E26),
        useMaterial3: true, // ใช้มาตรฐาน Material 3
      ),
      home: const PinScreen(),
    );
  }
}