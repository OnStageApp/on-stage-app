import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Chitara Bass',
          style: context.textTheme.bodyMedium!.copyWith(
            color: context.colorScheme.outline,
          ),
        ),
        const SizedBox(width: 12),
        Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: context.colorScheme.onSurfaceVariant,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Free Plan',
            style: context.textTheme.bodyMedium!.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
        ),
      ],
    );
  }
}
