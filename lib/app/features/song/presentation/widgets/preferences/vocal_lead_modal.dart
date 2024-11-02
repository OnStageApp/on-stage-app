import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager.dart';
import 'package:on_stage_app/app/features/event_items/application/event_item_notifier/event_item_notifier.dart';
import 'package:on_stage_app/app/features/event_items/application/event_items_notifier.dart';
import 'package:on_stage_app/app/features/search/presentation/stage_search_bar.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/image_with_placeholder.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/shared/top_flush_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class VocalLeadModal extends ConsumerStatefulWidget {
  const VocalLeadModal({super.key});

  @override
  VocalLeadModalState createState() => VocalLeadModalState();

  static void show({
    required BuildContext context,
  }) {
    showModalBottomSheet<Widget>(
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
        minHeight: MediaQuery.of(context).size.height * 0.7,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      context: context,
      builder: (context) => NestedScrollModal(
        buildHeader: () => const ModalHeader(title: 'Add Lead Vocals'),
        headerHeight: () => 64,
        buildFooter: () {
          return Consumer(
            builder: (context, ref, _) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: ContinueButton(
                  text: 'Save',
                  onPressed: () {
                    final eventItemsNotifier =
                        ref.read(eventItemsNotifierProvider);
                    final eventItemId = eventItemsNotifier
                        .eventItems[eventItemsNotifier.currentIndex].id;
                    final cachedVocals =
                        ref.read(eventItemNotifierProvider).leadVocalsCacheList;
                    ref
                        .read(eventItemNotifierProvider.notifier)
                        .updateLeadVocals(eventItemId!, cachedVocals);
                    context.popDialog();
                  },
                  isEnabled: true,
                ),
              );
            },
          );
        },
        footerHeight: () => 64,
        buildContent: VocalLeadModal.new,
      ),
    );
  }
}

//TODO: Add FORUI in the APP and LUCIDE Icons instead of these
class VocalLeadModalState extends ConsumerState<VocalLeadModal> {
  final TextEditingController _searchController = TextEditingController();
  late List<Stager> _allVocals;
  late List<Stager> _searchedVocals;
  late List<Stager> _addedVocals;

  static const int _maxParticipants = 3;

  @override
  void initState() {
    super.initState();
    final stagers = ref.read(eventNotifierProvider).stagers;
    final leadVocals = ref.read(eventItemNotifierProvider).leadVocals;
    _allVocals = stagers;
    _searchedVocals = List.from(_allVocals);
    _addedVocals = List.from(leadVocals);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          StageSearchBar(
            controller: _searchController,
            onClosed: _clearSearch,
            onChanged: _filterVocals,
            focusNode: FocusNode(),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _searchedVocals.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final stager = _searchedVocals[index];
              final isChecked = _isItemChecked(stager);
              final isMaxReached = !_isItemChecked(stager) &&
                  _addedVocals.length >= _maxParticipants;

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
                          name: stager.name ?? '',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            stager.name ?? '',
                            style: context.textTheme.titleSmall,
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
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
          const SizedBox(height: 80), // Space for the floating button
        ],
      ),
    );
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchedVocals = List.from(_allVocals);
    });
  }

  void _filterVocals(String value) {
    if (value.isEmpty) {
      _clearSearch();
    } else {
      setState(() {
        _searchedVocals = _allVocals.where((stager) {
          final name = stager.name?.toLowerCase() ?? '';
          return name.contains(value.toLowerCase());
        }).toList();
      });
    }
  }

  bool _isItemChecked(Stager stager) {
    return _addedVocals.any((addedVocal) => addedVocal.id == stager.id);
  }

  void _toggleVocalSelection(Stager stager, bool isChecked) {
    final notifier = ref.read(eventItemNotifierProvider.notifier);
    setState(() {
      if (isChecked) {
        notifier.removeFromLeadVocalsCache(stager);
        _addedVocals.removeWhere((vocal) => vocal.id == stager.id);
      } else {
        if (_addedVocals.length >= _maxParticipants) {
          TopFlushBar.show(
            context,
            'You can add up to $_maxParticipants participants only.',
            isError: true,
          );
        } else {
          notifier.addToLeadVocalsCache(stager);
          _addedVocals.add(stager);
        }
      }
    });
  }

  Widget _buildAvatar(Stager stager) {
    final initial =
        (stager.name?.isNotEmpty ?? false) ? stager.name![0].toUpperCase() : '';
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.green,
          width: 3,
        ),
        shape: BoxShape.circle,
      ),
      child: Text(
        initial,
        textAlign: TextAlign.center,
        style: context.textTheme.titleSmall,
      ),
    );
  }
}
