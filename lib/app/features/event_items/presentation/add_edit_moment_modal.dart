import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_overview.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participant_listing_item.dart';
import 'package:on_stage_app/app/features/event_items/application/assigned_stagers_to_item/assigned_stagers_to_item_notifier.dart';
import 'package:on_stage_app/app/features/event_items/application/event_items_notifier.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item_create.dart';
import 'package:on_stage_app/app/features/event_items/presentation/widget/edit_duration_moment.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/stagers_to_assign_modal.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/list_utils.dart';

class AddEditMomentModal extends ConsumerStatefulWidget {
  const AddEditMomentModal({
    this.eventItem,
    this.onMomentAdded,
    this.enabled = true,
    super.key,
  });

  final void Function(EventItem)? onMomentAdded;
  final EventItem? eventItem;
  final bool enabled;

  @override
  AddEditMomentModalState createState() => AddEditMomentModalState();

  static void show({
    required BuildContext context,
    EventItem? eventItem,
    void Function(EventItem)? onMomentAdded,
    bool enabled = true,
  }) {
    showModalBottomSheet<Widget>(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surfaceContainerHigh,
      context: context,
      builder: (context) => SafeArea(
        child: NestedScrollModal(
          buildHeader: () => ModalHeader(
            title: eventItem != null
                ? eventItem.name ?? 'Edit Moment'
                : 'New Moment',
          ),
          headerHeight: () => 64,
          buildContent: () => SingleChildScrollView(
            child: AddEditMomentModal(
              onMomentAdded: onMomentAdded,
              eventItem: eventItem,
              enabled: enabled,
            ),
          ),
        ),
      ),
    );
  }
}

class AddEditMomentModalState extends ConsumerState<AddEditMomentModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();
  Duration? _selectedDuration;

  final _formKey = GlobalKey<FormState>();

  bool get isNewMoment {
    return widget.eventItem?.id == null;
  }

  @override
  void initState() {
    super.initState();
    _fillFieldsIfIsEditing();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(stagerSelectionProvider.notifier).clearStagers();
      FocusScope.of(context).requestFocus(_titleFocus);
    });
  }

  void _fillFieldsIfIsEditing() {
    if (!isNewMoment) {
      setState(() {
        _selectedDuration = widget.eventItem?.duration;
      });
      if (widget.eventItem?.assignedTo != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(stagerSelectionProvider.notifier).setStagers(
                widget.eventItem!.assignedTo!,
              );
        });
      }
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    super.dispose();
  }

  List<StagerOverview> get assignedStagersFromEventItem {
    if (isNewMoment) {
      return ref.watch(stagerSelectionProvider);
    } else {
      return ref
              .watch(eventItemsNotifierProvider)
              .eventItems[ref.read(eventItemsNotifierProvider).currentIndex]
              .assignedTo ??
          [];
    }
  }

  void _handleNewMomentStagers(List<StagerOverview> stagers) {
    ref.read(stagerSelectionProvider.notifier).setStagers(stagers);
  }

  void _handleEditMomentStagers(List<StagerOverview> stagers) {
    final currentItem = ref
        .read(eventItemsNotifierProvider)
        .eventItems[ref.read(eventItemsNotifierProvider).currentIndex];

    final updatedItem = currentItem.copyWith(
      assignedTo: stagers,
    );

    ref.read(eventItemsNotifierProvider.notifier).updateMomentItem(updatedItem);
  }

  void _addMoment() {
    final eventId = ref.watch(eventNotifierProvider).event?.id;
    if (eventId == null) return;

    final selectedStagers = ref.read(stagerSelectionProvider);
    final request = EventItemCreate(
      name: _titleController.text,
      description: _descriptionController.text,
      duration: _selectedDuration,
      eventId: eventId,
      assignedStagerIds: selectedStagers.map((e) => e.id).toList(),
      index: null,
    );
    ref.read(eventItemsNotifierProvider.notifier).addEventItemMoment(request);

    context.popDialog();
  }

  void _onDelete(StagerOverview currentStager, int index, String? eventItemId) {
    if (eventItemId == null) {
      ref.read(stagerSelectionProvider.notifier).removeStager(currentStager.id);
    } else {
      ref.read(eventItemsNotifierProvider.notifier).removeLeadVocal(
            eventItemId,
            currentStager.id,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final assignedStagers = assignedStagersFromEventItem;
    return Padding(
      padding: defaultScreenPadding,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isNewMoment) ...[
              CustomTextField(
                enabled: widget.enabled,
                label: 'Title',
                hint: 'Enter a title',
                icon: null,
                focusNode: _titleFocus,
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
                enabled: widget.enabled,
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
            ],
            Text('Duration', style: context.textTheme.titleSmall),
            const SizedBox(height: 12),
            EditDuration(
              selectedDuration: _selectedDuration,
              onDurationChanged: _editDurationOnEventItem,
            ),
            const SizedBox(height: 16),
            Text(
              'Persons',
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            if (assignedStagers.isNotNullOrEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: context.colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: assignedStagers.length,
                  itemBuilder: (context, index) {
                    final currentStager = assignedStagers[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: ParticipantListingItem(
                        canGoToProfile: false,
                        userId: currentStager.userId,
                        name: currentStager.name,
                        photo: currentStager.profilePicture,
                        onDelete: () {
                          _onDelete(
                            currentStager,
                            index,
                            widget.eventItem?.id,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            EventActionButton(
              onTap: () {
                StagersToAssignModal.show(
                  context: context,
                  eventItemId: widget.eventItem?.id,
                  onStagersSelected:
                      isNewMoment ? _handleNewMomentStagers : (_) {},
                  maxParticipants: 4,
                  onSave: isNewMoment
                      ? _handleNewMomentStagers
                      : _handleEditMomentStagers,
                );
              },
              text: 'Assign Persons',
              icon: Icons.add,
            ),
            const SizedBox(height: 32),
            if (widget.enabled && isNewMoment) ...[
              ContinueButton(
                isEnabled: true,
                hasShadow: false,
                text: isNewMoment ? 'Create' : 'Save',
                onPressed: isNewMoment ? _addMoment : _editStagersOnEventItem,
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  void _editDurationOnEventItem(Duration newDuration) {
    setState(() {
      _selectedDuration = newDuration;
    });
    if (isNewMoment) return;
    final currentItem = ref
        .read(eventItemsNotifierProvider)
        .eventItems[ref.read(eventItemsNotifierProvider).currentIndex];

    final updatedItem = currentItem.copyWith(
      duration: _selectedDuration,
    );

    ref.read(eventItemsNotifierProvider.notifier).updateMomentItem(updatedItem);
  }

  void _editStagersOnEventItem() {
    final currentItem = ref
        .read(eventItemsNotifierProvider)
        .eventItems[ref.read(eventItemsNotifierProvider).currentIndex];

    final updatedItem = currentItem.copyWith(
      assignedTo: ref.read(stagerSelectionProvider),
    );

    ref.read(eventItemsNotifierProvider.notifier).updateMomentItem(updatedItem);
    context.popDialog();
  }
}
