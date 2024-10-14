import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/app_data/app_data_controller.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/controller/song_preferences_controller.dart';
import 'package:on_stage_app/app/features/song/presentation/preferences/widgets/add__structure_items_widget.dart';
import 'package:on_stage_app/app/features/song/presentation/preferences/widgets/reorder_list_widget.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongStructureModal extends ConsumerStatefulWidget {
  const SongStructureModal({
    required this.onSave,
    super.key,
  });

  final void Function(bool isOrderPage) onSave;

  @override
  SongStructureModalState createState() => SongStructureModalState();

  static void show({
    required BuildContext context,
    required WidgetRef ref,
    required void Function(bool isOrderPage) onSave,
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
      builder: (context) => SongStructureModal(onSave: onSave),
    );
  }
}

class SongStructureModalState extends ConsumerState<SongStructureModal> {
  bool isOrderPage = true;

  @override
  void initState() {
    super.initState();
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
          isOrderPage ? ReorderListWidget.new : AddStructureItemsWidget.new,
    );
  }

  Widget _buildFooter(BuildContext context) {
    final isEdited = !listEquals(
      ref.watch(songPreferencesControllerProvider).structureItems,
      ref.watch(songNotifierProvider).song.structure,
    );
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          32,
        ),
        child: ref.watch(appDataControllerProvider).hasEditorsRight
            ? ContinueButton(
                text: isOrderPage ? 'Save' : 'Add',
                onPressed: () {
                  if (!isEdited) {
                    return;
                  }
                  widget.onSave(isOrderPage);
                  if (!isOrderPage) {
                    setState(() {
                      isOrderPage = true;
                    });
                  }
                },
                isEnabled: isEdited,
              )
            : const SizedBox(),
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
                  if (isOrderPage) {
                    ref
                        .read(songPreferencesControllerProvider.notifier)
                        .clearStructureItems();
                  }

                  setState(() {
                    isOrderPage = !isOrderPage;
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
    return isOrderPage
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
}
