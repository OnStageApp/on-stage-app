import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/controller/event_controller.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_status_enum.dart';
import 'package:on_stage_app/app/features/event/presentation/create_rehearsal_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/event/presentation/invite_people_to_event_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/date_time_text_field.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participant_listing_item.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/reminder/application/reminder_notifier.dart';
import 'package:on_stage_app/app/features/reminder/presentation/set_reminder_modal.dart';
import 'package:on_stage_app/app/features/stage_tooltip/stage_tooltip.dart';
import 'package:on_stage_app/app/features/user/domain/enums/permission_type.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/features/user_settings/domain/user_settings.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/dash_divider.dart';
import 'package:on_stage_app/app/shared/rehearsal_tile.dart';
import 'package:on_stage_app/app/shared/settings_trailing_app_bar_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/logger.dart';

class AddEventDetailsScreen extends ConsumerStatefulWidget {
  const AddEventDetailsScreen({super.key});

  @override
  AddEventDetailsScreenState createState() => AddEventDetailsScreenState();
}

class AddEventDetailsScreenState extends ConsumerState<AddEventDetailsScreen> {
  final _eventNameController = TextEditingController();
  final _eventLocationController = TextEditingController();
  final GlobalKey<StageTooltipState> _addRemindersTooltipKey =
      GlobalKey<StageTooltipState>();
  final _formKey = GlobalKey<FormState>();
  String? _dateTimeString;
  var _reminders = <int>[];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(userSettingsNotifierProvider).isAddRemindersTooltipShown ==
          false) {
        _addRemindersTooltipKey.currentState?.showTooltip();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userSettingsNotifier = ref.watch(userSettingsNotifierProvider);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12),
        child: ContinueButton(
          text: 'Create Draft Event',
          onPressed: () async {
            await _createDraftEvent(context);
          },
          isEnabled: true,
        ),
      ),
      appBar: StageAppBar(
        isBackButtonVisible: true,
        title: 'Create Event',
        trailing: StageTooltip(
          message: 'Add Reminders for your event',
          key: _addRemindersTooltipKey,
          child: SettingsTrailingAppBarButton(
            iconPath: 'assets/icons/bell.svg',
            onTap: () async {
              await ref
                  .read(permissionServiceProvider)
                  .callMethodIfHasPermission(
                    context: context,
                    permissionType: PermissionType.reminders,
                    onGranted: () {
                      if (userSettingsNotifier.isAddRemindersTooltipShown ==
                          false) {
                        _disableTooltip();
                      }
                      SetReminderModal.show(
                        cacheReminders: _reminders,
                        context: context,
                        ref: ref,
                        onSaved: (List<int> reminders) {
                          setState(() {
                            _reminders = reminders;
                          });
                        },
                      );
                    },
                  );
            },
          ),
        ),
      ),
      body: Padding(
        padding: defaultScreenPadding,
        child: Form(
          key: _formKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              CustomTextField(
                label: 'Event Name',
                hint: 'Prayer Meeting',
                icon: Icons.church,
                controller: _eventNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an event name';
                  }
                  return null;
                },
                onChanged: (value) {},
              ),
              const SizedBox(height: Insets.medium),
              CustomTextField(
                label: 'Event Location',
                hint: 'Elevation Church',
                icon: Icons.church,
                controller: _eventLocationController,
                onChanged: (value) {},
              ),
              const SizedBox(height: Insets.medium),
              DateTimeTextFieldWidget(
                onDateTimeChanged: (dateTime) {
                  setState(() {
                    _dateTimeString = dateTime;
                  });
                },
              ),
              const SizedBox(height: Insets.medium),
              Text(
                'Participants',
                style: context.textTheme.titleSmall,
              ),
              if (ref
                  .watch(eventControllerProvider)
                  .addedMembers
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
                  return RehearsalTile(
                    title: rehearsal.name ?? '',
                    dateTime: rehearsal.dateTime ?? DateTime.now(),
                    onTap: () {},
                    onDelete: () {},
                  );
                },
              ),
              _buildCreateRehearsalButton(),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  void _disableTooltip() {
    _addRemindersTooltipKey.currentState?.hideTooltip();
    ref.read(userSettingsNotifierProvider.notifier).updateUserSettings(
          const UserSettings(
            isAddRemindersTooltipShown: true,
          ),
        );
  }

  Future<void> _createDraftEvent(BuildContext context) async {
    _setFieldsOnController();

    if (_formKey.currentState!.validate()) {
      await ref.read(eventNotifierProvider.notifier).createEvent();

      final eventId = ref.watch(eventNotifierProvider).event?.id;
      if (eventId == null) {
        return;
      }

      await ref.read(reminderNotifierProvider.notifier).createReminders(
            _reminders,
            ref.watch(eventNotifierProvider).event!.id!,
          );

      if (mounted) {
        context.pushReplacementNamed(
          AppRoute.eventDetails.name,
          queryParameters: {
            'eventId': ref.watch(eventNotifierProvider).event!.id,
          },
        );
      }
    } else {
      logger.e('error');
    }
  }

  void _setFieldsOnController() {
    ref
        .read(eventControllerProvider.notifier)
        .setEventLocation(_eventLocationController.text);
    ref
        .read(eventControllerProvider.notifier)
        .setEventName(_eventNameController.text);
    ref
        .read(eventControllerProvider.notifier)
        .setDateTime(_dateTimeString ?? '');
  }

  Widget _buildParticipantsList() {
    final addedTeamMembers = ref.watch(eventControllerProvider).addedMembers;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: addedTeamMembers.length,
        itemBuilder: (context, index) {
          return ParticipantListingItem(
            name: '${addedTeamMembers[index].name}',
            photo: addedTeamMembers[index].profilePicture ?? Uint8List(0),
            status: StagerStatusEnum.UNINVINTED,
            onDelete: () {
              ref
                  .read(eventControllerProvider.notifier)
                  .removeMemberFromCache(addedTeamMembers[index].id);
            },
          );
        },
      ),
    );
  }

  Widget _buildCreateRehearsalButton() {
    return EventActionButton(
      onTap: () {
        CreateRehearsalModal.show(
          context: context,
        );
      },
      text: 'Create new Rehearsal',
      icon: Icons.add,
    );
  }

  Widget _buildInvitePeopleButton() {
    return EventActionButton(
      onTap: () {
        if (mounted) {
          InvitePeopleToEventModal.show(
            context: context,
            onPressed: () {
              ref.read(eventControllerProvider.notifier).addMembersToCache();
              ref
                  .read(eventControllerProvider.notifier)
                  .resetSelectedMembersFromList();
            },
          );
        }
      },
      text: 'Invite People',
      icon: Icons.add,
    );
  }
}
