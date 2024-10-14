import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/app_data/app_data_controller.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/controller/add_structure_controller.dart';
import 'package:on_stage_app/app/features/song/presentation/controller/song_preferences_controller.dart';
import 'package:on_stage_app/app/features/song/presentation/preferences/widgets/add__structure_items_widget.dart';
import 'package:on_stage_app/app/features/song/presentation/preferences/widgets/reorder_list_widget.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongStructureModal extends ConsumerStatefulWidget {
  const SongStructureModal({
    super.key,
  });

  @override
  SongStructureModalState createState() => SongStructureModalState();

  static void show({
    required BuildContext context,
    required WidgetRef ref,
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
      builder: (context) => const SongStructureModal(),
    );
  }
}

class SongStructureModalState extends ConsumerState<SongStructureModal> {
  bool isReorderPage = true;

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
      buildContent:
          isReorderPage ? ReorderListWidget.new : AddStructureItemsWidget.new,
    );
  }

  Widget _buildFooter(BuildContext context) {
    final hasEditRights = ref.watch(appDataControllerProvider).hasEditorsRight;
    final hasChanges = _hasChanges();
    final buttonText = isReorderPage ? 'Save' : 'Add';

    if (!hasEditRights) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: ContinueButton(
        text: buttonText,
        onPressed: hasChanges ? _handleButtonPress : () {},
        isEnabled: hasChanges,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ModalHeader(
      leadingButton: ref.watch(appDataControllerProvider).hasEditorsRight
          ? SizedBox(
              width: 80 - 12,
              child: InkWell(
                onTap: () {
                  setState(() {
                    isReorderPage = !isReorderPage;
                  });
                },
                child: _buildLeadingTile(context),
              ),
            )
          : const SizedBox(width: 80 - 12),
      title: 'Song Structure',
    );
  }

  Widget _buildLeadingTile(BuildContext context) {
    return isReorderPage
        ? SizedBox(
            child: Row(
              children: [
                const Icon(Icons.add, color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  'Add',
                  style: context.textTheme.titleMedium!
                      .copyWith(color: Colors.blue),
                ),
              ],
            ),
          )
        : Text(
            'Back',
            style: context.textTheme.titleMedium!.copyWith(
              color: const Color(0xFF828282),
            ),
          );
  }

  void _handleButtonPress() {
    if (isReorderPage) {
      _changeOrder();
    } else {
      _addStructureItems();
      setState(() => isReorderPage = true);
    }
  }

  bool _hasChanges() {
    if (isReorderPage) {
      return !listEquals(
        ref.watch(songPreferencesControllerProvider).structureItems,
        ref.watch(songNotifierProvider).song.structure,
      );
    } else {
      return ref
          .watch(addStructureControllerProvider)
          .structureItemsToAdd
          .isNotEmpty;
    }
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

    context.popDialog();
  }
}
