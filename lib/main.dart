// main.dart
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PVTApp());
}

class PVTApp extends StatelessWidget {
  const PVTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PVT Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashToHome(),
    );
  }
}

class SplashToHome extends StatefulWidget {
  const SplashToHome({super.key});

  @override
  State<SplashToHome> createState() => _SplashToHomeState();
}

class _SplashToHomeState extends State<SplashToHome> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showSplash ? const SplashScreen() : const HomeScreen();
  }
}
