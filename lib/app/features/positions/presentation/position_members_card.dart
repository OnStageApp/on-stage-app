import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/enums/event_status_enum.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_base.dart';
import 'package:on_stage_app/app/features/event/presentation/uninvited_people_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participant_listing_item.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/positions/domain/position.dart';
import 'package:on_stage_app/app/features/stager_template/application/stager_template_notifier.dart';
import 'package:on_stage_app/app/shared/add_new_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/list_utils.dart';

class PositionMembersCard extends ConsumerWidget {
  const PositionMembersCard.fromEventId({
    required this.position,
    required this.groupId,
    required String eventId,
    required this.onTap,
    super.key,
  })  : _eventId = eventId,
        _eventTemplateId = null;

  const PositionMembersCard.fromEventTemplateId({
    required this.position,
    required this.groupId,
    required String? eventTemplateId,
    required this.onTap,
    super.key,
  })  : _eventTemplateId = eventTemplateId,
        _eventId = null;

  final Position position;
  final String groupId;
  final String? _eventId;
  final String? _eventTemplateId;
  final VoidCallback onTap;

  bool get _isEventMode => _eventId != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only watch event-related state if in event mode
    final currentEventStatus = _isEventMode
        ? ref.watch(eventNotifierProvider).event?.eventStatus
        : null;

    final Iterable<StagerBase> membersByPosition;
    if (_isEventMode) {
      membersByPosition = ref.watch(
        eventNotifierProvider.select(
          (state) =>
              state.stagers.where((stager) => stager.positionId == position.id),
        ),
      );
    } else {
      membersByPosition = ref.watch(
        stagerTemplateNotifierProvider.select(
          (state) => state.stagerTemplates
              .where((template) => template.positionId == position.id),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  position.name,
                  style: context.textTheme.titleMedium,
                ),
                if (ref.watch(permissionServiceProvider).hasAccessToEdit)
                  AddNewButton(
                    text: 'Add',
                    onPressed: () => _handleAddMembers(context, ref),
                  ),
              ],
            ),
          ),
          Divider(
            color: context.colorScheme.surfaceContainerHighest,
            thickness: 1,
            height: 0,
          ),
          if (membersByPosition.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'No members yet.',
                style: context.textTheme.titleMedium!.copyWith(
                  color: context.colorScheme.outline,
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: SlidableAutoCloseBehavior(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: membersByPosition.length,
                  itemBuilder: (context, index) {
                    final member = membersByPosition.elementAt(index);
                    return ParticipantListingItem(
                      key: ValueKey(member.id),
                      userId: member.userId ?? '',
                      name: member.name ?? '',
                      photo: member.profilePicture ?? Uint8List(0),
                      status: _isEventMode &&
                              currentEventStatus == EventStatus.published
                          ? (member as Stager).participationStatus
                          : null,
                      canEdit:
                          ref.watch(permissionServiceProvider).hasAccessToEdit,
                      onDelete: () {
                        if (_isEventMode) {
                          ref
                              .read(eventNotifierProvider.notifier)
                              .removeStagerFromEvent(member.id);
                        } else {
                          ref
                              .read(stagerTemplateNotifierProvider.notifier)
                              .removeStagerTemplateById(member.id);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleAddMembers(BuildContext context, WidgetRef ref) async {
    if (_isEventMode) {
      final selectedMembers = await UninvitedPeopleModal.show(
        context: context,
        positionName: position.name,
        positionId: position.id,
        eventId: _eventId,
      );

      if (!context.mounted) return;

      if (selectedMembers.isNotNullOrEmpty) {
        await ref.read(eventNotifierProvider.notifier).addStagersToEvent(
              selectedMembers!,
              position.id,
              groupId,
            );
      }
    } else {
      final selectedMembers = await UninvitedPeopleModal.show(
        context: context,
        positionName: position.name,
        positionId: position.id,
        eventTemplateId: _eventTemplateId,
      );

      if (!context.mounted) return;

      if (selectedMembers.isNotNullOrEmpty) {
        await ref
            .read(stagerTemplateNotifierProvider.notifier)
            .addStagersToEventTemplate(
              selectedMembers!,
              _eventTemplateId ?? '',
              position.id,
              groupId,
            );
      }
    }
  }
}
