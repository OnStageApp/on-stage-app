import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class StageTooltip extends StatefulWidget {
  const StageTooltip({
    required this.child,
    required this.message,
    this.preferBelow = true,
    this.arrowPosition = ArrowPosition.bottom,
    super.key,
  });

  final Widget child;
  final String message;
  final bool preferBelow;
  final ArrowPosition arrowPosition;

  @override
  State<StageTooltip> createState() => StageTooltipState();
}

enum ArrowPosition { left, right, top, bottom }

class StageTooltipState extends State<StageTooltip> {
  final SuperTooltipController _controller = SuperTooltipController();

  void showTooltip() {
    _controller.showTooltip();
  }

  void hideTooltip() {
    _controller.hideTooltip();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SuperTooltip(
      controller: _controller,
      showBarrier: false,
      content: Text(
        widget.message,
        style: const TextStyle(color: Colors.white),
      ),
      popupDirection:
          widget.preferBelow ? TooltipDirection.down : TooltipDirection.up,
      arrowTipDistance: 15.0,
      arrowBaseWidth: 20.0, // Reduce the base width to make the arrow straight
      arrowLength: 10.0,
      backgroundColor: Colors.grey[700]!,
      borderColor: Colors.transparent,
      borderWidth: 0,
      hasShadow: false,
      shadowColor: Colors.transparent,
      shadowBlurRadius: 4.0,
      shadowSpreadRadius: 1.0,
      touchThroughAreaShape: ClipAreaShape.rectangle,
      child: widget.child,
    );
  }
}
