import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event_items/application/event_items_notifier.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/song_key.dart';
import 'package:on_stage_app/app/features/song/presentation/change_key_modal.dart';
import 'package:on_stage_app/app/features/song/presentation/song_preferences_modal.dart';
import 'package:on_stage_app/app/shared/settings_trailing_app_bar_button.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongAppBarLeading extends ConsumerWidget {
  const SongAppBarLeading({
    this.isFromEvent = false,
    this.eventItemId,
    super.key,
  });

  final bool isFromEvent;
  final String? eventItemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = ref.watch(songNotifierProvider).song.originalKey;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (key != null)
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              overlayColor: context.colorScheme.outline,
              backgroundColor: context.colorScheme.onSurfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              ChangeKeyModal.show(
                context: context,
                title: ref.watch(permissionServiceProvider).hasAccessToEdit
                    ? 'Change Key'
                    : 'Preview Key',
                songKey:
                    ref.watch(songNotifierProvider).song.key ?? const SongKey(),
                onKeyChanged: (key) async {
                  ref.read(songNotifierProvider.notifier).transpose(key);
                  if (ref.watch(permissionServiceProvider).hasAccessToEdit) {
                    if (isFromEvent) await _updateSongOnDB(context, ref, key);
                    return;
                  }
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                ref.watch(songNotifierProvider).song.key?.name ?? '',
                style: context.textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        const SizedBox(
          width: Insets.small,
        ),
        SettingsTrailingAppBarButton(
          onTap: () {
            SongPreferencesModal.show(
              context: context,
              tonality:
                  ref.watch(songNotifierProvider).song.key ?? const SongKey(),
              isFromEvent: isFromEvent,
            );
          },
        ),
      ],
    );
  }

  Future<void> _updateSongOnDB(
    BuildContext context,
    WidgetRef ref,
    SongKey songKey,
  ) async {
    final songNotifierState = ref.watch(songNotifierProvider);
    final songNotifier = ref.read(songNotifierProvider.notifier);
    final eventItemsNotifier = ref.read(eventItemsNotifierProvider.notifier);
    songNotifier.updateSongKey(songKey);
    await eventItemsNotifier.updateSongInEventItems(songNotifierState.song);
  }
}
