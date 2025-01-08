import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/presentation/uninvited_people_modal.dart';
import 'package:on_stage_app/app/features/groups/group_event/application/group_event_notifier.dart';
import 'package:on_stage_app/app/features/positions/position_event/presentation/position_members_card.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class PositionMembersModal extends ConsumerStatefulWidget {
  const PositionMembersModal({
    required this.groupId,
    required this.eventId,
    super.key,
  });

  final String groupId;
  final String eventId;

  static Future<void> show({
    required BuildContext context,
    required String groupId,
    required String eventId,
  }) async {
    return showModalBottomSheet<void>(
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surfaceContainerHigh,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
        maxWidth: context.isLargeScreen
            ? context.screenSize.width * 0.5
            : double.infinity,
      ),
      context: context,
      builder: (context) => PositionMembersModal(
        groupId: groupId,
        eventId: eventId,
      ),
    );
  }

  @override
  ConsumerState<PositionMembersModal> createState() =>
      _PositionMembersModalState();
}

class _PositionMembersModalState extends ConsumerState<PositionMembersModal> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(eventNotifierProvider.notifier)
          .getPositionsWithStagers(widget.groupId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollModal(
      buildHeader: () => _buildHeader(context),
      headerHeight: () => 64,
      footerHeight: () => 64,
      buildContent: () => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final eventState = ref.watch(eventNotifierProvider);
    if (eventState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          if (eventState.positionsWithStagers.isEmpty)
            const Center(child: Text('No positions yet'))
          else
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: eventState.positionsWithStagers.length,
              itemBuilder: (context, index) {
                final position = eventState.positionsWithStagers[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PositionMembersCard(
                    positionId: position.id,
                    positionName: position.name,
                    eventId: widget.eventId,
                    groupId: widget.groupId,
                    onTap: () {
                      if (mounted) {
                        UninvitedPeopleModal.show(
                          context: context,
                          positionName: position.name,
                          eventId: widget.eventId,
                        );
                      }
                    },
                  ),
                );
              },
            ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final group = ref.watch(groupEventNotifierProvider).groupEvents.firstWhere(
          (group) => group.id == widget.groupId,
        );
    return ModalHeader(
      title: group.name,
    );
  }
}
