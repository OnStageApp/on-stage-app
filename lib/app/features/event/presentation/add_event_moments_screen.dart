import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';
import 'package:on_stage_app/app/features/event/presentation/add_items_to_event_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/set_reminder_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/moment_event_item_tile.dart';
import 'package:on_stage_app/app/features/event_items/application/event_items_notifier.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/settings_trailing_app_bar_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';

class AddEventMomentsScreen extends ConsumerStatefulWidget {
  const AddEventMomentsScreen({
    required this.eventId,
    required this.isCreatingEvent,
    super.key,
  });

  final bool isCreatingEvent;
  final String eventId;

  @override
  AddEventMomentsScreenState createState() => AddEventMomentsScreenState();
}

class AddEventMomentsScreenState extends ConsumerState<AddEventMomentsScreen> {
  static const bool _isAdmin = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final eventItemsState = ref.watch(eventItemsNotifierProvider);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _isAdmin ? _buildSaveButton() : null,
      appBar: StageAppBar(
        isBackButtonVisible: true,
        title: 'Create Event',
        trailing: _isAdmin ? _buildSettingsButton() : null,
      ),
      body: Padding(
        padding: defaultScreenPadding,
        child: _isAdmin
            ? _buildReordableList(eventItemsState.eventItems)
            : _buildStaticList(eventItemsState.eventItems),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ContinueButton(
        text: 'Save',
        onPressed: _createEventItemList,
        isEnabled: true,
      ),
    );
  }

  Widget _buildSettingsButton() {
    return SettingsTrailingAppBarButton(
      onTap: () => SetReminderModal.show(context: context),
    );
  }

  void _createEventItemList() {
    final eventItems = ref.read(eventItemsNotifierProvider).eventItems;
    ref
        .read(eventItemsNotifierProvider.notifier)
        .addEventItems(eventItems, widget.eventId);

    if (widget.isCreatingEvent) {
      context.goNamed(
        AppRoute.eventDetails.name,
        queryParameters: {'eventId': widget.eventId},
      );
    } else {
      context.pop();
    }
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
      footer: _isAdmin
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
      onClone: isStatic
          ? null
          : () => ref
              .read(eventItemsNotifierProvider.notifier)
              .addEventItemCache(eventItem),
      onDelete: isStatic
          ? null
          : () => ref
              .read(eventItemsNotifierProvider.notifier)
              .removeEventItemCache(eventItem),
      isAdmin: _isAdmin,
    );
  }

  Widget _buildAddSongsOrMomentsButton() {
    return Column(
      children: [
        BlueActionButton(
          onTap: () => AddItemsToEventModal.show(context: context),
          text: 'Add Songs or Moments',
          icon: Icons.add,
        ),
        const SizedBox(height: 100)
      ],
    );
  }
}
