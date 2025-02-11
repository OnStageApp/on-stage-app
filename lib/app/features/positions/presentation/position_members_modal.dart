import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_base.dart';
import 'package:on_stage_app/app/features/event/presentation/uninvited_people_modal.dart';
import 'package:on_stage_app/app/features/groups/group_event/application/group_event_notifier.dart';
import 'package:on_stage_app/app/features/groups/group_event_template/application/group_event_template_notifier.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/positions/application/position_notifier.dart';
import 'package:on_stage_app/app/features/positions/domain/position.dart';
import 'package:on_stage_app/app/features/positions/presentation/position_members_card.dart';
import 'package:on_stage_app/app/features/positions/presentation/widgets/position_tile_shimmer.dart';
import 'package:on_stage_app/app/features/stager_template/application/stager_template_notifier.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/adaptive_modal.dart';

class PositionMembersModal extends ConsumerStatefulWidget {
  const PositionMembersModal.fromEventId({
    required this.groupId,
    required String eventId,
    super.key,
  })  : _eventId = eventId,
        _eventTemplateId = null;

  const PositionMembersModal.fromEventTemplateId({
    required this.groupId,
    required String? eventTemplateId,
    super.key,
  })  : _eventTemplateId = eventTemplateId,
        _eventId = null;

  final String groupId;
  final String? _eventId;
  final String? _eventTemplateId;

  static Future<Widget?> show({
    required BuildContext context,
    required String groupId,
    String? eventId,
    String? eventTemplateId,
  }) async {
    assert(
      (eventId != null) != (eventTemplateId != null),
      'Either eventId or eventTemplateId must be provided, but not both',
    );

    return AdaptiveModal.show(
      context: context,
      child: eventId != null
          ? PositionMembersModal.fromEventId(
              groupId: groupId,
              eventId: eventId,
            )
          : PositionMembersModal.fromEventTemplateId(
              groupId: groupId,
              eventTemplateId: eventTemplateId,
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
      if (widget._eventId != null) {
        ref.read(eventNotifierProvider.notifier).getStagersByGroupAndEvent(
              eventId: widget._eventId!,
              groupId: widget.groupId,
            );
      } else {
        ref
            .read(stagerTemplateNotifierProvider.notifier)
            .getStagersByGroupAndEventTemplate(
              eventTemplateId: widget._eventTemplateId!,
              groupId: widget.groupId,
            );
      }
      // Always fetch positions regardless of event type
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
    final stagerTemplatesState = ref.watch(stagerTemplateNotifierProvider);
    final positionState = ref.watch(positionNotifierProvider);
    final hasEditorRoles = ref.watch(permissionServiceProvider).hasAccessToEdit;

    // Handle different loading states for event and template
    final isLoading = widget._eventId != null
        ? eventState.isLoading || positionState.isLoading
        : stagerTemplatesState.isLoading || positionState.isLoading;

    // Get stagers only for event case, empty list for template
    final stagers = widget._eventId != null
        ? ref.watch(eventNotifierProvider.select((state) => state.stagers))
        : stagerTemplatesState.stagerTemplates;

    final sortedPositions = getSortedPositions(
      positions: positionState.positions,
      stagers: stagers,
      hasEditorRoles: hasEditorRoles,
      isTemplate: widget._eventTemplateId != null,
    );

    final content = switch ((isLoading, positionState.positions.isEmpty)) {
      (true, _) => const PositionTileShimmer(),
      (false, true) => const Center(child: Text('No positions found')),
      _ => ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: sortedPositions.length,
          itemBuilder: (context, index) {
            final position = sortedPositions[index];
            if (widget._eventId != null) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: PositionMembersCard.fromEventId(
                  position: position,
                  eventId: widget._eventId ?? '',
                  groupId: widget.groupId,
                  onTap: () {
                    if (mounted && widget._eventId != null) {
                      UninvitedPeopleModal.show(
                        context: context,
                        positionName: position.name,
                        positionId: position.id,
                        eventId: widget._eventId!,
                      );
                    }
                  },
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: PositionMembersCard.fromEventTemplateId(
                  position: position,
                  eventTemplateId: widget._eventTemplateId,
                  groupId: widget.groupId,
                  onTap: () {
                    if (mounted && widget._eventId != null) {
                      UninvitedPeopleModal.show(
                        context: context,
                        positionName: position.name,
                        positionId: position.id,
                        eventId: widget._eventId!,
                      );
                    }
                  },
                ),
              );
            }
          },
        ),
    };

    return content;
  }

  List<Position> getSortedPositions({
    required List<Position> positions,
    required List<StagerBase> stagers,
    required bool hasEditorRoles,
    required bool isTemplate,
  }) {
    // For templates, return all positions sorted by their original order
    if (isTemplate) {
      return positions.toList();
    }

    // For events, filter and sort based on stagers
    final filteredPositions = !hasEditorRoles
        ? positions
            .where((p) => stagers.any((s) => s.positionId == p.id))
            .toList()
        : positions.toList();

    return filteredPositions
      ..sort((a, b) {
        final stagersInA = stagers.where((s) => s.positionId == a.id).length;
        final stagersInB = stagers.where((s) => s.positionId == b.id).length;

        if ((stagersInA > 0) != (stagersInB > 0)) {
          return stagersInB.compareTo(stagersInA);
        }

        return positions.indexOf(a).compareTo(positions.indexOf(b));
      });
  }

  Widget _buildHeader(BuildContext context) {
    if (widget._eventId != null) {
      final group =
          ref.watch(groupEventNotifierProvider).groupEvents.firstWhere(
                (group) => group.id == widget.groupId,
              );
      return ModalHeader(title: group.name);
    } else {
      final group = ref
          .watch(groupEventTemplateNotifierProvider)
          .groups
          .firstWhere((group) => group.id == widget.groupId);
      return ModalHeader(title: group.name);
    }
  }
}
