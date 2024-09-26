import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/add_moments_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/add_songs_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/add_item_button_widget.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AddItemsToEventModal extends ConsumerStatefulWidget {
  const AddItemsToEventModal({
    super.key,
    required this.onItemsAdded,
  });

  final VoidCallback onItemsAdded;

  @override
  AddItemsToEventModalState createState() => AddItemsToEventModalState();

  static Future<void> show({
    required BuildContext context,
    required VoidCallback onItemsAdded,
  }) async {
    await showModalBottomSheet<Widget>(
      useRootNavigator: true,
      backgroundColor: context.colorScheme.surface,
      context: context,
      builder: (context) => NestedScrollModal(
        buildContent: () {
          return SingleChildScrollView(
            child: AddItemsToEventModal(onItemsAdded: onItemsAdded),
          );
        },
      ),
    );
  }
}

class AddItemsToEventModalState extends ConsumerState<AddItemsToEventModal> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultScreenPadding,
      child: Column(
        children: [
          AddItemButtonWidget(
            title: 'Add song',
            subtitle: 'Start adding your songs to your event',
            icon: Icons.music_note,
            iconColor: context.colorScheme.tertiary,
            backgroundColor: context.colorScheme.onSurfaceVariant,
            onPressed: () {
              context.popDialog();
              AddSongsModal.show(
                context: context,
                onSongsAdded: widget.onItemsAdded,
              );
            },
          ),
          const SizedBox(height: 10),
          AddItemButtonWidget(
            title: 'Add moment',
            subtitle: 'Prayers, announcements and others',
            icon: Icons.mic,
            iconColor: context.colorScheme.primary,
            backgroundColor: context.colorScheme.onSurfaceVariant,
            onPressed: () {
              context.popDialog();
              AddMomentsModal.show(
                context: context,
                onMomentsAdded: widget.onItemsAdded,
              );
            },
          ),
          const SizedBox(height: 10),
          AddItemButtonWidget(
            title: 'Copy Last Event',
            subtitle: 'Use the structure of your last event',
            icon: Icons.refresh,
            iconColor: context.colorScheme.primary,
            backgroundColor: context.colorScheme.onSurfaceVariant,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
