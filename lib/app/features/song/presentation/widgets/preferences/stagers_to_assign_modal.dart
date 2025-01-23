import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/application/get_stagers_by_event_provider.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_overview.dart';
import 'package:on_stage_app/app/features/event_items/application/assigned_stagers_to_item/assigned_stagers_to_item_notifier.dart';
import 'package:on_stage_app/app/features/event_items/application/event_items_notifier.dart';
import 'package:on_stage_app/app/features/search/presentation/stage_search_bar.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/image_with_placeholder.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/shared/top_flush_bar.dart';
import 'package:on_stage_app/app/utils/adaptive_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class StagersToAssignModal extends ConsumerStatefulWidget {
  const StagersToAssignModal({
    required this.eventItemId,
    required this.onStagersSelected,
    required this.onSave,
    this.maxParticipants = 12,
    super.key,
  });

  final String? eventItemId;
  final void Function(List<StagerOverview>) onStagersSelected;
  final void Function(List<StagerOverview>) onSave;
  final int maxParticipants;

  static void show({
    required BuildContext context,
    required String? eventItemId,
    required void Function(List<StagerOverview>) onStagersSelected,
    required void Function(List<StagerOverview>) onSave,
    int? maxParticipants = 12,
  }) {
    AdaptiveModal.show(
      context: context,
      child: StagersToAssignModal(
        eventItemId: eventItemId,
        onStagersSelected: onStagersSelected,
        onSave: onSave,
        maxParticipants: maxParticipants ?? 12,
      ),
    );
  }

  @override
  ConsumerState<StagersToAssignModal> createState() =>
      StagersToAssignModalState();
}

class StagersToAssignModalState extends ConsumerState<StagersToAssignModal> {
  final TextEditingController _searchController = TextEditingController();
  List<StagerOverview> _searchedVocals = [];
  List<StagerOverview> _addedVocals = [];

  @override
  void initState() {
    super.initState();
    _initializeSelectedStagers();
  }

  bool get isCreating => widget.eventItemId == null;

  @override
  Widget build(BuildContext context) {
    final eventId = ref.watch(eventNotifierProvider).event?.id;
    if (eventId == null) return const SizedBox.shrink();

    final stagersAsyncValue = ref.watch(stagersByEventProvider(eventId));

    return NestedScrollModal(
      buildHeader: () => const ModalHeader(title: 'Select Members'),
      headerHeight: () => 64,
      buildFooter: () {
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 32),
          child: ContinueButton(
            text: 'Save',
            onPressed: () {
              widget.onSave(_addedVocals);
              context.popDialog();
            },
            isEnabled: true,
          ),
        );
      },
      footerHeight: () => 64,
      buildContent: () => stagersAsyncValue.when(
        loading: _buildLoading,
        error: (error, stack) => _buildError(error),
        data: (stagers) {
          if (_searchedVocals.isEmpty) {
            _searchedVocals = List.from(stagers);
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                StageSearchBar(
                  controller: _searchController,
                  onClosed: () => _clearSearch(stagers),
                  onChanged: (value) => _filterVocals(value, stagers),
                  focusNode: FocusNode(),
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _searchedVocals.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final stager = _searchedVocals[index];
                    final isChecked = _isItemChecked(stager);
                    final isMaxReached = !_isItemChecked(stager) &&
                        _addedVocals.length >= widget.maxParticipants;

                    return Opacity(
                      opacity: isMaxReached ? 0.5 : 1.0,
                      child: InkWell(
                        onTap: () => _toggleVocalSelection(stager, isChecked),
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: context.colorScheme.onSurfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isChecked
                                  ? Colors.blue
                                  : context.colorScheme.onSurfaceVariant,
                              width: 1.6,
                            ),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 12),
                              ImageWithPlaceholder(
                                photo: stager.profilePicture,
                                name: stager.name,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  stager.name,
                                  style: context.textTheme.titleSmall,
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Icon(
                                  isChecked
                                      ? Icons.check_circle_rounded
                                      : Icons.circle_outlined,
                                  size: 20,
                                  color: isChecked
                                      ? Colors.blue
                                      : context.colorScheme.outline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }

  Padding _buildError(Object error) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Padding _buildLoading() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void _initializeSelectedStagers() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final leadVocals = isCreating
          ? ref.read(stagerSelectionProvider)
          : ref
                  .read(eventItemsNotifierProvider)
                  .eventItems
                  .firstWhere((item) => item.id == widget.eventItemId)
                  .assignedTo ??
              [];
      setState(() {
        _addedVocals = List.from(leadVocals);
      });
    });
  }

  void _toggleVocalSelection(StagerOverview stager, bool isChecked) {
    setState(() {
      if (isChecked) {
        _removeStager(stager);
      } else {
        _addStager(stager);
      }
    });
  }

  void _removeStager(StagerOverview stager) {
    _addedVocals.removeWhere((vocal) => vocal.id == stager.id);
    widget.onStagersSelected(_addedVocals);
  }

  void _addStager(StagerOverview stager) {
    if (_addedVocals.length >= widget.maxParticipants) {
      TopFlushBar.show(
        context,
        'You can add up to ${widget.maxParticipants} participants only.',
        isError: true,
      );
      return;
    }

    _addedVocals.add(stager);

    print('addedVocals: ${stager.name}');
    widget.onStagersSelected(_addedVocals);
  }

  bool _isItemChecked(StagerOverview stager) =>
      _addedVocals.any((addedVocal) => addedVocal.id == stager.id);

  void _clearSearch(List<StagerOverview> allStagers) {
    _searchController.clear();
    setState(() {
      _searchedVocals = List.from(allStagers);
    });
  }

  void _filterVocals(String value, List<StagerOverview> allStagers) {
    if (value.isEmpty) {
      _clearSearch(allStagers);
    } else {
      setState(() {
        _searchedVocals = allStagers.where((stager) {
          final name = stager.name.toLowerCase() ?? '';
          return name.contains(value.toLowerCase());
        }).toList();
      });
    }
  }
}
