import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class TempoRangeSlider extends StatefulWidget {
  const TempoRangeSlider({
    required this.startValue,
    required this.endValue,
    super.key,
    this.onChanged,
  });

  final int startValue;
  final int endValue;
  final void Function(int start, int end)? onChanged;

  @override
  State<TempoRangeSlider> createState() => _TempoRangeSliderState();
}

class _TempoRangeSliderState extends State<TempoRangeSlider> {
  static const int minValue = 30;
  static const int maxValue = 120;
  static const int minRange = 40;

  int _startValue = 60;
  int _endValue = 80;

  @override
  void initState() {
    super.initState();
    _startValue = widget.startValue;
    _endValue = widget.endValue;
  }

  void _updateValues(double dx, BoxConstraints constraints, bool isStart) {
    final fullWidth = constraints.maxWidth;
    const int valueRange = maxValue - minValue;

    // Calculate relative position based on drag side
    if (isStart) {
      // For start handle
      final double position = dx.clamp(0, fullWidth);
      double newValue = minValue + (position / fullWidth) * valueRange;
      // Snap to steps of 10
      newValue = (newValue / 10).round() * 10;
      setState(() {
        _startValue = newValue.clamp(minValue, _endValue - minRange).toInt();
      });
    } else {
      // For end handle
      final double position = (dx.clamp(0, fullWidth));
      double newValue = minValue + (position / fullWidth) * valueRange;
      // Snap to steps of 10
      newValue = (newValue / 10).round() * 10;
      setState(() {
        _endValue = newValue.clamp(_startValue + minRange, maxValue).toInt();
      });
    }

    widget.onChanged?.call(_startValue, _endValue);
  }

  Widget _buildDots() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (row) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              2,
              (col) => Container(
                width: 3,
                height: 3,
                margin: const EdgeInsets.symmetric(
                    horizontal: 0.78, vertical: 0.78),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'BPM',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final double fullWidth = constraints.maxWidth;
            final double startPosition =
                (_startValue - minValue) / (maxValue - minValue) * fullWidth;
            final double endPosition =
                (_endValue - minValue) / (maxValue - minValue) * fullWidth;

            return SizedBox(
              height: 56,
              child: Stack(
                children: [
                  // Background track
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: context.colorScheme.onSurfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '30',
                            style: context.textTheme.titleMedium,
                          ),
                          Text(
                            '120+',
                            style: context.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Blue range selection
                  // Blue range selection
                  Positioned(
                    left: startPosition,
                    width: endPosition - startPosition,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            (_startValue == minValue && _endValue == maxValue)
                                ? context.colorScheme.outline
                                : Colors.blue,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onHorizontalDragUpdate: (details) {
                              final RenderBox box =
                                  context.findRenderObject() as RenderBox;
                              final Offset localPosition =
                                  box.globalToLocal(details.globalPosition);
                              _updateValues(
                                  localPosition.dx, constraints, true);
                            },
                            child: Container(
                              width: 32,
                              decoration: BoxDecoration(
                                color: (_startValue == minValue &&
                                        _endValue == maxValue)
                                    ? context.colorScheme.outline
                                    : Colors.blue,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                              child: _buildDots(),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: context.colorScheme.onSurfaceVariant,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  '${_startValue.round()} - ${_endValue == maxValue ? '${maxValue}+' : _endValue.round()}',
                                  style: context.textTheme.titleMedium,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onHorizontalDragUpdate: (details) {
                              final RenderBox box =
                                  context.findRenderObject() as RenderBox;
                              final Offset localPosition =
                                  box.globalToLocal(details.globalPosition);
                              _updateValues(
                                  localPosition.dx, constraints, false);
                            },
                            child: Container(
                              width: 32,
                              decoration: BoxDecoration(
                                color: (_startValue == minValue &&
                                        _endValue == maxValue)
                                    ? context.colorScheme.outline
                                    : Colors.blue,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              child: _buildDots(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
