import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/app_data/app_data_controller.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';
import 'package:on_stage_app/app/features/event/presentation/add_items_to_event_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/moment_event_item_tile.dart';
import 'package:on_stage_app/app/features/event_items/application/event_items_notifier.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';

class AddEventMomentsScreen extends ConsumerStatefulWidget {
  const AddEventMomentsScreen({
    required this.eventId,
    required this.isCreatingEvent,
    this.onSave,
    super.key,
  });

  final bool isCreatingEvent;
  final String eventId;
  final void Function()? onSave;

  @override
  AddEventMomentsScreenState createState() => AddEventMomentsScreenState();
}

class AddEventMomentsScreenState extends ConsumerState<AddEventMomentsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(eventItemsNotifierProvider.notifier)
          .getEventItems(widget.eventId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final eventItemsState = ref.watch(eventItemsNotifierProvider);
    final hasEditorRights =
        ref.watch(appDataControllerProvider).hasEditorsRight;

    return Scaffold(
      appBar: StageAppBar(
        title: widget.isCreatingEvent ? 'Create Event' : 'Event Structure',
        isBackButtonVisible: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: hasEditorRights ? _buildSaveButton() : null,
      body: Padding(
        padding: defaultScreenPadding,
        child: hasEditorRights
            ? _buildReordableList(eventItemsState.eventItems)
            : _buildStaticList(eventItemsState.eventItems),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ContinueButton(
        text: 'Save Changes',
        onPressed: _createEventItemList,
        isEnabled: ref.watch(eventItemsNotifierProvider).hasChanges,
      ),
    );
  }

  void _createEventItemList() {
    final eventItems = ref.watch(eventItemsNotifierProvider).eventItems;
    ref.read(eventItemsNotifierProvider.notifier).resetChanges();
    ref
        .read(eventItemsNotifierProvider.notifier)
        .addEventItems(eventItems, widget.eventId);

    if (widget.isCreatingEvent) {
      context.goNamed(
        AppRoute.eventDetails.name,
        queryParameters: {'eventId': widget.eventId},
      );
    } else {}
    widget.onSave?.call();
  }

  Widget _buildStaticList(List<EventItem> eventItems) {
    return ListView.builder(
      itemCount: eventItems.length,
      itemBuilder: (context, index) =>
          _buildEventItemTile(eventItems[index], isStatic: true),
    );
  }

  Widget _buildReordableList(List<EventItem> eventItems) {
    return ReorderableListView.builder(
      proxyDecorator: _proxyDecorator,
      itemCount: eventItems.length,
      onReorder: _onReorder,
      itemBuilder: (context, index) => _buildEventItemTile(eventItems[index]),
      footer: ref.watch(appDataControllerProvider).hasEditorsRight
          ? _buildAddSongsOrMomentsButton()
          : const SizedBox(height: 100),
    );
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return Material(
      color: Colors.transparent,
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.1),
      child: child,
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    ref
        .read(eventItemsNotifierProvider.notifier)
        .changeOrderCache(oldIndex, newIndex);
  }

  Widget _buildEventItemTile(EventItem eventItem, {bool isStatic = false}) {
    return EventItemTile(
      key: ValueKey(eventItem.hashCode),
      isSong: eventItem.song?.id != null,
      name: eventItem.name ?? '',
      onDelete: isStatic
          ? null
          : () => ref
              .read(eventItemsNotifierProvider.notifier)
              .removeEventItemCache(eventItem),
      onTap: () {
        if (eventItem.song == null) {
          return;
        }
        final eventItems = ref.watch(eventItemsNotifierProvider).songEventItems;

        final queryParams = {
          'currentIndex': eventItems.indexOf(eventItem).toString(),
        };

        context.pushNamed(
          AppRoute.song.name,
          queryParameters: queryParams,
          extra: eventItems,
        );
      },
      isAdmin: ref.watch(appDataControllerProvider).hasEditorsRight,
    );
  }

  Widget _buildAddSongsOrMomentsButton() {
    return Column(
      children: [
        EventActionButton(
          onTap: () => AddItemsToEventModal.show(context: context),
          text: 'Add Songs or Moments',
          icon: Icons.add,
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}
