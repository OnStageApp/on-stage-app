import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event_template/event_template/application/event_templates_notifier.dart';
import 'package:on_stage_app/app/features/event_template/event_template/domain/event_template.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/adaptive_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventTemplatesModal extends ConsumerStatefulWidget {
  const EventTemplatesModal({required this.onEventTemplateSelected, super.key});
  static void show({
    required BuildContext context,
    required VoidCallback onEventTemplateSelected,
  }) {
    AdaptiveModal.show<void>(
      context: context,
      child: EventTemplatesModal(
        onEventTemplateSelected: onEventTemplateSelected,
      ),
    );
  }

  final VoidCallback onEventTemplateSelected;

  @override
  EventTemplatesModalState createState() => EventTemplatesModalState();
}

class EventTemplatesModalState extends ConsumerState<EventTemplatesModal> {
  EventTemplate? _selectedEventTemplate;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventTemplatesNotifierProvider.notifier).getEventTemplates();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventTemplates =
        ref.watch(eventTemplatesNotifierProvider).eventTemplates;
    return NestedScrollModal(
      buildHeader: () => const ModalHeader(title: 'Select Template'),
      headerHeight: () => 64,
      footerHeight: () => 64,
      buildFooter: () => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 36),
        child: ContinueButton(
          text: 'Create Event',
          isEnabled: _selectedEventTemplate != null,
          onPressed: () => _onCreating(context),
          isLoading: _isLoading,
        ),
      ),
      buildContent: () => Padding(
        padding: const EdgeInsets.only(bottom: 42, top: 12),
        child: Column(
          children: [
            RefreshIndicator.adaptive(
              onRefresh: () async {
                await ref
                    .read(eventTemplatesNotifierProvider.notifier)
                    .getEventTemplates();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: eventTemplates.length,
                  itemBuilder: (context, index) {
                    return _EventTemplateSelectionTile(
                      eventTemplate: eventTemplates[index],
                      isSelected: _selectedEventTemplate?.id ==
                          eventTemplates[index].id,
                      onTap: () {
                        setState(() {
                          if (_selectedEventTemplate == eventTemplates[index]) {
                            _selectedEventTemplate = null;
                          } else {
                            _selectedEventTemplate = eventTemplates[index];
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onCreating(BuildContext context) async {
    final eventTemplateId = _selectedEventTemplate?.id;
    if (eventTemplateId == null) return;

    try {
      setState(() => _isLoading = true);

      await ref
          .read(eventNotifierProvider.notifier)
          .createFromEventTemplate(eventTemplateId);

      if (!mounted) return;

      if (context.mounted) {
        context.popDialog();
      }

      if (context.mounted) {
        await context.pushNamed(AppRoute.addEvent.name);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create event: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

class _EventTemplateSelectionTile extends StatelessWidget {
  const _EventTemplateSelectionTile({
    required this.eventTemplate,
    required this.isSelected,
    required this.onTap,
  });

  final EventTemplate eventTemplate;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? context.colorScheme.primary
                : context.colorScheme.onSurfaceVariant,
            width: 1.6,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventTemplate.name ?? '',
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    eventTemplate.location ?? '',
                    style: context.textTheme.titleSmall!
                        .copyWith(color: context.colorScheme.outline),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                size: 20,
                color: isSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
