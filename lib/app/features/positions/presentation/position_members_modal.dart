import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager.dart';
import 'package:on_stage_app/app/features/event/presentation/uninvited_people_modal.dart';
import 'package:on_stage_app/app/features/groups/group_event/application/group_event_notifier.dart';
import 'package:on_stage_app/app/features/positions/application/position_notifier.dart';
import 'package:on_stage_app/app/features/positions/domain/position.dart';
import 'package:on_stage_app/app/features/positions/presentation/position_members_card.dart';
import 'package:on_stage_app/app/features/positions/presentation/widgets/position_tile_shimmer.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/adaptive_modal.dart';

class PositionMembersModal extends ConsumerStatefulWidget {
  const PositionMembersModal({
    required this.groupId,
    required this.eventId,
    super.key,
  });

  final String groupId;
  final String eventId;

  static Future<Widget?> show({
    required BuildContext context,
    required String groupId,
    required String eventId,
  }) async {
    return AdaptiveModal.show(
      context: context,
      child: PositionMembersModal(
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
    Future.microtask(() {
      ref.read(eventNotifierProvider.notifier).getStagersByGroupAndEvent(
            eventId: widget.eventId,
            groupId: widget.groupId,
          );
      ref.read(positionNotifierProvider.notifier).getPositions(widget.groupId);
    });
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          _getContent(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _getContent() {
    final eventState = ref.watch(eventNotifierProvider);
    final positionState = ref.watch(positionNotifierProvider);
    final sortedPositions = getSortedPositions(
      positions: positionState.positions,
      stagers: ref.watch(
        eventNotifierProvider.select((state) => state.stagers),
      ),
    );
    final content = switch ((
      eventState.isLoading || positionState.isLoading,
      positionState.positions.isEmpty
    )) {
      (true, _) => const PositionTileShimmer(),
      (false, true) => const Center(child: Text('No positions found')),
      _ => ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: sortedPositions.length,
          itemBuilder: (context, index) {
            final position = sortedPositions[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PositionMembersCard(
                position: position,
                eventId: widget.eventId,
                groupId: widget.groupId,
                onTap: () {
                  if (mounted) {
                    UninvitedPeopleModal.show(
                      context: context,
                      positionName: position.name,
                      positionId: position.id,
                      eventId: widget.eventId,
                    );
                  }
                },
              ),
            );
          },
        ),
    };

    return content;
  }

  List<Position> getSortedPositions({
    required List<Position> positions,
    required List<Stager> stagers,
  }) {
    return positions.toList()
      ..sort((a, b) {
        final stagersInA = stagers.where((s) => s.positionId == a.id).length;
        final stagersInB = stagers.where((s) => s.positionId == b.id).length;

        if ((stagersInA > 0) != (stagersInB > 0)) {
          return stagersInB.compareTo(
            stagersInA,
          );
        }

        return positions.indexOf(a).compareTo(positions.indexOf(b));
      });
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
