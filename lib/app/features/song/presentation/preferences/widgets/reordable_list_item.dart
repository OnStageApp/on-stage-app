import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ReordableListItem extends StatefulWidget {
  const ReordableListItem({
    required this.itemKey,
    required this.itemId,
    required this.color,
    required this.shortName,
    required this.name,
    this.canSlide = true,
    super.key,
  });

  final String itemKey;
  final int itemId;
  final int color;
  final String shortName;
  final String name;
  final bool canSlide;

  @override
  _ReordableListItemState createState() => _ReordableListItemState();
}

class _ReordableListItemState extends State<ReordableListItem> {
  bool isSliding = false;

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
        enabled: widget.canSlide,
        key: ValueKey(widget.itemKey),
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
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
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
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
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
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    key: ValueKey(widget.itemId),
                    decoration: BoxDecoration(
                      color: context.colorScheme.onSurfaceVariant,
                      border: Border.all(
                        color: Color(widget.color),
                        width: 3,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      widget.shortName,
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleSmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      widget.name,
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
