import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_stage_app/app/features/event/presentation/add_items_to_event_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/schedule_settings_buttons.dart';
import 'package:on_stage_app/app/features/event_items/application/event_items_notifier.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item.dart';
import 'package:on_stage_app/app/features/event_items/presentation/event_item_tile.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:shimmer/shimmer.dart';

final evTemplatesHasChangesProvider =
    StateProvider.autoDispose<bool>((ref) => false);

final evTemplatesIsEditModeProvider =
    StateProvider.autoDispose<bool>((ref) => false);

final isEditModeAndHasAccessProvider = Provider.autoDispose<bool>((ref) {
  final hasAccessToEdit = ref.watch(permissionServiceProvider).hasAccessToEdit;
  final isEditMode = ref.watch(evTemplatesIsEditModeProvider);
  return hasAccessToEdit && isEditMode;
});

class EventTemplateScheduleScreen extends ConsumerStatefulWidget {
  const EventTemplateScheduleScreen({
    required this.eventTemplateId,
    this.onSave,
    super.key,
  });

  final String eventTemplateId;
  final void Function()? onSave;

  @override
  EventTemplateScheduleScreenState createState() =>
      EventTemplateScheduleScreenState();
}

class EventTemplateScheduleScreenState
    extends ConsumerState<EventTemplateScheduleScreen> {
  bool _areEventItemsTemplateLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestEventItems();
    });
    super.initState();
  }

  Future<void> _requestEventItems() async {
    setState(() {
      _areEventItemsTemplateLoading = true;
    });
    await ref
        .read(eventItemsNotifierProvider.notifier)
        .getEventItems(widget.eventId);

    setState(() {
      _areEventItemsTemplateLoading = false;
    });
  }

  void _saveChanges() {
    ref.read(evTemplatesIsEditModeProvider.notifier).update((state) => !state);
    if (ref.watch(evTemplatesHasChangesProvider) &&
        !ref.watch(evTemplatesIsEditModeProvider)) {
      _saveReorder();
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventItemsState = ref.watch(eventItemsNotifierProvider);
    final canEdit = ref.watch(isEditModeAndHasAccessProvider);

    return Scaffold(
      appBar: const StageAppBar(
        title: 'Schedule',
        isBackButtonVisible: true,
        // trailing: ScheduleSettingsButtons(
        //   onPlayTap: _goToEventItemsPageView,
        //   onEditTap: _saveChanges,
        //   isEditMode: canEdit,
        // ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: canEdit ? _buildSaveButton() : null,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      body: SlidableAutoCloseBehavior(
        child: RefreshIndicator.adaptive(
          onRefresh: _requestEventItems,
          child: Padding(
            padding: defaultScreenPadding,
            child: _areEventItemsTemplateLoading
                ? _buildShimmerList()
                : canEdit
                    ? _buildReordableList(eventItemsState.eventItems)
                    : eventItemsState.eventItems.isNotEmpty
                        ? _buildStaticList(eventItemsState.eventItems)
                        : const Center(
                            child: Text('No items added yet'),
                          ),
          ),
        ),
      ),
    );
  }

  // void _goToEventItemsPageView() {
  //   context.pushNamed(
  //     AppRoute.eventItemsWithPages.name,
  //     queryParameters: {
  //       'eventId': widget.eventId,
  //       'fetchEventItems': 'false',
  //     },
  //   );
  // }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Shimmer.fromColors(
          baseColor: context.colorScheme.onSurfaceVariant.withOpacity(0.3),
          highlightColor: context.colorScheme.onSurfaceVariant,
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: context.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    final hasChanges = ref.watch(evTemplatesHasChangesProvider);
    if (!hasChanges) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ContinueButton(
        text: 'Save Order',
        onPressed: hasChanges ? _saveChanges : () {},
        isEnabled: hasChanges,
      ),
    );
  }

  void _saveReorder() {
    final eventItems = ref.read(eventItemsNotifierProvider).eventItems;
    ref
        .read(eventItemsNotifierProvider.notifier)
        .updateEventItemsIndexes(eventItems);

    widget.onSave?.call();
    ref.read(evTemplatesHasChangesProvider.notifier).state = false;
  }

  Widget _buildStaticList(List<EventItem> eventItems) {
    return ListView.builder(
      itemCount: eventItems.length,
      itemBuilder: (context, index) =>
          _buildEventItemTile(eventItems[index], isStatic: true),
    );
  }

  Widget _buildReordableList(List<EventItem> eventItems) {
    final canEdit = ref.watch(isEditModeAndHasAccessProvider);
    return SlidableAutoCloseBehavior(
      child: ReorderableListView.builder(
        proxyDecorator: _proxyDecorator,
        itemCount: eventItems.length,
        onReorder: _onReorder,
        itemBuilder: (context, index) => _buildEventItemTile(eventItems[index]),
        footer: canEdit
            ? _buildAddSongsOrMomentsButton()
            : const SizedBox(height: 100),
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
            color: context.colorScheme.surface.withAlpha(10),
            elevation: 6,
            shadowColor: Colors.black.withAlpha(10),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    ref
        .read(eventItemsNotifierProvider.notifier)
        .changeOrderCache(oldIndex, newIndex);
    ref.read(evTemplatesHasChangesProvider.notifier).state = true;
  }

  Widget _buildEventItemTile(EventItem eventItem, {bool isStatic = false}) {
    final hasChanges = ref.watch(evTemplatesHasChangesProvider);
    return EventItemTile(
      key: ValueKey(eventItem.hashCode),
      eventItem: eventItem,
      artist: eventItem.song?.artist?.name ?? '',
      songKey: eventItem.song?.key?.name ?? '',
      tempo: eventItem.song?.tempo.toString() ?? '',
      onDelete: isStatic
          ? null
          : () {
              ref
                  .read(eventItemsNotifierProvider.notifier)
                  .deleteEventItem(eventItem.id);
            },
      onTap: hasChanges
          ? null
          : () {
              final eventItems =
                  ref.read(eventItemsNotifierProvider).eventItems;
              ref
                  .read(eventItemsNotifierProvider.notifier)
                  .setCurrentIndex(eventItems.indexOf(eventItem));

              _goToEventItemsPageView();
            },
      isEditor: ref.watch(isEditModeAndHasAccessProvider),
    );
  }

  Widget _buildAddSongsOrMomentsButton() {
    return Column(
      children: [
        EventActionButton(
          onTap: () => AddItemsToEventModal.show(
            context: context,
            onItemsAdded: () =>
                ref.read(evTemplatesHasChangesProvider.notifier).state = true,
          ),
          text: 'Add Songs or Moments',
          icon: Icons.add,
        ),
        const SizedBox(height: 160),
      ],
    );
  }
}
