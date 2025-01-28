import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/plan/application/current_plan_provider.dart';
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
            ref.watch(currentPlanProvider).name.split(' ')[0].toUpperCase(),
            style: context.textTheme.bodyMedium!.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
        ),
      ],
    );
  }
}
