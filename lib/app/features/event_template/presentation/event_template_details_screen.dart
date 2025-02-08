import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event_template/application/current_event_template_notifier.dart';
import 'package:on_stage_app/app/features/event_template/domain/event_template.dart';
import 'package:on_stage_app/app/features/event_template/domain/event_template_request.dart';
import 'package:on_stage_app/app/features/event_template/presentation/widgets/template_form.dart';
import 'package:on_stage_app/app/features/groups/group_event_template/application/group_event_template_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/add_new_song/adaptive_dialog_on_pop.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/adaptive_menu_context.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

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
  bool _hasChanges = false;
  late EventTemplate _originalTemplate;
  final _formKey = GlobalKey<FormState>();
  EventTemplateRequest? _currentFormData;

  @override
  void initState() {
    super.initState();
    _originalTemplate = widget.eventTemplate;
    _initEventTemplate();
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

  void _updateChangesState(bool hasChanges) {
    setState(() {
      _hasChanges = hasChanges;
    });
  }

  void _handleFormDataChanged(EventTemplateRequest formData) {
    // setState(() {
    _currentFormData = formData;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _hasChanges
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ContinueButton(
                text: 'Save',
                onPressed: () async {
                  if (_formKey.currentState!.validate() &&
                      _currentFormData != null) {
                    await ref
                        .read(currentEventTemplateProvider.notifier)
                        .updateEventTemplate(_currentFormData!);
                    _updateChangesState(false);
                  }
                },
                isEnabled: true,
              ),
            )
          : null,
      appBar: StageAppBar(
        isBackButtonVisible: true,
        trailing: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: AdaptiveMenuContext(
            items: [
              MenuAction(
                title: 'Delete Template',
                onTap: () async {
                  if (mounted) context.pop();

                  final templateId = widget.eventTemplate.id!;
                  await ref
                      .read(currentEventTemplateProvider.notifier)
                      .deleteEventTemplate(templateId);
                },
                isDestructive: true,
              ),
            ],
            child: SizedBox(
              height: 30,
              width: 30,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: context.isDarkMode
                      ? const Color(0xFF43474E)
                      : context.colorScheme.onSurfaceVariant,
                ),
                child: Icon(
                  LucideIcons.ellipsis_vertical,
                  size: 15,
                  color: context.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
        onBackButtonPressed: () async {
          final shouldPop = await AdaptiveDialogOnPop.show(context: context);
          if (shouldPop ?? true) {
            if (mounted) context.pop();
          }
        },
        title: 'Edit Template',
      ),
      body: Padding(
        padding: defaultScreenPadding,
        child: TemplateForm(
          formKey: _formKey,
          eventTemplate: widget.eventTemplate,
          originalTemplate: _originalTemplate,
          onChangeState: _updateChangesState,
          onFormDataChanged: _handleFormDataChanged,
        ),
      ),
    );
  }
}
