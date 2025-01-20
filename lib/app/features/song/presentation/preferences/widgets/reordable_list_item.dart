import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/shared/circle_structure_widget.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ReordableListItem extends StatefulWidget {
  const ReordableListItem({
    required this.structureItem,
    required this.itemKey,
    this.canSlide = true,
    this.onRemove,
    this.onClone,
    super.key,
  });

  final StructureItem structureItem;
  final String itemKey;
  final bool canSlide;
  final void Function()? onRemove;
  final void Function()? onClone;

  @override
  _ReordableListItemState createState() => _ReordableListItemState();
}

class _ReordableListItemState extends State<ReordableListItem>
    with SingleTickerProviderStateMixin {
  bool isSliding = false;
  late SlidableController _controller;

  @override
  void initState() {
    _controller = SlidableController(
      this,
    );
    super.initState();
  }

  void _setSliding(bool sliding) {
    setState(() {
      isSliding = sliding;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Slidable(
        groupTag: 'reordable_list_item',
        key: ValueKey(widget.itemKey),
        enabled: widget.canSlide,
        controller: _controller,
        endActionPane: ActionPane(
          dragDismissible: false,
          motion: const ScrollMotion(),
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  await _controller.close();
                  widget.onClone?.call();
                },
                child: Container(
                  height: double.infinity,
                  alignment: Alignment.center,
                  color: Colors.blue,
                  child: Text(
                    'Clone',
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  await _controller.close();
                  widget.onRemove?.call();
                },
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
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        child: Builder(
          builder: (context) {
            final controller = Slidable.of(context);
            if (controller != null) {
              controller.actionPaneType.addListener(() {
                if (controller.actionPaneType.value == ActionPaneType.none) {
                  _setSliding(false);
                } else {
                  _setSliding(true);
                }
              });
            }
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: 52,
              decoration: BoxDecoration(
                color: context.colorScheme.onSurfaceVariant,
                borderRadius: isSliding
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      )
                    : BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(
                      Icons.drag_indicator_rounded,
                      color: Color(0xFF828282),
                      size: 20,
                    ),
                  ),
                  StructureCircleWidget(
                    structureItem: widget.structureItem,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      widget.structureItem.name,
                      style: context.textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
