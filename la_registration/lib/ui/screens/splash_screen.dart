import 'package:flutter/material.dart';
import 'package:la_registration/ui/screens/tabbed_main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key}); // Добавлен параметр key

  @override
  SplashScreenState createState() =>
      SplashScreenState(); // Изменено имя на публичное
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Переход к основному экрану через 3 секунды
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TabbedMainScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
