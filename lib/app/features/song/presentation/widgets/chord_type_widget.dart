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
            color: _getBoxColor(),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Text(
            chordType,
            style: isSharp
                ? _getStyling(context).copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  )
                : _getStyling(context),
          ),
        ),
      ),
    );
  }

  Color _getBoxColor() {
    return isSharp ? const Color(0xFF1996FF) : Colors.white;
  }

  TextStyle _getStyling(BuildContext context) {
    return context.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600);
  }
}
