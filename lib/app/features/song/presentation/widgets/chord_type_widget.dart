import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ChordTypeWidget extends StatelessWidget {
  const ChordTypeWidget({
    required this.chordType,
    required this.isSharp,
    required this.onTap,
    this.isEnabled = true,
    super.key,
  });

  final String chordType;
  final bool isSharp;
  final VoidCallback onTap;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: _getBoxColor(context),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Text(
            chordType,
            style: _getStyling(context, isSelected: isEnabled),
          ),
        ),
      ),
    );
  }

  Color _getBoxColor(BuildContext context) {
    return isSharp
        ? context.colorScheme.primary
        : context.colorScheme.onSurfaceVariant;
  }

  TextStyle _getStyling(BuildContext context, {bool isSelected = false}) {
    return context.textTheme.bodyMedium!.copyWith(
      fontWeight: FontWeight.w600,
      color: isSharp
          ? context.colorScheme.onSurfaceVariant
          : context.colorScheme.onSurface,
    );
  }
}
