import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/app_data/app_data_controller.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/presentation/controller/song_preferences_controller.dart';
import 'package:on_stage_app/app/features/song/presentation/preferences/widgets/reordable_list_item.dart';

class ReorderListWidget extends ConsumerStatefulWidget {
  const ReorderListWidget({super.key});

  @override
  OrderStructureItemsWidgetState createState() =>
      OrderStructureItemsWidgetState();
}

class OrderStructureItemsWidgetState extends ConsumerState<ReorderListWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hasEditorsRight =
        ref.watch(appDataControllerProvider).hasEditorsRight;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          if (hasEditorsRight) _buildReordableList() else _buildList(),
          const SizedBox(height: 42),
        ],
      ),
    );
  }

  Widget _buildList() {
    final cacheStructureItems =
        ref.watch(songPreferencesControllerProvider).structureItems.toList();
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: cacheStructureItems.length,
      itemBuilder: (context, index) {
        return ReordableListItem(
          canSlide: false,
          itemKey: '${cacheStructureItems[index].shortName}_$index',
          itemId: cacheStructureItems[index].index,
          color: cacheStructureItems[index].color,
          shortName: cacheStructureItems[index].shortName,
          name: cacheStructureItems[index].name,
        );
      },
    );
  }

  Widget _buildReordableList() {
    final cacheStructureItems =
        ref.watch(songPreferencesControllerProvider).structureItems.toList();
    return ReorderableListView.builder(
      onReorder: _onReorder,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: cacheStructureItems.length,
      proxyDecorator: (child, index, animation) => Material(
        color: Colors.transparent,
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        child: child,
      ),
      itemBuilder: (context, index) {
        return Container(
          key: ValueKey('${cacheStructureItems[index].shortName}_$index'),
          child: ReordableListItem(
            itemKey: '${cacheStructureItems[index].shortName}_$index',
            itemId: cacheStructureItems[index].index,
            color: cacheStructureItems[index].color,
            shortName: cacheStructureItems[index].shortName,
            name: cacheStructureItems[index].name,
            onRemove: () {
              ref
                  .read(songPreferencesControllerProvider.notifier)
                  .removeStructureItem(cacheStructureItems[index]);
            },
            onClone: () {
              ref
                  .read(songPreferencesControllerProvider.notifier)
                  .addStructureItem(cacheStructureItems[index]);
            },
          ),
        );
      },
    );
  }

  void _onReorder(int oldIndex, int index) {
    final cacheStructureItems =
        ref.watch(songPreferencesControllerProvider).structureItems.toList();
    var newIndex = index;
    if (newIndex > oldIndex) {
      newIndex = newIndex - 1;
    }

    setState(() {
      final old = cacheStructureItems.removeAt(oldIndex);
      cacheStructureItems.insert(newIndex, old);
    });

    ref
        .read(songPreferencesControllerProvider.notifier)
        .addAllStructureItems(cacheStructureItems);
  }
}
