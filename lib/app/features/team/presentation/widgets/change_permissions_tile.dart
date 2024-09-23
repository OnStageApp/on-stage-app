import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ChangePermissionsTile extends StatelessWidget {
  const ChangePermissionsTile({
    required this.isSelected,
    required this.title,
    required this.onTap,
    super.key,
  });

  final bool isSelected;
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                isSelected ? context.colorScheme.primary : Colors.transparent,
            width: 1.6,
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: context.textTheme.titleMedium,
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: context.colorScheme.primary,
                size: 20,
              )
            else
              Icon(
                Icons.circle_outlined,
                color: context.colorScheme.surfaceBright,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
