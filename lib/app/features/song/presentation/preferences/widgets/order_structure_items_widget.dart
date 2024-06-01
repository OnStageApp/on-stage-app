import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class OrderStructureItemsWidget extends ConsumerStatefulWidget {
  const OrderStructureItemsWidget({super.key});

  @override
  OrderStructureItemsWidgetState createState() =>
      OrderStructureItemsWidgetState();
}

class OrderStructureItemsWidgetState
    extends ConsumerState<OrderStructureItemsWidget> {
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
              borderRadius: BorderRadius.circular(8),
              child: child,
            ),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                key: ValueKey('${_sections[index].structure.id}_$index'),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Slidable(
                  endActionPane: ActionPane(
                    dragDismissible: false,
                    motion: const ScrollMotion(),
                    dismissible: DismissiblePane(onDismissed: () {}),
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Container(
                            height: double.infinity,
                            alignment: Alignment.center,
                            color: Colors.blue,
                            child: Text(
                              'Clone',
                              style: context.textTheme.bodyLarge!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Container(
                            height: double.infinity,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Delete',
                              style: context.textTheme.bodyLarge!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  child: Container(
                    height: 52,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
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
                          key: ValueKey(_sections[index].structure.id),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color:
                                  Color(_sections[index].structure.item.color),
                              width: 3,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            _sections[index].structure.item.shortName,
                            textAlign: TextAlign.center,
                            style: context.textTheme.titleSmall,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            _sections[index].structure.item.name,
                            style: context.textTheme.titleSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
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
