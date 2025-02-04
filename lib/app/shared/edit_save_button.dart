import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EditSaveButton extends StatelessWidget {
  const EditSaveButton({
    required this.onTap,
    required this.isEditMode,
    super.key,
  });

  final VoidCallback onTap;
  final bool isEditMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: onTap,
        overlayColor:
            WidgetStatePropertyAll(context.colorScheme.onSurfaceVariant),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isEditMode
                ? context.colorScheme.primary
                : context.colorScheme.onSurfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: Icon(
              isEditMode ? LucideIcons.save : LucideIcons.pencil,
              size: 16,
              color: context.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
