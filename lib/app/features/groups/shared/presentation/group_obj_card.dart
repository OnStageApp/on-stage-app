import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/features/groups/shared/domain/group_base.dart';
import 'package:on_stage_app/app/shared/square_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class GroupCardConstants {
  static const double padding = 12;
  static const double borderRadius = 8;
  static const int maxParticipants = 5;
}

abstract class GroupObjCard extends ConsumerWidget {
  const GroupObjCard({
    required this.groupId,
    this.onTap,
    super.key,
  });

  final String groupId;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: EdgeInsets.zero,
      color: context.colorScheme.onSurfaceVariant,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GroupCardConstants.borderRadius),
      ),
      child: InkWell(
        onTap: () => handleTap(context, ref),
        overlayColor:
            WidgetStateProperty.all(context.colorScheme.surfaceBright),
        child: Padding(
          padding: const EdgeInsets.all(GroupCardConstants.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildParticipantsSection(context, ref),
              const Spacer(),
              buildGroupName(context),
              buildSubtitle(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildParticipantsSection(BuildContext context, WidgetRef ref);

  Widget buildGroupName(BuildContext context);

  Widget buildSubtitle(BuildContext context);

  void handleTap(BuildContext context, WidgetRef ref);

  Widget buildDefaultParticipantsSection(
    BuildContext context,
    WidgetRef ref,
    GroupBase group,
  ) {
    if (group.membersCount > 0) {
      return Expanded(
        child: ParticipantsOnTile(
          participantsLength: group.membersCount,
          textColor: Colors.white,
          participantsProfileBytes: group.profilePictures ?? [],
          useRandomColors: true,
          participantsMax: GroupCardConstants.maxParticipants,
        ),
      );
    }

    return SquareIconButton(
      icon: LucideIcons.plus,
      onPressed: () => handleTap(context, ref),
      backgroundColor: context.isDarkMode
          ? const Color(0xFF43474E)
          : context.colorScheme.surface,
    );
  }

  Widget buildDefaultGroupName(BuildContext context, String name) {
    return Text(
      name,
      style: context.textTheme.titleMedium,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildDefaultSubtitle(
    BuildContext context,
    String subtitle,
  ) {
    return Text(
      subtitle,
      style: context.textTheme.bodyMedium!
          .copyWith(color: context.colorScheme.outline),
    );
  }
}
