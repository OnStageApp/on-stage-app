import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/controller/event_controller.dart';
import 'package:on_stage_app/app/features/event/presentation/add_items_to_event_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/set_reminder_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/moment_event_item_tile.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/settings_trailing_app_bar_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';

class AddEventMomentsScreen extends ConsumerStatefulWidget {
  const AddEventMomentsScreen({super.key});

  @override
  AddEventSongsScreenState createState() => AddEventSongsScreenState();
}

class AddEventSongsScreenState extends ConsumerState<AddEventMomentsScreen> {
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventLocationController = TextEditingController();
  final _isAdmin = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12),
        child: _isAdmin ? _buildSaveButton(context) : null,
      ),
      appBar: StageAppBar(
        isBackButtonVisible: true,
        title: 'Create Event',
        trailing: _isAdmin
            ? SettingsTrailingAppBarButton(
                onTap: () {
                  SetReminderModal.show(context: context);
                },
              )
            : null,
      ),
      body: Padding(
        padding: defaultScreenPadding,
        child: _isAdmin ? _buildReordableList() : _buildStaticList(),
      ),
    );
  }

  ContinueButton _buildSaveButton(BuildContext context) {
    return ContinueButton(
      text: 'Save',
      onPressed: () {
        context.goNamed(
          AppRoute.eventDetails.name,
          queryParameters: {
            'eventId': '65d8a5138ae10c121bcc37d5',
          },
        );
      },
      isEnabled: true,
    );
  }

  Widget _buildStaticList() {
    return ListView.builder(
      itemCount: ref.watch(eventControllerProvider).eventItems.length,
      itemBuilder: (context, index) {
        final eventItem = ref.watch(eventControllerProvider).eventItems[index];

        return EventItemTile(
          isSong: eventItem.songId != null,
          key: ValueKey(eventItem.hashCode),
          name: eventItem.name ?? '',
          isAdmin: _isAdmin,
        );
      },
    );
  }

  Widget _buildReordableList() {
    return ReorderableListView.builder(
      proxyDecorator: (child, index, animation) => Material(
        color: Colors.transparent,
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.1),
        child: child,
      ),
      itemCount: ref.watch(eventControllerProvider).eventItems.length,
      onReorder: (oldIndex, newIndex) {
        _onReorder(newIndex, oldIndex);
      },
      itemBuilder: (context, index) {
        final eventItem = ref.watch(eventControllerProvider).eventItems[index];
        return EventItemTile(
          isSong: eventItem.songId != null,
          key: ValueKey(eventItem.hashCode),
          name: eventItem.name ?? '',
          onClone: () {
            ref.read(eventControllerProvider.notifier).addEventItem(eventItem);
          },
          onDelete: () {
            ref
                .read(eventControllerProvider.notifier)
                .removeEventItem(eventItem);
          },
          isAdmin: true,
        );
      },
      footer: _isAdmin ? _buildAddSongsOrMomentsButton() : const SizedBox(),
    );
  }

  void _onReorder(int newIndex, int oldIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    ref
        .read(eventControllerProvider.notifier)
        .reorderEventItems(oldIndex, newIndex);
  }

  Widget _buildAddSongsOrMomentsButton() {
    return BlueActionButton(
      onTap: () {
        AddItemsToEventModal.show(context: context);
      },
      text: 'Add Songs or Moments',
      icon: Icons.add,
    );
  }
}
