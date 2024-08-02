import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/controller/event_controller.dart';
import 'package:on_stage_app/app/features/event/presentation/add_participants_screen.dart';
import 'package:on_stage_app/app/features/event/presentation/create_rehearsal_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/event/presentation/set_reminder_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/date_time_text_field.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participant_listing_item.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/dash_divider.dart';
import 'package:on_stage_app/app/shared/event_tile.dart';
import 'package:on_stage_app/app/shared/settings_trailing_app_bar_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AddEventDetailsScreen extends ConsumerStatefulWidget {
  const AddEventDetailsScreen({super.key});

  @override
  AddEventDetailsScreenState createState() => AddEventDetailsScreenState();
}

class AddEventDetailsScreenState extends ConsumerState<AddEventDetailsScreen> {
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
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16),
        child: ContinueButton(
          text: 'Create',
          onPressed: () {
            context.pushNamed(AppRoute.addEventSongs.name);
          },
          isEnabled: true,
        ),
      ),
      // floatingActionButton: Container(
      //   decoration: const BoxDecoration(
      //     boxShadow: [
      //       BoxShadow(
      //         color: Color(0xFFF4F4F4),
      //         blurRadius: 30,
      //         spreadRadius: 35,
      //       ),
      //     ],
      //   ),
      //   padding: const EdgeInsets.symmetric(horizontal: 12),
      //   child: ContinueButton(
      //     text: 'Create',
      //     onPressed: () {
      //       context.pushNamed(AppRoute.addEventSongs.name);
      //     },
      //     isEnabled: true,
      //   ),
      // ),
      appBar: StageAppBar(
        isBackButtonVisible: true,
        title: 'Create Event',
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
            CustomTextField(
              label: 'Event Name',
              hint: 'Prayer Meeting',
              icon: Icons.church,
              controller: eventNameController,
            ),
            const SizedBox(height: Insets.medium),
            CustomTextField(
              label: 'Event Location',
              hint: 'Elevation Church',
              icon: Icons.church,
              controller: eventLocationController,
            ),
            const SizedBox(height: Insets.medium),
            DateTimeTextFieldWidget(
              dateController: dateController,
              timeController: timeController,
            ),
            const SizedBox(height: Insets.medium),
            Text(
              'Participants',
              style: context.textTheme.titleSmall,
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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: DashedLineDivider(),
            ),
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
            const SizedBox(height: 64),
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
