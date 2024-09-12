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
          height: 800,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.center,
              stops: const [0, 0.8],
              colors: [
                context.colorScheme.primary.withOpacity(0.1),
                context.colorScheme.surface,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
