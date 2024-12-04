import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Opacity(
        opacity: 0.2,
        child: Container(
          height: 1200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              stops: const [0, 0.6],
              colors: [
                context.colorScheme.primary.withOpacity(0.3),
                context.colorScheme.surface,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
