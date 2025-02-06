import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/event_actions_section.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/event_details_section.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/reminders_section.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/decline_event_invitation_modal.dart';
import 'package:on_stage_app/app/shared/dash_divider.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';

class EventSettingsScreen extends ConsumerWidget {
  const EventSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ref.watch(eventNotifierProvider).event;

    return Scaffold(
      appBar: StageAppBar(
        isBackButtonVisible: true,
        trailing: DeclineEventInvitationModal(
          eventId: event?.id ?? '',
        ),
        title: 'Event Settings',
      ),
      body: Padding(
        padding: defaultScreenPadding,
        child: ListView(
          children: [
            EventDetailsSection(event: event),
            const SizedBox(height: 24),
            const DashedLineDivider(),
            const SizedBox(height: 24),
            const RemindersSection(),
            const SizedBox(height: 24),
            const DashedLineDivider(),
            const SizedBox(height: 24),
            const EventActionsSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
