import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ToxicTrackerApp());
}

class ToxicTrackerApp extends StatelessWidget {
  const ToxicTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '今天鸽了吗',
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.light,
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
