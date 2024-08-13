import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class BPMRangeSlider extends StatefulWidget {
  final Function(RangeValues) onChanged;

  const BPMRangeSlider({Key? key, required this.onChanged}) : super(key: key);

  @override
  _BPMRangeSliderState createState() => _BPMRangeSliderState();
}

class _BPMRangeSliderState extends State<BPMRangeSlider> {
  RangeValues _currentRangeValues = const RangeValues(60, 80);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('30', style: context.textTheme.titleMedium),
                  Text('50', style: context.textTheme.titleMedium),
                  Text('80', style: context.textTheme.titleMedium),
                  Text('120', style: context.textTheme.titleMedium),
                ],
              ),
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.transparent,
              inactiveTrackColor: Colors.transparent,
              rangeTrackShape: const BorderedRangeSliderTrackShape(
                borderWidth: 3,
                activeColor: Colors.transparent,
              ),
              trackHeight: 60,
              rangeThumbShape: const DotRangeSliderThumbShape(
                enabledThumbRadius: 15,
                dotColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              overlayShape: SliderComponentShape.noOverlay,
              activeTickMarkColor: Colors.transparent,
              inactiveTickMarkColor: Colors.transparent,
            ),
            child: RangeSlider(
              values: _currentRangeValues,
              min: 30,
              max: 120,
              divisions: 4,
              onChanged: (RangeValues values) {
                setState(() {
                  _currentRangeValues = values;
                });
                widget.onChanged(values);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BorderedRangeSliderTrackShape implements RangeSliderTrackShape {
  final double borderWidth;
  final Color borderColor;
  final Color activeColor;

  const BorderedRangeSliderTrackShape({
    this.borderWidth = 2.0,
    this.borderColor = Colors.blue,
    this.activeColor = Colors.blue,
  });

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double overlayWidth =
        sliderTheme.overlayShape!.getPreferredSize(isEnabled, isDiscrete).width;
    final double trackHeight = sliderTheme.trackHeight!;
    assert(overlayWidth >= 0);
    assert(trackHeight >= 0);
    assert(parentBox.size.width >= overlayWidth);
    assert(parentBox.size.height >= trackHeight);

    final double trackLeft = offset.dx + overlayWidth / 2;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - overlayWidth;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
    double additionalActiveTrackHeight = 2,
  }) {
    final Canvas canvas = context.canvas;

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    // Draw active track and border
    final Paint activePaint = Paint()..color = activeColor;
    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final double radius = 0;
    final Rect activeTrackRect = Rect.fromLTRB(
      startThumbCenter.dx,
      trackRect.top,
      endThumbCenter.dx,
      trackRect.bottom,
    );
    final RRect activeRRect = RRect.fromRectAndRadius(
      activeTrackRect,
      Radius.circular(radius),
    );

    canvas.drawRRect(activeRRect, activePaint);
    canvas.drawRRect(activeRRect, borderPaint);

    // Draw dots
    final double dotRadius = 1.5;
    final double dotSpacing = 4;
    final int dotsCount = 3;
    final double totalDotsWidth =
        (dotsCount * 2 * dotRadius) + ((dotsCount - 1) * dotSpacing);

    void drawDots(double startX) {
      final Paint dotPaint = Paint()..color = borderColor;
      for (int i = 0; i < dotsCount; i++) {
        final Offset dotCenter = Offset(
          startX + i * (2 * dotRadius + dotSpacing),
          trackRect.center.dy,
        );
        canvas.drawCircle(dotCenter, dotRadius, dotPaint);
      }
    }

    drawDots(startThumbCenter.dx + borderWidth + 4);
    drawDots(endThumbCenter.dx - borderWidth - 4 - totalDotsWidth);
  }
}

class DotRangeSliderThumbShape extends RangeSliderThumbShape {
  final double enabledThumbRadius;
  final Color dotColor;
  final Color backgroundColor;

  const DotRangeSliderThumbShape({
    this.enabledThumbRadius = 15.0,
    this.dotColor = Colors.blue,
    this.backgroundColor = Colors.white,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(enabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool isOnTop = false,
    bool isPressed = false,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isStart,
  }) {
    final canvas = context.canvas;

    final thumbRect = Rect.fromCenter(
      center: center,
      width: 35,
      height: 61,
    );

    final backgroundPaint = Paint()..color = backgroundColor;

    final isStart = thumb == Thumb.start;
    final leftCornerRadius = isStart ? const Radius.circular(10) : Radius.zero;
    final rightCornerRadius =
        !isStart ? const Radius.circular(10) : Radius.zero;

    final innerLeftCornerRadius =
        isPressed && isStart ? const Radius.circular(31) : Radius.zero;
    final innerRightCornerRadius =
        isPressed && !isStart ? const Radius.circular(8) : Radius.zero;

    final backgroundPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          thumbRect,
          topLeft: leftCornerRadius,
          bottomLeft: leftCornerRadius,
          topRight: rightCornerRadius,
          bottomRight: rightCornerRadius,
        ),
      )
      ..addRRect(
        RRect.fromRectAndCorners(
          thumbRect.deflate(6),
          topLeft: innerLeftCornerRadius,
          bottomLeft: innerLeftCornerRadius,
          topRight: innerRightCornerRadius,
          bottomRight: innerRightCornerRadius,
        ),
      );

    canvas.drawPath(backgroundPath, backgroundPaint);

    final borderPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(backgroundPath, borderPaint);

    final dotPaint = Paint()..color = dotColor;
    const dotSize = Size(3.0, 3.0);
    const dotSpacing = 2.4;
    const dotsCount = 6;
    const dotsPerColumn = 3;

    final totalHeight =
        (dotsPerColumn * dotSize.height) + ((dotsPerColumn - 1) * dotSpacing);
    final startY = center.dy - (totalHeight / 2);

    for (var i = 0; i < dotsCount; i++) {
      final columnIndex = i ~/ dotsPerColumn;
      final rowIndex = i % dotsPerColumn;

      final dotCenter = Offset(
        center.dx - 5.0 + (columnIndex * (dotSize.width + 5.0)),
        startY + (rowIndex * (dotSize.height + dotSpacing)),
      );

      final dotRect = Rect.fromCenter(
        center: dotCenter,
        width: dotSize.width,
        height: dotSize.height,
      );

      canvas.drawRect(dotRect, dotPaint);
    }
  }
}
