import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paarth_holidays/screens/splash/splash_screen.dart';
import 'package:paarth_holidays/core/theme/app_theme.dart';
import 'screens/home/leads/contact_picker_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Paarth Holidays',
      theme: AppTheme.lightTheme,
      home: SplashScreen(),
    );
  }
}
