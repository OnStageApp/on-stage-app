import 'package:flutter/material.dart';

class InfoIcon extends StatelessWidget {
  const InfoIcon({
    required this.message,
    this.iconColor = Colors.grey,
    this.waitDuration = const Duration(milliseconds: 500),
    super.key,
  });

  final String message;
  final Color iconColor;
  final Duration waitDuration;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      waitDuration: waitDuration,
      showDuration: const Duration(seconds: 5),
      triggerMode: TooltipTriggerMode.tap,
      child: Icon(
        Icons.info_outline,
        color: iconColor,
        size: 16,
      ),
    );
  }
}
