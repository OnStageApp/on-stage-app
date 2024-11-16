import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/controller/event_controller.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_status_enum.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participant_listing_item.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ParticipantsList extends ConsumerWidget {
  const ParticipantsList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addedTeamMembers = ref.watch(eventControllerProvider).addedMembers;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: addedTeamMembers.length,
        itemBuilder: (context, index) {
          final member = addedTeamMembers[index];
          return ParticipantListingItem(
            key: ValueKey(member.id),
            name: member.name ?? '',
            photo: member.profilePicture ?? Uint8List(0),
            status: StagerStatusEnum.UNINVINTED,
            onDelete: () => ref
                .read(eventControllerProvider.notifier)
                .removeMemberFromCache(member.id),
          );
        },
      ),
    );
  }
}
