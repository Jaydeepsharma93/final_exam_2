import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 4),() {
     Navigator.pushReplacementNamed(context, '/home');
    },);
    return Scaffold(
      body: Center(
        child: Image.asset('assets/img/logo-Photoroom.png'),
      ),
    );
  }
}
