import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFDDECF1),
        body: Center(child: Image.asset('assets/images/ic_launcher.png')),
      ),
    );
  }
}
