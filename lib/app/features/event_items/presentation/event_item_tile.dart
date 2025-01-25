import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_overview.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/assigned_persons.dart';
import 'package:on_stage_app/app/features/event_items/application/event_items_notifier.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item.dart';
import 'package:on_stage_app/app/features/event_items/presentation/widget/event_item_time.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/list_utils.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';

class EventItemTile extends ConsumerStatefulWidget {
  const EventItemTile({
    required this.eventItem,
    required this.artist,
    required this.songKey,
    required this.tempo,
    required this.isEditor,
    this.onTap,
    this.onDelete,
    super.key,
  });

  final EventItem eventItem;
  final String artist;
  final String songKey;
  final String tempo;
  final void Function()? onTap;
  final void Function()? onDelete;
  final bool isEditor;

  @override
  EventItemTileState createState() => EventItemTileState();
}

class EventItemTileState extends ConsumerState<EventItemTile> {
  bool isSliding = false;

  void _setSliding(bool sliding) {
    setState(() {
      isSliding = sliding;
    });
  }

  bool get isSong => widget.eventItem.song?.id != null;

  Duration _getCumulatedDuration(int? index) {
    if (index == null) return Duration.zero;

    final eventItems = ref.watch(eventItemsNotifierProvider).eventItems;
    if (eventItems.isEmpty) return Duration.zero;

    final currentItemIndex =
        eventItems.indexWhere((item) => item.id == widget.eventItem.id);
    if (currentItemIndex == -1) return Duration.zero;

    return eventItems.take(currentItemIndex).fold<Duration>(
          Duration.zero,
          (previousValue, element) =>
              previousValue + (element.duration ?? Duration.zero),
        );
  }

  @override
  Widget build(BuildContext context) {
    final eventStartDate = ref.watch(eventNotifierProvider).event?.dateTime;
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(8),
      highlightColor: Theme.of(context).colorScheme.surfaceBright,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Slidable(
          key: ValueKey(widget.eventItem.name),
          endActionPane: widget.isEditor ? _buildActionPane(context) : null,
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
                  color: widget.eventItem.song?.id != null
                      ? context.colorScheme.onSurfaceVariant
                      : context.colorScheme.tertiary,
                  borderRadius: isSliding
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        )
                      : BorderRadius.circular(8),
                  border: Border.all(
                    color: isSong
                        ? context.colorScheme.onSurfaceVariant
                        : context.colorScheme.tertiary,
                  ),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: _buildIcon(),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSongDetails2(context),
                            Text(
                              widget.eventItem.name ?? '',
                              style: context.textTheme.titleMedium!.copyWith(
                                color: context.colorScheme.onSurface,
                              ),
                            ),
                            if (!isSong &&
                                widget.eventItem.description
                                    .isNotNullEmptyOrWhitespace) ...[
                              _buildDescription(context),
                            ],
                            if (isSong) ...[
                              // _buildSongArtist(context),
                            ],
                            if (widget.eventItem.assignedTo.isNotNullOrEmpty)
                              AssignedPersons(
                                isSong: isSong,
                                stagers: widget.eventItem.assignedTo!
                                    .map(
                                      (e) => StagerOverview(
                                        id: e.id,
                                        name: e.name,
                                        profilePicture: e.profilePicture,
                                        userId: e.userId,
                                      ),
                                    )
                                    .toList(),
                              ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          EventItemTime(
                            canEdit: widget.isEditor,
                            eventStartDate: eventStartDate,
                            cumulatedDuration:
                                _getCumulatedDuration(widget.eventItem.index),
                            onDurationChanged: _updateDurationOnEventItem,
                            currentDuration: widget.eventItem.duration,
                          ),
                        ],
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

  Future<void> _updateDurationOnEventItem(Duration? duration) async {
    if (duration != null) {
      final updatedEventItem = widget.eventItem.copyWith(
        duration: duration,
      );
      await ref
          .read(eventItemsNotifierProvider.notifier)
          .updateMomentItem(updatedEventItem);
    }
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      widget.eventItem.description ?? '',
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: context.textTheme.bodyMedium!
          .copyWith(color: context.colorScheme.outline),
    );
  }

  Widget _buildSongDetails2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 1,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: context.colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${widget.songKey} | ${widget.tempo} BPM',
              style: context.textTheme.bodyMedium!.copyWith(
                color: context.colorScheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongArtist(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            widget.artist,
            style: context.textTheme.bodyMedium!.copyWith(
              color: context.colorScheme.outline,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Icon _buildIcon() {
    if (widget.isEditor) {
      return const Icon(
        Icons.drag_indicator_rounded,
        color: Color(0xFF828282),
        size: 20,
      );
    } else if (isSong) {
      return Icon(
        Icons.music_note,
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
