import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/dashboard_screen.dart';

void main() {
  runApp(const SakuSiswaApp());
}

class SakuSiswaApp extends StatelessWidget {
  const SakuSiswaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SakuSiswa',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ), // ThemeData
      home: const DashboardScreen(),
    ); // MaterialApp
  }
}

// DashboardScreen dipindahkan ke lib/views/dasboard_screen.dart