import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ScrollingPlayEffect extends BasicIndicatorEffect {
  final double activeStrokeWidth;
  final double activeDotScale;
  final double activeDotWidthScale;
  final int maxVisibleDots;
  final bool fixedCenter;
  final List<int> secondColorIndexes;
  final Color secondColor;

  const ScrollingPlayEffect({
    this.activeStrokeWidth = 1.5,
    this.activeDotScale = 1.3,
    this.activeDotWidthScale = 2.0,
    this.maxVisibleDots = 5,
    this.fixedCenter = false,
    this.secondColorIndexes = const [],
    this.secondColor = Colors.red,
    double offset = 16.0,
    double dotWidth = 16.0,
    double dotHeight = 16.0,
    double spacing = 8.0,
    double radius = 16,
    Color dotColor = Colors.grey,
    Color activeDotColor = Colors.indigo,
    double strokeWidth = 1.0,
    PaintingStyle paintStyle = PaintingStyle.fill,
  })  : assert(activeDotScale >= 0.0),
        assert(maxVisibleDots >= 5 && maxVisibleDots % 2 != 0),
        super(
          dotWidth: dotWidth,
          dotHeight: dotHeight,
          spacing: spacing,
          radius: radius,
          strokeWidth: strokeWidth,
          paintStyle: paintStyle,
          dotColor: dotColor,
          activeDotColor: activeDotColor,
        );

  @override
  Size calculateSize(int count) {
    final extraWidth = dotWidth * (activeDotWidthScale - 1);
    var width =
        (dotWidth + spacing) * (min(count, maxVisibleDots)) + extraWidth / 2;
    if (fixedCenter && count <= maxVisibleDots) {
      width = ((count * 2) - 1) * (dotWidth + spacing) + extraWidth / 2;
    }
    return Size(width, dotHeight * activeDotScale);
  }

  @override
  int hitTestDots(double dx, int count, double current) {
    final switchPoint = (maxVisibleDots / 2).floor();
    if (fixedCenter) {
      return super.hitTestDots(dx, count, current) -
          switchPoint +
          current.floor();
    } else {
      final firstVisibleDot =
          (current < switchPoint || count - 1 < maxVisibleDots)
              ? 0
              : min(current - switchPoint, count - maxVisibleDots).floor();
      final lastVisibleDot =
          min(firstVisibleDot + maxVisibleDots, count - 1).floor();
      var offset = 0.0;
      for (var index = firstVisibleDot; index <= lastVisibleDot; index++) {
        if (dx <= (offset += dotWidth + spacing)) {
          return index;
        }
      }
    }
    return -1;
  }

  @override
  BasicIndicatorPainter buildPainter(int count, double offset) {
    return ScrollingDotsPainter(
      count: count,
      offset: offset,
      effect: this,
    );
  }
}

class ScrollingDotsPainter extends BasicIndicatorPainter {
  final ScrollingPlayEffect effect;

  ScrollingDotsPainter({
    required this.effect,
    required int count,
    required double offset,
  }) : super(offset, count, effect);

