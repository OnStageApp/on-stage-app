import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/presentation/delete_event_confirmation_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/edit_date_modal.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventActionsSection extends StatelessWidget {
  const EventActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EventActionButton(
          onTap: () {
            DuplicateEventModal.show(context: context);
          },
          text: 'Duplicate Event',
          textColor: context.colorScheme.onSurface,
        ),
        const SizedBox(height: 16),
        EventActionButton(
          onTap: () {
            DeleteEventConfirmationDialog.show(context: context);
          },
          text: 'Delete Event',
          textColor: context.colorScheme.error,
        ),
      ],
    );
  }
}
