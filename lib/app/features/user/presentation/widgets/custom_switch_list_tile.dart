import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class CustomSwitchListTile extends StatelessWidget {
  const CustomSwitchListTile({
    required this.title,
    required this.icon,
    required this.onSwitch,
    required this.value,
    super.key,
  });

  final String title;
  final IconData icon;
  final void Function(bool value) onSwitch;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      dense: true,
      tileColor: context.colorScheme.onSurfaceVariant,
      trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return context.colorScheme.primary;
          } else {
            return context.colorScheme.surface;
          }
        },
      ),
      thumbColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return context.colorScheme.onSurfaceVariant;
          }
          return context.colorScheme.outline;
        },
      ),
      activeTrackColor: context.colorScheme.primary,
      inactiveTrackColor: context.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Row(
        children: [
          Icon(
            icon,
            color: context.colorScheme.outline,
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              color: context.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              title,
              style: context.textTheme.titleMedium,
            ),
          ),
        ],
      ),
      value: value,
      onChanged: onSwitch,
    );
  }
}
