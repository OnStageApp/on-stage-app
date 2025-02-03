import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/controller/add_structure_controller.dart';
import 'package:on_stage_app/app/features/song/presentation/controller/song_preferences_controller.dart';
import 'package:on_stage_app/app/features/song/presentation/preferences/widgets/add__structure_items_widget.dart';
import 'package:on_stage_app/app/features/song/presentation/preferences/widgets/reorder_list_widget.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/adaptive_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongStructureModal extends ConsumerStatefulWidget {
  const SongStructureModal({
    this.closeAfterSave = false,
    super.key,
  });

  final bool closeAfterSave;

  @override
  SongStructureModalState createState() => SongStructureModalState();

  static void show({
    required BuildContext context,
    required WidgetRef ref,
    bool? closeAfterSave,
  }) {
    AdaptiveModal.show(
      context: context,
      child: SongStructureModal(closeAfterSave: closeAfterSave ?? false),
    );
  }
}

class SongStructureModalState extends ConsumerState<SongStructureModal> {
  bool isReorderPage = true;
  bool _isEditingMode = false;

  @override
  void initState() {
    _initCacheStructure();
    super.initState();
  }

  void _initCacheStructure() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(songPreferencesControllerProvider.notifier).addAllStructureItems(
            ref.watch(songNotifierProvider).song.structure?.toList() ?? [],
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollModal(
      buildHeader: () => _buildHeader(context),
      buildFooter: () => _buildFooter(context),
      headerHeight: () {
        return 64;
      },
      footerHeight: () {
        return 64;
      },
      buildContent: isReorderPage
          ? () => Column(
                children: [
                  ReorderListWidget(
                    isEditingMode: _isEditingMode,
                  ),
                  if (_isEditingMode)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: EventActionButton(
                        text: 'Add New Structures',
                        icon: LucideIcons.plus,
                        onTap: () {
                          if (_addItemsPageHasChanges()) {
                            _addStructureItems();
                          }
                          setState(() => isReorderPage = false);
                        },
                      ),
                    ),
                  const SizedBox(height: 42),
                ],
              )
          : () => const AddStructureItemsWidget(),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final hasEditRights = ref.watch(permissionServiceProvider).hasAccessToEdit;

    if (!hasEditRights) return const SizedBox();
    if (isReorderPage && _isEditingMode) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: ContinueButton(
          text: 'Save',
          onPressed: _reorderPageHasChanges() ? _changeOrder : () {},
          isEnabled: _reorderPageHasChanges(),
        ),
      );
    }
    if (!isReorderPage && _isEditingMode) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: ContinueButton(
          text: 'Add Selected',
          onPressed: _addItemsPageHasChanges() ? _saveNewItemsAdded : () {},
          isEnabled: _addItemsPageHasChanges(),
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildHeader(BuildContext context) {
    return ModalHeader(
      leadingButton:
          ref.watch(permissionServiceProvider).hasAccessToEdit && isReorderPage
              ? Container(
                  padding: const EdgeInsets.only(right: 28),
                  child: _buildLeadingTile(context),
                )
              : const SizedBox(width: 80 - 12),
      title: 'Edit Structure',
    );
  }

  Widget _buildLeadingTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: () {
          if (_isEditingMode) {
            if (_reorderPageHasChanges()) {
              _changeOrder();
            } else {
              setState(() {
                _isEditingMode = false;
              });
            }
          } else {
            setState(() {
              _isEditingMode = true;
            });
          }
        },
        overlayColor: WidgetStatePropertyAll(context.colorScheme.surfaceBright),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _isEditingMode
                ? context.colorScheme.primary
                : context.colorScheme.onSurfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: Icon(
              LucideIcons.pencil,
              key: ValueKey(_isEditingMode),
              size: 16,
              color:
                  _isEditingMode ? Colors.white : context.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  void _saveNewItemsAdded() {
    if (!isReorderPage) {
      if (_addItemsPageHasChanges()) {
        _addStructureItems();
      }
      setState(() => isReorderPage = true);
    }
  }

  bool _addItemsPageHasChanges() {
    return !isReorderPage &&
        ref
            .watch(addStructureControllerProvider)
            .structureItemsToAdd
            .isNotEmpty;
  }

  bool _reorderPageHasChanges() {
    return isReorderPage &&
        !listEquals(
          ref.watch(songPreferencesControllerProvider).structureItems,
          ref.watch(songNotifierProvider).song.structure,
        );
  }

  void _addStructureItems() {
    final strItemsToAdd =
        ref.watch(addStructureControllerProvider).structureItemsToAdd;

    ref
        .read(songPreferencesControllerProvider.notifier)
        .addStructureItemsToCurrent(strItemsToAdd);

    ref.read(addStructureControllerProvider.notifier).clearStructureItems();
  }

  void _changeOrder() {
    final songPrefsController = ref.watch(songPreferencesControllerProvider);
    final songNotifier = ref.read(songNotifierProvider.notifier);
    final reorderedStructure = songPrefsController.structureItems;
    songNotifier.updateStructureOnSong(reorderedStructure);
    setState(() {
      _isEditingMode = false;
    });
    if (widget.closeAfterSave) {
      context.popDialog();
    }
  }
}
