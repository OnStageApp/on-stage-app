import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/presentation/preferences/widgets/reordable_list_item.dart';

class ReorderListWidget extends ConsumerStatefulWidget {
  const ReorderListWidget({super.key});

  @override
  OrderStructureItemsWidgetState createState() =>
      OrderStructureItemsWidgetState();
}

class OrderStructureItemsWidgetState extends ConsumerState<ReorderListWidget> {
  List<Section> _sections = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _sections = ref.watch(songNotifierProvider).sections;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          ReorderableListView.builder(
            onReorder: _onReorder,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _sections.length,
            proxyDecorator: (child, index, animation) => Material(
              color: Colors.transparent,
              elevation: 6,
              shadowColor: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              child: child,
            ),
            itemBuilder: (context, index) {
              return Container(
                key: ValueKey('${_sections[index].structure.id}_$index'),
                child: ReordableListItem(
                  itemKey: '${_sections[index].structure.id}_$index',
                  itemId: _sections[index].structure.id,
                  color: _sections[index].structure.item.color,
                  shortName: _sections[index].structure.item.shortName,
                  name: _sections[index].structure.item.name,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _onReorder(int oldIndex, int index) {
    var newIndex = index;
    if (newIndex > oldIndex) {
      newIndex = newIndex - 1;
    }

    setState(() {
      _sections.insert(newIndex, _sections.removeAt(oldIndex));
    });

    ref.read(songNotifierProvider.notifier).updateSongSections(_sections);
  }
}
