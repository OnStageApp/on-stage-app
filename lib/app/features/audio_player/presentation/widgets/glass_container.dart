import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class GlassContainer extends StatelessWidget {
  const GlassContainer({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 20),
            blurRadius: 30,
            color: Colors.black.withAlpha(context.isDarkMode ? 180 : 80),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 4),
            decoration: BoxDecoration(
              color: context.colorScheme.surface.withAlpha(200),
              borderRadius: BorderRadius.circular(16),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
