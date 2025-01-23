import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/environment_manager.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          EnvironmentManager.currentEnvironment != AppEnvironment.production,
      home: Scaffold(
        backgroundColor: const Color(0xFFDDECF1),
        body: Center(child: Image.asset('assets/images/ic_launcher.png')),
      ),
    );
  }
}
