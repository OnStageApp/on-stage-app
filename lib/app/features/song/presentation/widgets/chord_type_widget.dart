import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ChordTypeWidget extends StatelessWidget {
  const ChordTypeWidget({
    required this.chordType,
    required this.isSelected,
    required this.onTap,
    this.isEnabled = true,
    super.key,
  });

  final String chordType;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    if (chordType == 'natural') {
      return const SizedBox.shrink();
    }

    return Expanded(
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5,
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
              style: _getStyling(context),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBoxColor(BuildContext context) {
    return isSelected
        ? context.colorScheme.primary
        : context.colorScheme.onSurfaceVariant;
  }

  TextStyle _getStyling(BuildContext context) {
    return context.textTheme.titleMedium!.copyWith(
      fontWeight: FontWeight.w600,
      color: isSelected ? Colors.white : context.colorScheme.onSurface,
    );
  }
}
