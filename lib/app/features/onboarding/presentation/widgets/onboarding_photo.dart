import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class OnboardingPhoto extends StatefulWidget {
  const OnboardingPhoto({
    required this.imagePath,
    this.largeScreenImageFactor = 0.5,
    this.smallScreenImageFactor = 0.9,
    super.key,
  });
  final double largeScreenImageFactor;
  final double smallScreenImageFactor;

  final String imagePath;

  @override
  OnboardingPhotoState createState() => OnboardingPhotoState();
}

class OnboardingPhotoState extends State<OnboardingPhoto>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: FractionallySizedBox(
              widthFactor: context.isLargeScreen
                  ? widget.largeScreenImageFactor
                  : widget.smallScreenImageFactor,
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
