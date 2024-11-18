import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/team_member/domain/position_enum/position.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/choose_position_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/resources/generated/assets.gen.dart';

class PositionTile extends ConsumerWidget {
  const PositionTile({
    this.onSaved,
    this.title,
    super.key,
  });

  final void Function(Position)? onSaved;
  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      tileColor: context.colorScheme.onSurfaceVariant,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      dense: true,
      title: Text(
        title ??
            ref.watch(userNotifierProvider).currentUser?.position?.title ??
            'None',
        style: context.textTheme.titleMedium,
      ),
      trailing: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Center(
          child: Assets.icons.arrowForward.svg(),
        ),
      ),
      onTap: () {
        ChoosePositionModal.show(
          context: context,
          onSaved: (position) {
            if (onSaved != null) {
              onSaved!(position);
            } else {
              ref
                  .read(userNotifierProvider.notifier)
                  .updatePositionOnUser(position);
            }
          },
        );
      },
    );
  }
}
