import 'package:flutter/material.dart';
import 'dart:async';
import 'package:chargehub/pages/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the Login screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => const Login()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(31, 2, 75, 1.0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Splash screen image or logo
            Image.asset('assets/images/chargeHub.png', height: 500, width: 500),
            const SizedBox(height: 20),
            // Optional: Add a loading spinner or splash text
            const CircularProgressIndicator(color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
