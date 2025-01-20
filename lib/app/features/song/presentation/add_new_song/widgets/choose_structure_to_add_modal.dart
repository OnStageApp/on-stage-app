import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/search/presentation/stage_search_bar.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/shared/circle_structure_widget.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ChooseStructureToAddModal extends ConsumerStatefulWidget {
  const ChooseStructureToAddModal({
    super.key,
  });

  @override
  ChooseStructureToAddModalState createState() =>
      ChooseStructureToAddModalState();

  static Future<List<StructureItem>?> show({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    return showModalBottomSheet<List<StructureItem>>(
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: context.colorScheme.surfaceContainerHigh,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.95,
        minHeight: MediaQuery.of(context).size.height * 0.95,
        maxWidth: context.isLargeScreen
            ? context.screenSize.width * 0.5
            : double.infinity,
      ),
      context: context,
      builder: (context) => const ChooseStructureToAddModal(),
    );
  }
}

class ChooseStructureToAddModalState
    extends ConsumerState<ChooseStructureToAddModal> {
  final List<StructureItem> _selectedStructureItems = [];
  late List<StructureItem> _structureItems;
  late List<StructureItem> _filteredItems;
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _updateStructureItems();
    _filteredItems = _structureItems;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _filteredItems = _structureItems;
    });
  }

  void _filterItems(String query) {
    if (query.isEmpty) {
      _clearSearch();
      return;
    }

    setState(() {
      _filteredItems = _structureItems
          .where(
            (item) => item.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  void _updateStructureItems() {
    final currentSong = ref.read(songNotifierProvider).song;
    final usedStructures =
        currentSong.rawSections?.map((e) => e.structureItem).toSet();
    if (usedStructures == null) {
      _structureItems = StructureItem.values;
      _filteredItems = StructureItem.values;
      return;
    }
    _structureItems = StructureItem.values
        .where((item) => !usedStructures.contains(item))
        .toList();
    _filteredItems = _structureItems;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(songNotifierProvider, (previous, next) {
      _updateStructureItems();
    });

    return NestedScrollModal(
      buildHeader: () => _buildHeader(context),
      buildFooter: () => _buildFooter(context),
      headerHeight: () => 64,
      footerHeight: () => 64,
      buildContent: () => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 44),
            child: StageSearchBar(
              focusNode: _searchFocusNode,
              controller: _searchController,
              onClosed: _clearSearch,
              onChanged: _filterItems,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) {
              final item = _filteredItems[index];
              return InkWell(
                onTap: () {
                  _toggleItemSelection(item);
                },
                child: Container(
                  height: 52,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: context.colorScheme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isItemChecked(index)
                          ? context.colorScheme.primary
                          : context.colorScheme.onSurfaceVariant,
                      width: 1.6,
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      StructureCircleWidget(
                        structureItem: item, // Use item from filtered list
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          item.name, // Use item from filtered list
                          style: context.textTheme.titleSmall,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          _isItemChecked(index)
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          size: 20,
                          color: _isItemChecked(index)
                              ? context.colorScheme.primary
                              : context.colorScheme.surfaceBright,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  bool _isItemChecked(int index) {
    return _selectedStructureItems.contains(_filteredItems[index]);
  }

  void _toggleItemSelection(StructureItem item) {
    setState(() {
      if (_selectedStructureItems.contains(item)) {
        _selectedStructureItems.remove(item);
      } else {
        _selectedStructureItems.add(item);
      }
    });
  }

  Widget _buildFooter(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: ContinueButton(
          text: _selectedStructureItems.isEmpty
              ? 'Add'
              : 'Add (${_selectedStructureItems.length})',
          onPressed: () {
            Navigator.of(context).pop(_selectedStructureItems);
          },
          isEnabled: _selectedStructureItems.isNotEmpty,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return const ModalHeader(
      title: 'Song Structure',
    );
  }
}
