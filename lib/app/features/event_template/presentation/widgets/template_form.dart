import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/event_template/domain/event_template.dart';
import 'package:on_stage_app/app/features/event_template/domain/event_template_request.dart';
import 'package:on_stage_app/app/features/event_template/presentation/widgets/reminders_list.dart';
import 'package:on_stage_app/app/features/groups/shared/presentation/groups_obj_grid.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class TemplateForm extends StatefulWidget {
  const TemplateForm({
    required this.formKey,
    required this.eventTemplate,
    required this.originalTemplate,
    required this.onChangeState,
    required this.onFormDataChanged,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final EventTemplate eventTemplate;
  final EventTemplate originalTemplate;
  final void Function(bool) onChangeState;
  final void Function(EventTemplateRequest) onFormDataChanged;

  @override
  State<TemplateForm> createState() => _TemplateFormState();
}

class _TemplateFormState extends State<TemplateForm> {
  final _eventNameController = TextEditingController();
  final _eventLocationController = TextEditingController();
  var _reminders = <int>[];

  @override
  void initState() {
    super.initState();
    _initFields();
    _eventNameController.addListener(_onFieldsChanged);
    _eventLocationController.addListener(_onFieldsChanged);
  }

  @override
  void dispose() {
    _eventNameController.removeListener(_onFieldsChanged);
    _eventLocationController.removeListener(_onFieldsChanged);
    _eventNameController.dispose();
    _eventLocationController.dispose();
    super.dispose();
  }

  void _initFields() {
    _eventNameController.text = widget.eventTemplate.name ?? '';
    _eventLocationController.text = widget.eventTemplate.location ?? '';
    _reminders = widget.eventTemplate.reminderDays;
    _notifyFormDataChanged();
  }

  void _onFieldsChanged() {
    _checkForChanges();
    _notifyFormDataChanged();
  }

  void _notifyFormDataChanged() {
    final formData = EventTemplateRequest(
      id: widget.eventTemplate.id,
      name: _eventNameController.text,
      location: _eventLocationController.text,
      reminderDays: _reminders,
    );
    widget.onFormDataChanged(formData);
  }

  void _checkForChanges() {
    final hasNameChanged =
        _eventNameController.text != widget.originalTemplate.name;
    final hasLocationChanged =
        _eventLocationController.text != widget.originalTemplate.location;
    final hasRemindersChanged =
        !listEquals(_reminders, widget.originalTemplate.reminderDays);

    widget.onChangeState(
        hasNameChanged || hasLocationChanged || hasRemindersChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          CustomTextField(
            label: 'Name',
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
            label: 'Location',
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
          GroupsObjGrid.fromEventTemplateId(
            eventTemplateId: widget.eventTemplate.id,
          ),
          const SizedBox(height: 24),
          RemindersList(
            reminders: _reminders,
            onRemindersChanged: (newReminders) {
              setState(() {
                _reminders = newReminders;
                _onFieldsChanged();
              });
            },
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
