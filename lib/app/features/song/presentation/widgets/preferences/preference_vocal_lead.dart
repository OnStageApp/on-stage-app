import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_overview.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participant_listing_item.dart';
import 'package:on_stage_app/app/features/event_items/application/event_items_notifier.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/stagers_to_assign_modal.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/list_utils.dart';
import 'package:on_stage_app/logger.dart';

class PreferencesVocalLead extends ConsumerStatefulWidget {
  const PreferencesVocalLead({super.key});

  @override
  ConsumerState<PreferencesVocalLead> createState() =>
      _PreferencesVocalLeadState();
}

class _PreferencesVocalLeadState extends ConsumerState<PreferencesVocalLead> {
  List<StagerOverview> _leadVocalStagers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentStagers = currentEventItem.assignedTo ?? [];
      setState(() {
        _leadVocalStagers = currentStagers;
      });
    });
  }

  EventItem get currentEventItem => ref
      .watch(eventItemsNotifierProvider)
      .eventItems[ref.watch(eventItemsNotifierProvider).currentIndex];

  void _handleLocalStagersUpdate(List<StagerOverview> stagers) {
    logger.i('Local stagers updated: $stagers');
  }

  void _handleSaveStagers(List<StagerOverview> stagers) {
    setState(() {
      _leadVocalStagers = stagers;
    });

    final eventItem = currentEventItem;
    final eventItemId = eventItem.id;

    ref.read(eventItemsNotifierProvider.notifier).updateLeadVocals(
          eventItemId,
          stagers,
        );
  }

  void _handleStagerRemoved(StagerOverview stager) {
    final updatedStagers =
        _leadVocalStagers.where((s) => s.id != stager.id).toList();
    _handleSaveStagers(updatedStagers);
  }

  @override
  Widget build(BuildContext context) {
    final eventItemId = currentEventItem.id;
    final hasEditAccess = ref.watch(permissionServiceProvider).hasAccessToEdit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lead Vocals',
          style: context.textTheme.titleSmall,
        ),
        if (_leadVocalStagers.isNotNullOrEmpty)
          _buildStagersList(context, _leadVocalStagers, eventItemId),
        const SizedBox(height: 12),
        if (hasEditAccess)
          EventActionButton(
            icon: Icons.add,
            onTap: () {
              StagersToAssignModal.show(
                context: context,
                eventItemId: eventItemId,
                onStagersSelected: _handleLocalStagersUpdate,
                onSave: _handleSaveStagers,
              );
            },
            text: 'Add Lead Vocals',
          )
        else if (_leadVocalStagers.isEmpty)
          EventActionButton(
            onTap: () {},
            text: 'No Lead Vocals Added',
            textColor: context.colorScheme.outline,
          ),
      ],
    );
  }

  Widget _buildStagersList(
    BuildContext context,
    List<StagerOverview> stagers,
    String? eventItemId,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SlidableAutoCloseBehavior(
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: stagers.length,
          itemBuilder: (context, index) {
            final currentStager = stagers[index];
            return Padding(
              padding: const EdgeInsets.only(left: 12),
              child: ParticipantListingItem(
                userId: currentStager.userId,
                name: currentStager.name,
                photo: currentStager.profilePicture,
                onDelete: () => _handleStagerRemoved(currentStager),
              ),
            );
          },
        ),
      ),
    );
  }
}
