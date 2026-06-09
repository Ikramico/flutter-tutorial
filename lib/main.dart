import 'package:flutter/material.dart';
import 'features/home/home_screen.dart';

void main() {
  runApp(const FlutterMasteryApp());
}

class FlutterMasteryApp extends StatelessWidget {
  const FlutterMasteryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Mastery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF8F9FC),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}
