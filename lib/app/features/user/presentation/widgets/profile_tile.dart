import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    required this.title,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.totalNumber,
    super.key,
  });

  final String title;
  final String? totalNumber;
  final IconData icon;
  final Color? iconColor;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: iconColor ?? context.colorScheme.primary,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                title,
                style: context.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
              ),
            ),
            const Spacer(),
            Text(
              totalNumber ?? '',
              style: context.textTheme.bodyLarge!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
