import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/controller/event_controller.dart';
import 'package:on_stage_app/app/features/event/presentation/add_participants_screen.dart';
import 'package:on_stage_app/app/features/event/presentation/create_rehearsal_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/set_reminder_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participant_listing_item.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/event_tile.dart';
import 'package:on_stage_app/app/shared/event_tile_enhanced.dart';
import 'package:on_stage_app/app/shared/settings_trailing_app_bar_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';

class AdminEventOverview extends ConsumerStatefulWidget {
  const AdminEventOverview({super.key});

  @override
  AdminEventOverviewState createState() => AdminEventOverviewState();
}

class AdminEventOverviewState extends ConsumerState<AdminEventOverview> {
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventLocationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.watch(eventControllerProvider);
    return Scaffold(
      appBar: StageAppBar(
        isBackButtonVisible: true,
        title: 'Event',
        trailing: SettingsTrailingAppBarButton(
          onTap: () {
            SetReminderModal.show(context: context);
          },
        ),
      ),
      body: Padding(
        padding: defaultScreenPadding,
        child: ListView(
          children: [
            SizedBox(
              height: 174,
              child: EventTileEnhanced(
                title: event.eventName,
                locationName: event.eventLocation,
                date: TimeUtils().formatOnlyDate(
                  event.dateTime ?? DateTime.now(),
                ),
                hour: TimeUtils().formatOnlyTime(
                  event.dateTime ?? DateTime.now(),
                ),
                isSingleEvent: true,
              ),
            ),
            const SizedBox(height: Insets.medium),
            Text(
              'Rehearsals',
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: Insets.smallNormal),
            ...ref.watch(eventControllerProvider).rehearsals.map(
              (rehearsal) {
                return EventTile(
                  title: rehearsal.name ?? '',
                  dateTime: rehearsal.dateTime ?? DateTime.now(),
                  onTap: () {},
                );
              },
            ),
            _buildCreateRehearsalButton(),
            const SizedBox(height: Insets.medium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Participants',
                  style: context.textTheme.titleSmall,
                ),
                Text(
                  '5/10 confirmed',
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: context.colorScheme.outline,
                  ),
                ),
              ],
            ),
            if (ref
                .watch(eventControllerProvider)
                .addedParticipants
                .isNotEmpty) ...[
              const SizedBox(height: Insets.smallNormal),
              _buildParticipantsList(),
            ],
            const SizedBox(height: Insets.smallNormal),
            _buildInvitePeopleButton(),
            const SizedBox(height: 32),
            ContinueButton(
              text: 'Preview Event',
              onPressed: () {
                ref
                    .read(eventControllerProvider.notifier)
                    .setEventName(eventNameController.text);
                ref
                    .read(eventControllerProvider.notifier)
                    .setEventLocation(eventLocationController.text);
                ref
                    .read(eventControllerProvider.notifier)
                    .setDateTime(dateController.text, timeController.text);

                context.pushNamed(AppRoute.addEventSongs.name);
              },
              isEnabled: true,
            ),
            const SizedBox(height: 42),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantsList() {
    final addedParticipants =
        ref.watch(eventControllerProvider).addedParticipants;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: addedParticipants.length,
        itemBuilder: (context, index) {
          return ParticipantListingItem(
            name:
                '${addedParticipants[index].firstName} ${addedParticipants[index].lastName}',
            assetPath: 'assets/images/profile1.png',
            status: addedParticipants.elementAt(index).status,
          );
        },
      ),
    );
  }

  Widget _buildCreateRehearsalButton() {
    return BlueActionButton(
      onTap: () {
        CreateRehearsalModal.show(context: context);
      },
      text: 'Create new Rehearsal',
      icon: Icons.add,
    );
  }

  Widget _buildInvitePeopleButton() {
    return BlueActionButton(
      onTap: () {
        AddParticipantsScreen.show(context: context);
      },
      text: 'Invite People',
      icon: Icons.add,
    );
  }
}
