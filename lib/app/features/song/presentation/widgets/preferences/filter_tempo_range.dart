import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/search/application/search_notifier.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class TempoRangeSlider extends ConsumerStatefulWidget {
  const TempoRangeSlider({
    super.key,
    this.onChanged,
  });

  final void Function(int start, int end)? onChanged;

  @override
  ConsumerState<TempoRangeSlider> createState() => _TempoRangeSliderState();
}

class _TempoRangeSliderState extends ConsumerState<TempoRangeSlider> {
  static const int minValue = 30;
  static const int maxValue = 120;
  static const int minRange = 40;

  int _startValue = 60;
  int _endValue = 80;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _startValue = ref.watch(searchNotifierProvider).tempoFilter?.min ?? 30;
        _endValue = ref.watch(searchNotifierProvider).tempoFilter?.max ?? 120;
      });
    });
  }

  void _updateValues(double dx, BoxConstraints constraints, bool isStart) {
    final fullWidth = constraints.maxWidth;
    const valueRange = maxValue - minValue;

    // Calculate relative position based on drag side
    if (isStart) {
      // For start handle
      final position = dx.clamp(0, fullWidth);
      var newValue = minValue + (position / fullWidth) * valueRange;
      // Snap to steps of 10
      newValue = (newValue / 10).round() * 10;
      setState(() {
        _startValue = newValue.clamp(minValue, _endValue - minRange).toInt();
      });
    } else {
      // For end handle
      final position = dx.clamp(0, fullWidth);
      var newValue = minValue + (position / fullWidth) * valueRange;
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
          padding: const EdgeInsets.symmetric(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              2,
              (col) => Container(
                width: 3,
                height: 3,
                margin: const EdgeInsets.symmetric(
                  horizontal: 0.78,
                  vertical: 0.78,
                ),
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

  void _listenForFilterReset() {
    ref.listen(searchNotifierProvider, (prev, next) {
      if (prev?.tempoFilter != null && next.tempoFilter == null) {
        setState(() {
          _startValue = minValue;
          _endValue = maxValue;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _listenForFilterReset();
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
            final fullWidth = constraints.maxWidth;
            final startPosition =
                (_startValue - minValue) / (maxValue - minValue) * fullWidth;
            final endPosition =
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
                              final box =
                                  context.findRenderObject()! as RenderBox;
                              final localPosition =
                                  box.globalToLocal(details.globalPosition);
                              _updateValues(
                                localPosition.dx,
                                constraints,
                                true,
                              );
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
                                  '$_startValue - ${_endValue == maxValue ? '$maxValue+' : _endValue}',
                                  style: context.textTheme.titleMedium,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onHorizontalDragUpdate: (details) {
                              final box =
                                  context.findRenderObject()! as RenderBox;
                              final localPosition =
                                  box.globalToLocal(details.globalPosition);
                              _updateValues(
                                localPosition.dx,
                                constraints,
                                false,
                              );
                            },
                            child: Container(
                              width: 32,
                              decoration: BoxDecoration(
                                color: (_startValue == minValue &&
                                        _endValue == maxValue)
                                    ? context.colorScheme.outline
                                    : Colors.blue,
                                borderRadius: const BorderRadius.only(
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
