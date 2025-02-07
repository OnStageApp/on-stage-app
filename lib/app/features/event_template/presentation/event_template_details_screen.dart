import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/presentation/create_rehearsal_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/custom_setting_tile.dart';
import 'package:on_stage_app/app/features/event_template/application/current_event_template_notifier.dart';
import 'package:on_stage_app/app/features/event_template/domain/event_template.dart';
import 'package:on_stage_app/app/features/groups/group_event/presentation/widgets/groups_event_grid.dart';
import 'package:on_stage_app/app/features/groups/group_event_template/application/group_event_template_notifier.dart';
import 'package:on_stage_app/app/features/reminder/presentation/set_reminder_modal.dart';
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

class EventTemplateDetailsScreen extends ConsumerStatefulWidget {
  const EventTemplateDetailsScreen({
    required this.eventTemplate,
    this.isNew = false,
    super.key,
  });

  final EventTemplate eventTemplate;
  final bool isNew;

  @override
  EventTemplateDetailsScreenState createState() =>
      EventTemplateDetailsScreenState();
}

class EventTemplateDetailsScreenState
    extends ConsumerState<EventTemplateDetailsScreen> {
  final _eventNameController = TextEditingController();
  final _eventLocationController = TextEditingController();
  var _reminders = <int>[];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _initFields();
    logger.i('isNewEventTemplate : ${widget.isNew}');
    _initEventTemplate();
    super.initState();
  }

  void _initEventTemplate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(currentEventTemplateProvider.notifier)
          .initialize(widget.eventTemplate);

      if (widget.isNew) {
      } else {
        ref
            .read(groupEventTemplateNotifierProvider.notifier)
            .getGroupsForEventTemplate(widget.eventTemplate.id!);
      }
    });
  }

  void _initFields() {
    _eventNameController.text = widget.eventTemplate.name ?? '';
    _eventLocationController.text = widget.eventTemplate.location ?? '';
    _reminders = widget.eventTemplate.reminderDays ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ContinueButton(
          text: 'Save',
          onPressed: _saveEventTemplate,
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
            //TODO: Discarc changes of an eventTemplate
            // unawaited(ref.read(eventNotifierProvider.notifier).deleteEvent());
            if (mounted) context.pop();
          }
        },
        title: 'Edit Template',
      ),
      body: Padding(
        padding: defaultScreenPadding,
        child: Form(
          key: _formKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              CustomTextField(
                label: 'Event Template Name',
                hint: 'Summer Concert',
                icon: Icons.church,
                controller: _eventNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an event template name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Insets.medium),
              CustomTextField(
                label: 'Event Location',
                hint: 'Charlotte, NC 28277, US',
                icon: Icons.church,
                controller: _eventLocationController,
              ),

              const SizedBox(height: Insets.medium),
              Text(
                'Members',
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(height: Insets.smallNormal),
              //TODO: GroupTemaplateGrid
              GroupsEventGrid.fromEventTemplateId(
                eventTemplateId: widget.eventTemplate?.id,
              ),
              const SizedBox(height: 24),
              Text(
                'Reminders',
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(height: Insets.smallNormal),
              ListView.builder(
                itemCount: _reminders.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final reminder = _reminders[index];
                  if (reminder == 0) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CustomSettingTile(
                      backgroundColor: context.colorScheme.onSurfaceVariant,
                      placeholder: 'Alert ${_reminders.indexOf(reminder) + 1}',
                      placeholderColor: context.colorScheme.onSurface,
                      suffix: Text(
                        '$reminder days before',
                        style: context.textTheme.titleMedium!
                            .copyWith(color: context.colorScheme.onSurface),
                      ),
                    ),
                  );
                },
              ),
              EventActionButton(
                text: ' Select Reminders',
                icon: Icons.notification_add_outlined,
                onTap: () {
                  _editReminders(context);
                },
              ),
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

  Future<void> _saveEventTemplate() async {
    if (_isFormValid()) {
      //TODO: if valid, update the event template
      // await ref.read(eventNotifierProvider.notifier).updateEventOnCreate();

      // final eventId = ref.watch(eventNotifierProvider).event?.id;
      // if (eventId == null) {
      //   return;
      // }

      if (mounted) {
        context.pop();
      }
    } else {
      logger.i('Form is not valid');
    }
  }

  Widget _buildCreateRehearsalButton() {
    return EventActionButton(
      onTap: () {
        CreateRehearsalModal.show(
          context: context,
          onRehearsalCreated: (rehearsal) {
            //TODO: add rehearsal to templateEvent
            // ref.read(eventNotifierProvider.notifier).addRehearsal(rehearsal);
          },
        );
      },
      text: 'Create new Rehearsal',
      icon: Icons.add,
    );
  }

  bool _isFormValid() => _formKey.currentState!.validate();

  Future<void> _editReminders(BuildContext context) async {
    //TODO: Set reminders on eventTemplateModel, we don't need to create new objects, a list<int> will be enough
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
  }
}
