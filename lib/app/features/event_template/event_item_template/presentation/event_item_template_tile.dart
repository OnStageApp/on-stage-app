import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_stage_app/app/features/event_template/event_item_template/domain/event_item_template.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';

class EventItemTemplateTile extends ConsumerStatefulWidget {
  const EventItemTemplateTile({
    required this.eventItemTemplate,
    this.onTap,
    this.onDelete,
    super.key,
  });

  final EventItemTemplate eventItemTemplate;

  final void Function()? onTap;
  final void Function()? onDelete;

  @override
  EventItemTemplateTileState createState() => EventItemTemplateTileState();
}

class EventItemTemplateTileState extends ConsumerState<EventItemTemplateTile> {
  bool isSliding = false;

  void _setSliding(bool sliding) {
    setState(() {
      isSliding = sliding;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(8),
      highlightColor: Theme.of(context).colorScheme.surfaceBright,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Slidable(
          key: ValueKey(widget.eventItemTemplate.name),
          endActionPane: _buildActionPane(context),
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.colorScheme.tertiary,
                  borderRadius: isSliding
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        )
                      : BorderRadius.circular(8),
                  border: Border.all(
                    color: context.colorScheme.tertiary,
                  ),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              widget.eventItemTemplate.name ?? '',
                              style: context.textTheme.titleMedium!.copyWith(
                                color: context.colorScheme.onSurface,
                              ),
                            ),
                            if (widget.eventItemTemplate.description
                                .isNotNullEmptyOrWhitespace) ...[
                              _buildDescription(context),
                            ],
                          ],
                        ),
                      ),
                      Center(
                        child: _buildIcon(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      widget.eventItemTemplate.description ?? '',
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: context.textTheme.bodyMedium!
          .copyWith(color: context.colorScheme.outline),
    );
  }

  Widget _buildIcon() {
    return const Icon(
      Icons.drag_indicator_rounded,
      color: Color(0xFF828282),
      size: 24,
    );
  }

  ActionPane _buildActionPane(BuildContext context) {
    return ActionPane(
      extentRatio: 0.3,
      dragDismissible: false,
      motion: const ScrollMotion(),
      dismissible: DismissiblePane(onDismissed: () {}),
      children: [
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
