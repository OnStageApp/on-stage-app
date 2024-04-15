import 'package:flutter/material.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class PreferencesActionTile extends StatelessWidget {
  const PreferencesActionTile({
    required this.leadingWidget,
    required this.title,
    required this.trailingIcon,
    required this.onTap,
    super.key,
  });

  final Widget leadingWidget;
  final String title;
  final IconData trailingIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          leadingWidget,
          const SizedBox(width: Insets.smallNormal),
          Text(
            title,
            style: context.textTheme.bodyLarge,
          ),
          const Spacer(),
          InkWell(
            onTap: onTap,
            child: Container(
              width: 30,
              height: 30,
              // padding: const EdgeInsets.all(61),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(
                trailingIcon,
                size: 24,
                color: const Color(0xFF828282),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
