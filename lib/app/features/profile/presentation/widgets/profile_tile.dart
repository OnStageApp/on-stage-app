import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    required this.title,
    required this.icon,
    required this.onTap,
    this.totalNumber,
    super.key,
  });

  final String title;
  final String? totalNumber;
  final IconData icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              title,
              style: context.textTheme.bodyLarge,
              maxLines: 1,
            ),
          ),
          const Spacer(),
          Text(
            totalNumber ?? '',
            style: context.textTheme.titleMedium!.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
