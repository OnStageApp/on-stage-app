import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/create_all_stagers_request.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/create_stager_request.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_status_enum.dart';
import 'package:on_stage_app/app/features/event/presentation/uninvited_people_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participant_listing_item.dart';
import 'package:on_stage_app/app/features/positions/position_template/domain/position_stagers.dart';
import 'package:on_stage_app/app/shared/add_new_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/list_utils.dart';

class PositionMembersCard extends ConsumerStatefulWidget {
  const PositionMembersCard({
    required this.positionId,
    required this.positionName,
    required this.groupId,
    required this.eventId,
    required this.onTap,
    super.key,
  });

  final String positionId;
  final String positionName;
  final String groupId;
  final String eventId;
  final VoidCallback onTap;

  @override
  ConsumerState<PositionMembersCard> createState() => _PositionCardState();
}

class _PositionCardState extends ConsumerState<PositionMembersCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = _getCurrentPosition();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentPosition.name,
                style: context.textTheme.titleMedium,
              ),
              AddNewButton(
                text: 'Add',
                onPressed: () async {
                  await _addTeamMembersToEvent(context);
                },
              ),
            ],
          ),
          Divider(
            color: context.colorScheme.surfaceContainerHighest,
            thickness: 1,
          ),
          if (currentPosition.stagers.isNullOrEmpty) ...[
            const SizedBox(height: 12),
            const Text('No members yet.'),
          ] else
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: currentPosition.stagers.length,
              itemBuilder: (context, index) {
                final stager = currentPosition.stagers[index];
                return ParticipantListingItem(
                  userId: stager.userId ?? '',
                  key: ValueKey(stager.id),
                  name: stager.name ?? '',
                  photo: stager.profilePicture ?? Uint8List(0),
                  status: StagerStatusEnum.UNINVINTED,
                  onDelete: () {
                    //TODO: Remove  stager from positionId or delete it
                  },
                );
              },
            ),
        ],
      ),
    );
  }

  PositionWithStagers _getCurrentPosition() {
    return ref.watch(eventNotifierProvider).positionsWithStagers.firstWhere(
          (element) => element.id == widget.positionId,
        );
  }

  Future<void> _addTeamMembersToEvent(BuildContext context) async {
    final selectedMemberIds = await UninvitedPeopleModal.show(
      context: context,
      positionName: widget.positionName,
      eventId: widget.eventId,
    );

    if (selectedMemberIds.isNotNullOrEmpty) {
      final request = CreateAllStagersRequest(
        eventId: widget.eventId,
        createStagersRequest: selectedMemberIds!
            .map(
              (teamMemberId) => CreateStagerRequest(
                positionId: widget.positionId,
                groupId: widget.groupId,
                teamMemberId: teamMemberId,
              ),
            )
            .toList(),
      );

      await ref.read(eventNotifierProvider.notifier).addStagersToEvent(request);
    }
  }
}
