import 'package:flutter/material.dart';

class LoginPersonImages extends StatelessWidget {
  const LoginPersonImages({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Positioned(
          top: 95,
          left: 240,
          right: 0,
          child: Image.asset(
            'assets/images/login_music_notes.png',
            height: 38,
          ),
        ),
        Positioned(
          top: 140,
          left: 220,
          right: 0,
          child: Image.asset(
            'assets/images/login_person_blue.png',
            height: 62,
          ),
        ),
        Positioned(
          top: 230,
          left: -220,
          right: 0,
          child: Image.asset(
            'assets/images/login_person_purple.png',
            height: 72,
          ),
        ),
        Positioned(
          top: 80,
          left: -220,
          right: 0,
          child: Image.asset(
            'assets/images/login_person_green.png',
            height: 62,
          ),
        ),
      ],
    );
  }
}
