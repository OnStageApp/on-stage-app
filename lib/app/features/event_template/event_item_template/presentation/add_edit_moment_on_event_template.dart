import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/event_items/application/assigned_stagers_to_item/assigned_stagers_to_item_notifier.dart';
import 'package:on_stage_app/app/features/event_template/event_item_template/application/event_item_templates_notifier.dart';
import 'package:on_stage_app/app/features/event_template/event_item_template/domain/event_item_template.dart';
import 'package:on_stage_app/app/features/event_template/event_item_template/domain/event_item_template_create.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/adaptive_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AddEditMomentOnEventTemplate extends ConsumerStatefulWidget {
  const AddEditMomentOnEventTemplate({
    required this.eventTemplateId,
    this.eventItemTemplate,
    super.key,
  });

  final EventItemTemplate? eventItemTemplate;
  final String? eventTemplateId;

  @override
  AddEditMomentOnEventTemplateState createState() =>
      AddEditMomentOnEventTemplateState();

  static void show({
    required BuildContext context,
    required String? eventTemplateId,
    EventItemTemplate? eventItemTemplate,
  }) {
    AdaptiveModal.show<void>(
      context: context,
      child: AddEditMomentOnEventTemplate(
        eventItemTemplate: eventItemTemplate,
        eventTemplateId: eventTemplateId,
      ),
    );
  }
}

class AddEditMomentOnEventTemplateState
    extends ConsumerState<AddEditMomentOnEventTemplate> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool get isNewMoment {
    return widget.eventItemTemplate?.id == null;
  }

  @override
  void initState() {
    super.initState();
    _fillFieldsIfIsEditing();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(stagerSelectionProvider.notifier).clearStagers();
    });
  }

  void _fillFieldsIfIsEditing() {
    if (!isNewMoment) {
      setState(() {
        _titleController.text = widget.eventItemTemplate?.name ?? '';
        _descriptionController.text =
            widget.eventItemTemplate?.description ?? '';
      });
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _addMoment() {
    final request = EventItemTemplateCreate(
      name: _titleController.text,
      description: _descriptionController.text,
      eventTemplateId: widget.eventTemplateId,
      index: null,
    );
    ref
        .read(eventItemTemplatesNotifierProvider.notifier)
        .addEventItemTemplate(request);

    context.popDialog();
  }

  void _editMoment() {
    final eventItemTemplateId = widget.eventItemTemplate?.id;
    final request = EventItemTemplate(
      id: eventItemTemplateId!,
      name: _titleController.text,
      description: _descriptionController.text,
    );
    ref
        .read(eventItemTemplatesNotifierProvider.notifier)
        .updateEventItemTemplate(
          request,
        );

    context.popDialog();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollModal(
        buildHeader: () => ModalHeader(
          title: widget.eventItemTemplate != null
              ? widget.eventItemTemplate?.name ?? 'Edit Moment'
              : 'New Moment',
        ),
        headerHeight: () => 64,
        footerHeight: () => 64,
        buildFooter: () => Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: ContinueButton(
            isEnabled: true,
            hasShadow: false,
            text: 'Save',
            onPressed: isNewMoment ? _addMoment : _editMoment,
          ),
        ),
        buildContent: () => SingleChildScrollView(
          child: Padding(
            padding: defaultScreenPadding,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    enabled: true,
                    label: 'Title',
                    hint: 'Enter a title',
                    icon: null,
                    // focusNode: _titleFocus,
                    controller: _titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a rehearsal name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    enabled: true,
                    label: 'Description',
                    hint: 'Enter a description',
                    icon: null,
                    controller: _descriptionController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a rehearsal name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
