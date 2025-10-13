import 'dart:async';
import 'package:flutter/material.dart';
import 'package:saksham_digital/Test.dart';
import 'package:saksham_digital/User/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart';


class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  bool b = false;

  @override
  void initState() {
    super.initState();
    _saveSess();
    Timer(const Duration(seconds: 3), () {
      if (b == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Test()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  Future<void> _saveSess() async {
    final mprefs = await SharedPreferences.getInstance();
    b = (mprefs.getBool('real')) ?? false; // fallback if null
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: Image.asset(
          "assets/saks.gif",
          fit: BoxFit.cover, // makes gif fullscreen while keeping aspect ratio
        ),
      ),
    );
  }
}
