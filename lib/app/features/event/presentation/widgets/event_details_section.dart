import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/custom_setting_tile.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/edit_field_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventDetailsSection extends ConsumerWidget {
  final EventModel? event;

  const EventDetailsSection({required this.event, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        CustomSettingTile(
          backgroundColor: context.colorScheme.surfaceBright,
          title: event?.name ?? '',
          headline: 'Event Name',
          suffix: Icon(
            Icons.edit,
            size: 20,
            color: context.colorScheme.outline,
          ),
          onTap: () => _showEditNameModal(context, ref),
        ),
        const SizedBox(height: Insets.smallNormal),
        CustomSettingTile(
          backgroundColor: context.colorScheme.surfaceBright,
          title: event?.location ?? '',
          headline: 'Event Location',
          suffix: Icon(
            Icons.edit,
            size: 20,
            color: context.colorScheme.outline,
          ),
          onTap: () => _showEditLocationModal(context, ref),
        ),
      ],
    );
  }

  void _showEditNameModal(BuildContext context, WidgetRef ref) {
    EditFieldModal.show(
      context: context,
      fieldName: 'Event Name',
      value: event?.name ?? '',
      onSubmitted: (String value) {
        ref.read(eventNotifierProvider.notifier).updateEventName(value);
      },
    );
  }

  void _showEditLocationModal(BuildContext context, WidgetRef ref) {
    EditFieldModal.show(
      context: context,
      fieldName: 'Event Location',
      value: event?.location ?? '',
      onSubmitted: (String value) {
        ref.read(eventNotifierProvider.notifier).updateEventLocation(value);
      },
    );
  }
}
