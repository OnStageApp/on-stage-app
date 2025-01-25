import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_overview.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item.dart';
import 'package:on_stage_app/app/features/event_items/presentation/controllers/moment_controller.dart';
import 'package:on_stage_app/app/features/event_items/presentation/widget/moment_content_section.dart';
import 'package:on_stage_app/app/features/event_items/presentation/widget/moment_profile_section.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/shared/dash_divider.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class MomentScreen extends ConsumerStatefulWidget {
  const MomentScreen(this.eventItem, {super.key});

  final EventItem eventItem;

  @override
  ConsumerState<MomentScreen> createState() => _MomentScreenState();
}

class _MomentScreenState extends ConsumerState<MomentScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final FocusNode _descriptionFocusNode;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.eventItem.name);
    _descriptionController = TextEditingController(
      text: widget.eventItem.description,
    );
    _descriptionFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref
            .read(momentControllerProvider(widget.eventItem).notifier)
            .toggleEditing(isEditing: false);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  List<StagerOverview> get assignedStagers {
    return widget.eventItem.assignedTo ?? [];
  }

  bool get _isEditingEnabled =>
      ref.watch(permissionServiceProvider).hasAccessToEdit &&
      ref.watch(momentControllerProvider(widget.eventItem)).isEditing;

  void _updateControllers(String title, String description) {
    if (!mounted) return;

    if (_titleController.text != title) {
      _titleController.text = title;
    }
    if (_descriptionController.text != description) {
      _descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(momentControllerProvider(widget.eventItem));
    final event = ref.watch(eventNotifierProvider).event;
    _updateControllers(state.title, state.description);

    if (event == null) return const SizedBox();
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: context.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                MomentProfileSection(
                  assignedStagers: assignedStagers,
                  event: event,
                  eventItem: widget.eventItem,
                ),
                const SizedBox(height: 24),
                DashedLineDivider(
                  color: context.colorScheme.primaryContainer,
                  dashWidth: 1,
                  dashSpace: 8,
                ),
                const SizedBox(height: 24),
                MomentContentSection(
                  titleController: _titleController,
                  descriptionController: _descriptionController,
                  descriptionFocusNode: _descriptionFocusNode,
                  isEditingEnabled: _isEditingEnabled,
                  onContentChanged: (title, description) {
                    ref
                        .read(
                            momentControllerProvider(widget.eventItem).notifier)
                        .updateContent(title, description);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
