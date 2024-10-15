import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ToggleBackgroundPainter extends CustomPainter {
  ToggleBackgroundPainter({required this.isSelected, required this.context});

  final bool isSelected;
  final BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = context.colorScheme.surfaceBright
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final rect = RRect.fromRectAndRadius(
      Rect.fromPoints(Offset.zero, Offset(size.width, size.height)),
      const Radius.circular(12),
    );

    // Draw background
    canvas.drawRRect(rect, paint);

    // Draw border
    canvas.drawRRect(rect, borderPaint);

    // Define margins
    const double horizontalMargin = 4;
    const double verticalMargin = 4;

    final selectedRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        isSelected ? size.width / 2 + horizontalMargin : horizontalMargin,
        verticalMargin,
        (size.width / 2) - (2 * horizontalMargin),
        size.height - (2 * verticalMargin),
      ),
      const Radius.circular(10),
    );

    // Enhanced shadow for selected item
    final selectedShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    const shadowOffset = Offset(0, 2);
    final shadowRect = selectedRect.shift(shadowOffset);

    canvas.drawRRect(shadowRect, selectedShadowPaint);

    // Draw selected option background
    final selectedPaint = Paint()
      ..color = context.colorScheme.onSurfaceVariant
      ..style = PaintingStyle.fill;

    canvas.drawRRect(selectedRect, selectedPaint);

    // Draw border for selected item
    final selectedBorderPaint = Paint()
      ..color = context.colorScheme.onSecondaryFixedVariant
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawRRect(selectedRect, selectedBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
