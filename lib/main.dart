// main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(PVTApp());

class PVTApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PVT Test',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: HomeScreen(),
    );
  }
}
