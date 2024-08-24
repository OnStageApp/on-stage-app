import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/controller/event_controller.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_status_enum.dart';
import 'package:on_stage_app/app/features/event/presentation/create_rehearsal_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/custom_setting_tile.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/edit_field_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participant_listing_item.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/dash_divider.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventSettingsScreen extends ConsumerStatefulWidget {
  const EventSettingsScreen({super.key});

  @override
  EventSettingsScreenState createState() => EventSettingsScreenState();
}

class EventSettingsScreenState extends ConsumerState<EventSettingsScreen> {
  final _locationNameController = TextEditingController();
  final _eventNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.watch(eventNotifierProvider).event;
    _locationNameController.text = event?.location ?? '';
    _eventNameController.text = event?.name ?? '';
    return Scaffold(
      appBar: const StageAppBar(
        isBackButtonVisible: true,
        title: 'Event Settings',
      ),
      body: Padding(
        padding: defaultScreenPadding,
        child: ListView(
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
              onTap: () {
                EditFieldModal.show(
                  context: context,
                  fieldName: 'Event Name',
                  value: event?.name ?? '',
                  onSubmitted: (String value) {
                    ref
                        .read(eventNotifierProvider.notifier)
                        .updateEventName(value);
                  },
                );
              },
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
              onTap: () {
                EditFieldModal.show(
                  context: context,
                  fieldName: 'Event Location',
                  value: event?.location ?? '',
                  onSubmitted: (String value) {
                    ref
                        .read(eventNotifierProvider.notifier)
                        .updateEventLocation(value);
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            const DashedLineDivider(),
            const SizedBox(height: 24),
            Text(
              'Reminders',
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: Insets.smallNormal),
            Column(
              children: [
                CustomSettingTile(
                  title: 'Alert 1',
                  suffix: Text(
                    '3 days before',
                    style: context.textTheme.titleMedium!
                        .copyWith(color: context.colorScheme.outline),
                  ),
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                CustomSettingTile(
                  title: 'Alert 2',
                  suffix: Text(
                    '2 days before',
                    style: context.textTheme.titleMedium!
                        .copyWith(color: context.colorScheme.outline),
                  ),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            const DashedLineDivider(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Editor',
                  style: context.textTheme.titleSmall,
                ),
                Text(
                  'Invite members to manage',
                  style: context.textTheme.titleSmall!.copyWith(
                    color: context.colorScheme.outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Insets.smallNormal),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEditorsTile('You', 'Admin'),
                  const SizedBox(height: 12),
                  _buildEditorsTile('Timotei George', 'Editor'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildInvitePeopleButton(),
            const SizedBox(height: 16),
            const DashedLineDivider(),
            const SizedBox(height: 16),
            _buildDuplicateEvent(),
            const SizedBox(height: 16),
            _buildDeleteEventButton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildEditorsTile(String title, String role) {
    return Row(
      children: [
        Image.asset(
          'assets/images/profile1.png',
          width: 30,
          height: 30,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: context.textTheme.titleMedium,
        ),
        const Spacer(),
        Text(
          role,
          style: context.textTheme.titleMedium!
              .copyWith(color: context.colorScheme.outline),
        ),
      ],
    );
  }

  Widget _buildParticipantsList() {
    final addedParticipants = ref.watch(eventControllerProvider).addedUsers;

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
            name: addedParticipants[index].name ?? '',
            assetPath: 'assets/images/profile1.png',
            //TODO: unDO THIS AFTER REFACTOR STAGERS AND USERS
            status: StagerStatusEnum.UNINVINTED,
            // status: addedParticipants.elementAt(index).status,
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
        // AddParticipantsScreen.show(context: context, users: []);
      },
      text: 'Invite People',
      icon: Icons.add,
    );
  }

  Widget _buildDuplicateEvent() {
    return BlueActionButton(
      onTap: () {
        // AddParticipantsScreen.show(context: context);
      },
      text: 'Duplicate Event',
      textColor: context.colorScheme.onSurface,
    );
  }

  Widget _buildDeleteEventButton() {
    return BlueActionButton(
      onTap: () {
        // AddParticipantsScreen.show(context: context);
      },
      text: 'Delete Event',
      textColor: context.colorScheme.error,
    );
  }
}
