import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';

class RehearsalTile extends StatefulWidget {
  const RehearsalTile({
    required this.title,
    required this.dateTime,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  final String title;
  final DateTime? dateTime;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  _RehearsalTileState createState() => _RehearsalTileState();
}

class _RehearsalTileState extends State<RehearsalTile> {
  bool isSliding = false;

  void _setSliding(bool sliding) {
    setState(() {
      isSliding = sliding;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Slidable(
        key: ValueKey(widget.dateTime),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.3,
          dismissible: DismissiblePane(onDismissed: widget.onDelete),
          children: [
            SlidableAction(
              onPressed: (_) => widget.onDelete(),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              label: 'Delete',
              borderRadius: BorderRadius.circular(8),
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
            return TextButton(
              onPressed: widget.onTap,
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                backgroundColor: context.colorScheme.onSurfaceVariant,
                overlayColor: context.colorScheme.outline.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: isSliding
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        )
                      : BorderRadius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 1,
                        ),
                        Row(
                          children: [
                            Text(
                              TimeUtils().formatOnlyTime(widget.dateTime),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: context.colorScheme.surfaceDim,
                                  ),
                            ),
                            _buildCircle(context),
                            Text(
                              widget.dateTime != null
                                  ? TimeUtils().formatOnlyDate(widget.dateTime)
                                  : '',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: context.colorScheme.surfaceDim,
                                  ),
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildCircle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Icon(
        Icons.circle,
        size: 8,
        color: context.colorScheme.outline.withOpacity(0.2),
      ),
    );
  }
}