  @override
  void paint(Canvas canvas, Size size) {
    final current = offset.floor();
    final next = (current + 1).clamp(0, count - 1);
    final dotOffset = offset - current;

    final switchPoint = (effect.maxVisibleDots / 2).floor();
    final firstVisibleDot =
        (current < switchPoint || count - 1 < effect.maxVisibleDots)
            ? 0
            : min(current - switchPoint, count - effect.maxVisibleDots);
    final lastVisibleDot =
        min(firstVisibleDot + effect.maxVisibleDots, count - 1);
    final inPreScrollRange = current < switchPoint;
    final inAfterScrollRange = current >= (count - 1) - switchPoint;
    final willStartScrolling = (current + 1) == switchPoint + 1;
    final willStopScrolling = current + 1 == (count - 1) - switchPoint;

    final dotPaint = Paint()
      ..strokeWidth = effect.strokeWidth
      ..style = effect.paintStyle;

    final drawingAnchor = (inPreScrollRange || inAfterScrollRange)
        ? -(firstVisibleDot * distance)
        : -((offset - switchPoint) * distance);

    const smallDotScale = 0.66;
    final activeScale = effect.activeDotScale - 1.0;

    var cumulativeExtraSpacing = 0.0;

    for (var index = firstVisibleDot; index <= lastVisibleDot; index++) {
      var color = effect.dotColor;
      var scale = 1.0;
      var widthScale = 1.0;
      var extraSpacing = 0.0;

      if (index == current) {
        color = Color.lerp(
            effect.activeDotColor,
            effect.secondColorIndexes.contains(index)
                ? effect.secondColor
                : effect.dotColor,
            dotOffset)!;
        scale = effect.activeDotScale - (activeScale * dotOffset);
        widthScale = effect.activeDotWidthScale -
            ((effect.activeDotWidthScale - 1) * dotOffset);
        extraSpacing = 16 *
            (1.0 - dotOffset); // Add 8 points of extra space, transitioning out
      } else if (index == next) {
        final startColor = effect.secondColorIndexes.contains(index)
            ? effect.secondColor
            : effect.dotColor;
        color = Color.lerp(startColor, effect.activeDotColor, dotOffset)!;
        scale = 1.0 + (activeScale * dotOffset);
        widthScale = 1.0 + ((effect.activeDotWidthScale - 1) * dotOffset);
        extraSpacing =
            16 * dotOffset; // Add 8 points of extra space, transitioning in
      } else {
        color = effect.secondColorIndexes.contains(index)
            ? effect.secondColor
            : effect.dotColor;
        widthScale = 1.0;

        if (count - 1 < effect.maxVisibleDots) {
          scale = 1.0;
        } else if (index == firstVisibleDot) {
          if (willStartScrolling) {
            scale = (1.0 * (1.0 - dotOffset));
          } else if (inAfterScrollRange) {
            scale = smallDotScale;
          } else if (!inPreScrollRange) {
            scale = smallDotScale * (1.0 - dotOffset);
          }
        } else if (index == firstVisibleDot + 1 &&
            !(inPreScrollRange || inAfterScrollRange)) {
          scale = 1.0 - (dotOffset * (1.0 - smallDotScale));
        } else if (index == lastVisibleDot - 1.0) {
          if (inPreScrollRange) {
            scale = smallDotScale;
          } else if (!inAfterScrollRange) {
            scale = smallDotScale + ((1.0 - smallDotScale) * dotOffset);
          }
        } else if (index == lastVisibleDot) {
          if (inPreScrollRange) {
            scale = 0.0;
          } else if (willStopScrolling) {
            scale = dotOffset;
          } else if (!inAfterScrollRange) {
            scale = smallDotScale * dotOffset;
          }
        }
      }

      final scaledWidth = effect.dotWidth * widthScale * scale;
      final scaledHeight = effect.dotHeight * scale;
      final yPos = size.height / 2;

      final basePosition = effect.dotWidth / 2 +
          drawingAnchor +
          (index * distance) +
          cumulativeExtraSpacing;
      final extraWidth = effect.dotWidth * (widthScale - 1);
      final xPos = basePosition + (extraWidth / 2);

      final rRect = RRect.fromLTRBR(
        xPos - scaledWidth / 2 + effect.spacing / 2,
        yPos - scaledHeight / 2,
        xPos + scaledWidth / 2 + effect.spacing / 2,
        yPos + scaledHeight / 2,
        dotRadius * scale,
      );

      canvas.drawRRect(rRect, dotPaint..color = color);

      cumulativeExtraSpacing += extraSpacing;

      double iconOpacity = 0.0;
      if (index == current) {
        iconOpacity = 1.0 - dotOffset;
      } else if (index == next) {
        iconOpacity = dotOffset;
      }

      if (iconOpacity > 0.0) {
        // Create a custom painter for the filled icon
        final iconPainter = Paint()
          ..color = Colors.white.withOpacity(iconOpacity)
          ..style = PaintingStyle.fill
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

        // Scale for the icon
        final iconSize = scaledHeight * 0.8;

        // Save the current canvas state
        canvas.save();

        // Move to the icon position and scale
        canvas.translate(
          xPos - scaledWidth / 2 + effect.spacing / 2 + 4,
          yPos - iconSize / 2,
        );
        canvas.scale(iconSize / 24); // Lucide icons are designed for 24x24

        // Draw the rounded play icon
        final path = Path();

        // Create a rounded triangle using quadratic bezier curves
        path.moveTo(7, 4); // Start at top
        path.lineTo(17, 12); // Peak of triangle
        path.lineTo(7, 20); // Bottom point

        // Add the rounded corner back to start
        path.quadraticBezierTo(5, 18, 5, 16); // Bottom round
        path.lineTo(5, 8); // Back side
        path.quadraticBezierTo(5, 6, 7, 4); // Top round

        path.close();

        canvas.drawPath(path, iconPainter);

        // Restore the canvas state
        canvas.restore();
      }
    }
  }
}
