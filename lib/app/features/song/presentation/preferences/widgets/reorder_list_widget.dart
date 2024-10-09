import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/app_data/app_data_controller.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
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
  List<StructureItem> _structureItems = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _structureItems = List.of(
          ref.watch(songNotifierProvider).song.structure?.toList() ?? [],
        );
      });
    });
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
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _structureItems.length,
      itemBuilder: (context, index) {
        return ReordableListItem(
          canSlide: false,
          itemKey: '${_structureItems[index].shortName}_$index',
          itemId: _structureItems[index].index,
          color: _structureItems[index].color,
          shortName: _structureItems[index].shortName,
          name: _structureItems[index].name,
        );
      },
    );
  }

  Widget _buildReordableList() {
    return ReorderableListView.builder(
      onReorder: _onReorder,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _structureItems.length,
      proxyDecorator: (child, index, animation) => Material(
        color: Colors.transparent,
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        child: child,
      ),
      itemBuilder: (context, index) {
        return Container(
          key: ValueKey('${_structureItems[index].shortName}_$index'),
          child: ReordableListItem(
            itemKey: '${_structureItems[index].shortName}_$index',
            itemId: _structureItems[index].index,
            color: _structureItems[index].color,
            shortName: _structureItems[index].shortName,
            name: _structureItems[index].name,
          ),
        );
      },
    );
  }

  void _onReorder(int oldIndex, int index) {
    var newIndex = index;
    if (newIndex > oldIndex) {
      newIndex = newIndex - 1;
    }

    setState(() {
      final old = _structureItems.removeAt(oldIndex);
      _structureItems.insert(newIndex, old);
    });

    ref
        .read(songPreferencesControllerProvider.notifier)
        .addAllStructureItems(_structureItems);
  }
}
