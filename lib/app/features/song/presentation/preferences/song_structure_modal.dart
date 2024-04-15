import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/domain/models/structure/structure.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongStructureModal extends ConsumerStatefulWidget {
  const SongStructureModal({
    super.key,
  });

  @override
  SongStructureModalState createState() => SongStructureModalState();

  static void show({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF4F4F4),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      context: context,
      builder: (context) => SizedBox(
        child: NestedScrollModal(
          buildHeader: () => ModalHeader(
            title: 'Song Structure',
            onAddButtonPressed: () {
              context.popDialog();
            },
          ),
          buildFooter: () => SizedBox(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                32,
              ),
              child: ContinueButton(
                hasShadow: true,
                text: 'Save',
                onPressed: () {},
                isEnabled: true,
              ),
            ),
          ),
          headerHeight: () {
            return 64;
          },
          footerHeight: () {
            return 64;
          },
          buildContent: () {
            return const SongStructureModal();
          },
        ),
      ),
    );
  }
}

class SongStructureModalState extends ConsumerState<SongStructureModal> {
  List<Structure> _structures = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        final sections = ref.watch(songNotifierProvider).sections;
        _structures = sections.map((e) => e.structure).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultScreenPadding,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: _buildSongStructures(),
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      final item = _structures.removeAt(oldIndex);
      _structures.insert(newIndex, item);
    });
  }

  Widget _buildSongStructures() {
    return ReorderableListView.builder(
      onReorder: _onReorder,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _structures.length,
      proxyDecorator: (child, index, animation) => Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: child,
      ),
      itemBuilder: (context, index) {
        return Material(
          color: Colors.transparent,
          key: ValueKey(_structures[index].id),
          child: Slidable(
            endActionPane: ActionPane(
              dragDismissible: false,
              // A motion is a widget used to control how the pane animates.
              motion: const ScrollMotion(),

              // A pane can dismiss the Slidable.
              dismissible: DismissiblePane(onDismissed: () {}),

              // All actions are defined in the children parameter.
              children: [
                // A SlidableAction can have an icon and/or a label.
                SlidableAction(
                  spacing: 0,
                  padding: EdgeInsets.zero,
                  onPressed: (context) {},
                  backgroundColor: Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
                SlidableAction(
                  spacing: 0,
                  padding: EdgeInsets.zero,
                  onPressed: (context) {},
                  backgroundColor: Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.share,
                  label: 'Share',
                ),
              ],
            ),
            child: Container(
              height: 48,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  ReorderableDragStartListener(
                    index: index,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(
                        Icons.drag_indicator_rounded,
                        color: Color(0xFF828282),
                        size: 20,
                      ),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    key: ValueKey(_structures[index].id),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Color(_structures[index].item.color),
                        width: 3,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _structures[index].item.shortName,
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleSmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      _structures[index].item.name,
                      style: context.textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitForm() async {
    context.popDialog();
  }
}
