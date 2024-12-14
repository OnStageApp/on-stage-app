import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/login/presentation/widgets/gradient_overlay.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ImageStack extends StatelessWidget {
  const ImageStack({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        children: [
          Positioned(
            top: height * 0.1,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                height: height * 0.4,
                width: width * 0.5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      context.isDarkMode
                          ? 'assets/images/home_preview_screen_dark.png'
                          : 'assets/images/home_preview_screen.png',
                      fit: BoxFit.contain,
                    ),
                    const GradientOverlay(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: height * 0.12,
            right: width * 0.1,
            child: Image.asset(
              'assets/images/login_music_notes.png',
              height: height * 0.05,
              width: width * 0.2,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: height * 0.18,
            right: width * 0.15,
            child: Image.asset(
              'assets/images/login_person_blue.png',
              height: height * 0.08,
              width: width * 0.15,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: height * 0.3,
            left: width * 0.1,
            child: Image.asset(
              'assets/images/login_person_purple.png',
              height: height * 0.1,
              width: width * 0.2,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: height * 0.1,
            left: width * 0.1,
            child: Image.asset(
              'assets/images/login_person_green.png',
              height: height * 0.08,
              width: width * 0.15,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
