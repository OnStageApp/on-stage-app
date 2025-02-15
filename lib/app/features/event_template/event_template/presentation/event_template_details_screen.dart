import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/event_template/event_template/application/current_event_template_notifier.dart';
import 'package:on_stage_app/app/features/event_template/event_template/application/event_templates_notifier.dart';
import 'package:on_stage_app/app/features/event_template/event_template/domain/event_template.dart';
import 'package:on_stage_app/app/features/event_template/event_template/domain/event_template_request.dart';
import 'package:on_stage_app/app/features/event_template/event_template/presentation/widgets/reminders_list.dart';
import 'package:on_stage_app/app/features/groups/group_event_template/application/group_event_template_notifier.dart';
import 'package:on_stage_app/app/features/groups/shared/presentation/groups_obj_grid.dart';
import 'package:on_stage_app/app/features/song/presentation/add_new_song/adaptive_dialog_on_pop.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/dash_divider.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';

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
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  late List<int> _reminders;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _initEventTemplate();
  }

  void _initControllers() {
    _nameController = TextEditingController(text: widget.eventTemplate.name)
      ..addListener(_onFieldsChanged);
    _locationController =
        TextEditingController(text: widget.eventTemplate.location)
          ..addListener(_onFieldsChanged);
    _reminders = List.from(widget.eventTemplate.reminderDays);
  }

  void _initEventTemplate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(currentEventTemplateProvider.notifier)
          .initialize(widget.eventTemplate);
      ref
          .read(groupEventTemplateNotifierProvider.notifier)
          .getGroupsForEventTemplate(widget.eventTemplate.id!);
    });
  }

  void _onFieldsChanged() {
    final hasNameChanged = _nameController.text != widget.eventTemplate.name;
    final hasLocationChanged =
        _locationController.text != widget.eventTemplate.location;
    final hasRemindersChanged =
        !listEquals(_reminders, widget.eventTemplate.reminderDays);

    setState(() {
      _hasChanges = hasNameChanged || hasLocationChanged || hasRemindersChanged;
    });
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final formData = EventTemplateRequest(
      id: widget.eventTemplate.id,
      name: _nameController.text,
      location: _locationController.text,
      reminderDays: _reminders,
    );

    await ref
        .read(currentEventTemplateProvider.notifier)
        .updateEventTemplate(formData);
    setState(() => _hasChanges = false);
  }

  Future<void> _handleDelete() async {
    final shouldDelete = await AdaptiveDialogOnPop.show(
      context: context,
      description: 'Are you sure you want to delete this template?',
    );

    if (shouldDelete ?? true) {
      if (mounted) {
        context.pop();
      }

      await ref
          .read(currentEventTemplateProvider.notifier)
          .deleteEventTemplate(widget.eventTemplate.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: StageAppBar(
          title: widget.isNew ? 'Create Template' : 'Edit Template',
          isBackButtonVisible: true,
          trailing: _ScheduleButton(
            hasChanges: _hasChanges,
            onSave: _handleSave,
          ),
          onBackButtonPressed: () async {
            final eventTemplateId = widget.eventTemplate.id;
            if (_nameController.text.isNotEmpty &&
                eventTemplateId.isNotNullEmptyOrWhitespace) {
              await ref
                  .read(eventTemplatesNotifierProvider.notifier)
                  .getEventTemplates();
              if (context.mounted) context.pop();
              return;
            }

            final shouldPop = await AdaptiveDialogOnPop.show(
              context: context,
              description: "Name is missing, your template won't be saved. "
                  'Are you sure you want to exit?',
            );

            if (shouldPop ?? true) {
              if (context.mounted) {
                context.pop();
              }

              await ref
                  .read(currentEventTemplateProvider.notifier)
                  .deleteEventTemplate(widget.eventTemplate.id!);
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
        floatingActionButton: _hasChanges ? _buildSaveButton() : null,
        body: Padding(
          padding: defaultScreenPadding,
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ContinueButton(
        text: 'Save',
        onPressed: _handleSave,
        isEnabled: true,
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          _buildNameField(),
          const SizedBox(height: Insets.medium),
          _buildLocationField(),
          const SizedBox(height: Insets.medium),
          _buildMembersSection(),
          const SizedBox(height: 24),
          _buildRemindersList(),
          const SizedBox(height: 24),
          const DashedLineDivider(),
          const SizedBox(height: 24),
          _buildDeleteButton(),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return CustomTextField(
      label: 'Name',
      hint: 'Summer Concert',
      icon: Icons.church,
      controller: _nameController,
      requiredField: true,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Please enter a name for template';
        }
        return null;
      },
    );
  }

  Widget _buildLocationField() {
    return CustomTextField(
      label: 'Location',
      hint: 'Charlotte, NC 28277, US',
      icon: Icons.church,
      controller: _locationController,
      validator: (value) => null,
    );
  }

  Widget _buildMembersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Members', style: context.textTheme.titleSmall),
        const SizedBox(height: Insets.smallNormal),
        GroupsObjGrid.fromEventTemplateId(
          eventTemplateId: widget.eventTemplate.id,
        ),
      ],
    );
  }

  Widget _buildRemindersList() {
    return RemindersList(
      reminders: _reminders,
      onRemindersChanged: (newReminders) {
        setState(() {
          _reminders = newReminders;
          _onFieldsChanged();
        });
      },
    );
  }

  Widget _buildDeleteButton() {
    return PreferencesActionTile(
      title: 'Delete Template',
      color: context.colorScheme.error,
      leadingWidget: Icon(
        LucideIcons.trash_2,
        color: context.colorScheme.error,
        size: 20,
      ),
      height: 54,
      onTap: _handleDelete,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}

class _ScheduleButton extends ConsumerWidget {
  const _ScheduleButton({
    required this.hasChanges,
    required this.onSave,
  });
  final bool hasChanges;
  final Future<void> Function() onSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventTemplateId =
        ref.watch(currentEventTemplateProvider).eventTemplate?.id;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: context.colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 32,
          child: InkWell(
            onTap: () async {
              if (hasChanges) {
                await onSave();
              }
              if (context.mounted) {
                unawaited(
                  context.pushNamed(
                    AppRoute.eventItemTemplateSchedule.name,
                    queryParameters: {
                      'eventTemplateId': eventTemplateId.toString(),
                    },
                  ),
                );
              }
            },
            overlayColor: WidgetStatePropertyAll(
              context.colorScheme.onSurface.withAlpha(20),
            ),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.list_music,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Schedule',
                    style: context.textTheme.labelMedium!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
