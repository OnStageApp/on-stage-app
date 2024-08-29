import 'package:flutter/material.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventActionsSection extends StatelessWidget {
  const EventActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlueActionButton(
          onTap: () {},
          text: 'Duplicate Event',
          textColor: context.colorScheme.onSurface,
        ),
        const SizedBox(height: 16),
        BlueActionButton(
          onTap: () {},
          text: 'Delete Event',
          textColor: context.colorScheme.error,
        ),
      ],
    );
  }
}
