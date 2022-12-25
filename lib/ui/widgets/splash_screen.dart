import 'dart:async';
import 'package:flutter/material.dart';
import 'package:okuol_movie_app/core/constants/colors.dart';
import 'package:okuol_movie_app/ui/views/home_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 4),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const HomeView(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kcPrimaryColor,
      body: Center(
        child: Image.asset('assets/popcorn.gif'),
      ),
    );
  }
}
