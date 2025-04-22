import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SpinionsApp());
}

class SpinionsApp extends StatelessWidget {
  const SpinionsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spinions',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      home: const HomeScreen(), // Home screen now imported cleanly
    );
  }
}
