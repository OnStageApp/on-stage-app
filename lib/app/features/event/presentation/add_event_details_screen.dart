import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_stage_app/app/features/event/application/event/controller/event_controller.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/presentation/create_rehearsal_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/date_time_text_field.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/reminders_section.dart';
import 'package:on_stage_app/app/features/groups/group_event/application/group_event_notifier.dart';
import 'package:on_stage_app/app/features/groups/shared/presentation/groups_obj_grid.dart';
import 'package:on_stage_app/app/features/reminder/application/reminder_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/add_new_song/adaptive_dialog_on_pop.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/dash_divider.dart';
import 'package:on_stage_app/app/shared/rehearsal_tile.dart';
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
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDateTime;
  var _reminders = <int>[];
  String? _dateTimeError;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final eventId = ref.watch(eventNotifierProvider).event?.id;
      if (eventId != null) {
        _prefillFields();
        ref.read(reminderNotifierProvider.notifier).getReminders(eventId);
        ref.read(groupEventNotifierProvider.notifier).getGroupsEvent(eventId);
      }
    });
    super.initState();
  }

  void _prefillFields() {
    final event = ref.watch(eventNotifierProvider).event;
    if (event != null) {
      _eventNameController.text = event.name ?? '';
      _eventLocationController.text = event.location ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventId = ref.watch(eventNotifierProvider).event?.id;

    if (eventId == null) {
      return const SizedBox();
    }

    _reminders = ref.watch(reminderNotifierProvider).reminders.map((e) {
      return e.daysBefore;
    }).toList();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ContinueButton(
          text: 'Create Event',
          onPressed: () {
            _createDraftEvent(context);
          },
          isEnabled: true,
        ),
      ),
      appBar: StageAppBar(
        isBackButtonVisible: true,
        onBackButtonPressed: () async {
          final shouldPop = await AdaptiveDialogOnPop.show(
            context: context,
          );

          if (shouldPop ?? true) {
            unawaited(ref.read(eventNotifierProvider.notifier).deleteEvent());
            if (context.mounted) context.pop();
          }
        },
        title: 'Create Event',
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
                hint: 'Sunday Service',
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
                hint: 'Charlotte, NC 28277, US',
                icon: Icons.church,
                controller: _eventLocationController,
                onChanged: (value) {},
              ),
              const SizedBox(height: Insets.medium),
              DateTimeTextFieldWidget(
                initialDateTime: _selectedDateTime,
                onDateTimeChanged: (dateTime) {
                  setState(() {
                    _selectedDateTime = dateTime;
                  });
                },
                dateErrorText: _dateTimeError,
              ),
              const SizedBox(height: Insets.medium),
              Text(
                'Members',
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(height: Insets.smallNormal),
              GroupsObjGrid.fromEventId(
                eventId: eventId,
              ),
              const SizedBox(height: 24),
              const RemindersSection(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: DashedLineDivider(),
              ),
              Text(
                'Rehearsals',
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(height: Insets.smallNormal),
              SlidableAutoCloseBehavior(
                child: Column(
                  children: ref.watch(eventNotifierProvider).rehearsals.map(
                    (rehearsal) {
                      return RehearsalTile(
                        title: rehearsal.name ?? '',
                        dateTime: rehearsal.dateTime ?? DateTime.now(),
                        onTap: () {},
                        onDelete: () {},
                      );
                    },
                  ).toList(),
                ),
              ),
              _buildCreateRehearsalButton(),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createDraftEvent(BuildContext context) async {
    _setFieldsOnController();

    if (_isDateTimeInvalid()) {
      setState(() {
        _dateTimeError = 'Please choose a valid date and time';
      });
    } else {
      setState(() {
        _dateTimeError = null;
      });
    }

    if (_isFormValid()) {
      await ref.read(eventNotifierProvider.notifier).updateEventOnCreate();

      final eventId = ref.watch(eventNotifierProvider).event?.id;
      if (eventId == null) {
        return;
      }

      if (_reminders.isNotEmpty) {
        await ref.read(reminderNotifierProvider.notifier).createReminders(
              _reminders,
              ref.watch(eventNotifierProvider).event!.id!,
            );
      }

      if (context.mounted) {
        context.pushReplacementNamed(
          AppRoute.eventDetails.name,
          queryParameters: {
            'eventId': ref.watch(eventNotifierProvider).event!.id,
          },
        );
      }
    } else {
      logger.i('Form is not valid');
    }
  }

  void _setFieldsOnController() {
    ref
        .read(eventControllerProvider.notifier)
        .setEventLocation(_eventLocationController.text);
    ref
        .read(eventControllerProvider.notifier)
        .setEventName(_eventNameController.text);
    ref.read(eventControllerProvider.notifier).setDateTime(_selectedDateTime);
  }

  Widget _buildCreateRehearsalButton() {
    return EventActionButton(
      onTap: () {
        CreateRehearsalModal.show(
          context: context,
          onRehearsalCreated: (rehearsal) {
            ref.read(eventNotifierProvider.notifier).addRehearsal(rehearsal);
          },
        );
      },
      text: 'Create new Rehearsal',
      icon: Icons.add,
    );
  }

  bool _isDateTimeInvalid() {
    return _selectedDateTime == null ||
        _selectedDateTime!.isBefore(DateTime.now());
  }

  bool _isFormValid() =>
      _formKey.currentState!.validate() && _dateTimeError == null;
}
