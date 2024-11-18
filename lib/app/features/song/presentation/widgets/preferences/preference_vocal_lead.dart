import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participant_listing_item.dart';
import 'package:on_stage_app/app/features/event_items/application/event_item_notifier/event_item_notifier.dart';
import 'package:on_stage_app/app/features/event_items/application/event_items_notifier.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/vocal_lead_modal.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/image_with_placeholder.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/list_utils.dart';

class PreferencesVocalLead extends ConsumerStatefulWidget {
  const PreferencesVocalLead({super.key});

  @override
  ConsumerState<PreferencesVocalLead> createState() =>
      _PreferencesVocalLeadState();
}

class _PreferencesVocalLeadState extends ConsumerState<PreferencesVocalLead> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final eventItemId = ref
          .read(eventItemsNotifierProvider)
          .eventItems[ref.read(eventItemsNotifierProvider).currentIndex]
          .id;
      ref.read(eventItemNotifierProvider.notifier).getLeadVocals(eventItemId!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final leadVocalStagers =
        ref.watch(eventItemNotifierProvider).leadVocalStagers;
    final eventItemId = ref
        .watch(eventItemsNotifierProvider)
        .eventItems[ref.read(eventItemsNotifierProvider).currentIndex]
        .id;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lead Vocals',
          style: context.textTheme.titleSmall,
        ),
        if (leadVocalStagers.isNotNullOrEmpty)
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: context.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: leadVocalStagers.length,
              itemBuilder: (context, index) {
                return ParticipantListingItem(
                  name: leadVocalStagers[index].name ?? '',
                  photo: leadVocalStagers[index].profilePicture,
                  onDelete: () {
                    if (eventItemId == null) return;
                    ref
                        .read(eventItemNotifierProvider.notifier)
                        .removeLeadVocal(
                          eventItemId,
                          leadVocalStagers[index].id,
                        );
                  },
                );
              },
            ),
          ),
        const SizedBox(height: 12),
        if (ref.watch(permissionServiceProvider).hasAccessToEdit)
          EventActionButton(
            icon: Icons.add,
            onTap: () {
              VocalLeadModal.show(context: context);
            },
            text: 'Add Lead Vocals',
          )
        else if (leadVocalStagers.isEmpty)
          EventActionButton(
            onTap: () {},
            text: 'No Lead Vocals Added',
            textColor: context.colorScheme.outline,
          ),
      ],
    );
  }

  Widget _buildVocal(BuildContext context, Stager leadVocal) {
    return Container(
      margin: const EdgeInsets.all(12),
      alignment: Alignment.center,
      child: Row(
        children: [
          ImageWithPlaceholder(
            photo: leadVocal.profilePicture,
            name: leadVocal.name ?? '',
          ),
          const SizedBox(width: 10),
          Text(leadVocal.name ?? 'None', style: context.textTheme.titleMedium),
        ],
      ),
    );
  }
}
