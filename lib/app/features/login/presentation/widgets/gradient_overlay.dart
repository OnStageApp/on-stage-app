import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class GradientOverlay extends StatelessWidget {
  const GradientOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 160,
      left: 0,
      right: 0,
      child: Container(
        width: 200,
        height: 300,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: const [0.5, 1],
            colors: [
              context.colorScheme.surface,
              context.colorScheme.surface.withOpacity(0.1),
            ],
          ),
        ),
      ),
    );
  }
}
