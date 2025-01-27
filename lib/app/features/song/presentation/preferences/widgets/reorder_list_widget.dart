import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/presentation/controller/structure_list_controller.dart';
import 'package:on_stage_app/app/features/song/presentation/preferences/widgets/reordable_list_item.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ReorderListWidget extends ConsumerStatefulWidget {
  final bool isEditingMode;

  const ReorderListWidget({
    required this.isEditingMode,
    super.key,
  });

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
        ref.watch(permissionServiceProvider).hasAccessToEdit;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          if (hasEditorsRight && widget.isEditingMode)
            _buildReorderableList()
          else
            _buildList(),
        ],
      ),
    );
  }

  Widget _buildList() {
    final state = ref.watch(structureListControllerProvider);

    return SlidableAutoCloseBehavior(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: state.groupedItems.length,
        itemBuilder: (context, index) {
          final group = state.groupedItems[index];
          return ReordableListItem(
            isEditingMode: false,
            multiplier: group.multiplier,
            groupIndex: group.originalIndex,
            structureItem: group.item,
            canSlide: false,
            itemKey: '${group.item.shortName}_$index',
          );
        },
      ),
    );
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final animValue = Curves.easeIn.transform(animation.value);
        final scale = lerpDouble(1, 1.02, animValue)!;
        return Transform.scale(
          scale: scale,
          child: Card(
            color: context.colorScheme.surface.withOpacity(0.2),
            elevation: 6,
            shadowColor: Colors.black.withOpacity(0.2),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildReorderableList() {
    final state = ref.watch(structureListControllerProvider);
    final controller = ref.read(structureListControllerProvider.notifier);

    return SlidableAutoCloseBehavior(
      child: ReorderableListView.builder(
        buildDefaultDragHandles: false,
        onReorder: controller.reorderGroup,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: state.groupedItems.length,
        proxyDecorator: _proxyDecorator,
        itemBuilder: (context, index) {
          final group = state.groupedItems[index];
          return MyDragStartListener(
            key: ValueKey('${group.item.shortName}_$index'),
            index: index,
            child: ClipRect(
              child: ReordableListItem(
                structureItem: group.item,
                groupIndex: index,
                multiplier: group.multiplier,
                itemKey: '${group.item.shortName}_$index',
                onRemove: () => controller.removeGroup(index),
                onClone: null,
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyDragStartListener extends ReorderableDelayedDragStartListener {
  const MyDragStartListener({
    required super.child,
    required super.index,
    super.key,
    super.enabled,
  });

  @override
  MultiDragGestureRecognizer createRecognizer() {
    return DelayedMultiDragGestureRecognizer(
      delay: const Duration(milliseconds: 250),
      debugOwner: this,
    );
  }
}
