import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/add_songs_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/add_item_button_widget.dart';
import 'package:on_stage_app/app/features/event_items/presentation/add_edit_moment_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/adaptive_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AddItemsToEventModal extends ConsumerStatefulWidget {
  const AddItemsToEventModal({
    required this.onItemsAdded,
    super.key,
  });

  final VoidCallback onItemsAdded;

  @override
  AddItemsToEventModalState createState() => AddItemsToEventModalState();

  static Future<void> show({
    required BuildContext context,
    required VoidCallback onItemsAdded,
  }) async {
    await AdaptiveModal.show(
      context: context,
      isFloatingForLargeScreens: true,
      expand: false,
      child: AddItemsToEventModal(onItemsAdded: onItemsAdded),
    );
  }
}

class AddItemsToEventModalState extends ConsumerState<AddItemsToEventModal> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        color: context.colorScheme.surface,
        padding: defaultScreenPadding.copyWith(bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AddItemButtonWidget(
              title: 'Add songs',
              subtitle: 'Start adding your songs to your event',
              icon: Icons.music_note,
              iconColor: Colors.green,
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
                AddEditMomentModal.show(
                  context: context,
                  // onMomentAdded: widget.onItemsAdded,
                );
              },
            ),
            const SizedBox(height: 20),
            AddItemButtonWidget(
              title: 'Copy Last Event',
              subtitle: 'Use the structure of your last event',
              icon: Icons.refresh,
              iconColor: context.colorScheme.outline,
              backgroundColor: context.colorScheme.onSurfaceVariant,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
