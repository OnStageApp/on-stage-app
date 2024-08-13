import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventItemTile extends StatefulWidget {
  const EventItemTile({
    required this.name,
    required this.isSong,
    required this.isAdmin,
    this.onClone,
    this.onDelete,
    super.key,
  });

  final String name;
  final bool isSong;
  final void Function()? onClone;
  final void Function()? onDelete;
  final bool isAdmin;

  @override
  _EventItemTileState createState() => _EventItemTileState();
}

class _EventItemTileState extends State<EventItemTile> {
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
        key: ValueKey(widget.name),
        endActionPane: widget.isAdmin ? _buildActionPane(context) : null,
        child: Builder(
          builder: (context) {
            final controller = Slidable.of(context);
            if (controller != null) {
              Slidable.of(context)!.actionPaneType.addListener(() {
                if (Slidable.of(context)!.actionPaneType.value ==
                    ActionPaneType.none) {
                  _setSliding(false);
                } else {
                  _setSliding(true);
                }
              });
            }
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: widget.isSong
                    ? context.colorScheme.onSurfaceVariant
                    : context.colorScheme.secondary,
                borderRadius: isSliding
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      )
                    : BorderRadius.circular(8),
                border: Border.all(
                  color: widget.isSong
                      ? context.colorScheme.onSurfaceVariant
                      : const Color(0xFF77A5F3),
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _buildIcon(),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: context.textTheme.titleMedium!.copyWith(
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                      if (widget.isSong)
                        Row(
                          children: [
                            Text(
                              'BBSO',
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: context.colorScheme.outline,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: context.colorScheme.surface,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'C# major',
                                style: context.textTheme.bodyMedium!.copyWith(
                                  color: context.colorScheme.outline,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Icon _buildIcon() {
    if (widget.isAdmin) {
      return const Icon(
        Icons.drag_indicator_rounded,
        color: Color(0xFF828282),
        size: 20,
      );
    } else if (widget.isSong) {
      return Icon(
        Icons.music_note_rounded,
        color: context.colorScheme.error,
        size: 20,
      );
    } else {
      return Icon(
        Icons.mic,
        color: context.colorScheme.primary,
        size: 20,
      );
    }
  }

  ActionPane _buildActionPane(BuildContext context) {
    return ActionPane(
      dragDismissible: false,
      motion: const ScrollMotion(),
      dismissible: DismissiblePane(onDismissed: () {}),
      children: [
        Expanded(
          child: InkWell(
            onTap: widget.onClone,
            child: Container(
              height: double.infinity,
              alignment: Alignment.center,
              color: Colors.blue,
              child: Text(
                'Clone',
                style:
                    context.textTheme.bodyLarge!.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: widget.onDelete,
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
                style:
                    context.textTheme.bodyLarge!.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
