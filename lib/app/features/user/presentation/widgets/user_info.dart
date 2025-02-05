import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class UserInfo extends ConsumerWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
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
            ref.watch(userNotifierProvider).currentUser?.username ?? '',
            style: context.textTheme.bodyMedium!.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
        ),
      ],
    );
  }
}
