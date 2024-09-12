import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/login/presentation/widgets/gradient_overlay.dart';

class ImageStack extends StatelessWidget {
  const ImageStack({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: SizedBox(
              width: 180,
              child: Image.asset(
                'assets/images/home_preview_screen.png',
                height: 290,
              ),
            ),
          ),
          const GradientOverlay(),
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
      ),
    );
  }
}
