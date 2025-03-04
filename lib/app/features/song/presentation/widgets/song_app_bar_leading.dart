import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:on_stage_app/app/features/event_items/application/event_items_notifier.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/song_key.dart';
import 'package:on_stage_app/app/features/song/presentation/change_key_modal.dart';
import 'package:on_stage_app/app/features/song/presentation/song_preferences_modal.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/settings_trailing_app_bar_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongAppBarLeading extends ConsumerWidget {
  const SongAppBarLeading({
    required this.songId,
    this.isFromEvent = false,
    this.hasAttachments = false,
    this.eventItemId,
    super.key,
  });

  final String songId;
  final bool isFromEvent;
  final String? eventItemId;
  final bool hasAttachments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = ref.watch(songNotifierProvider(songId)).song.originalKey;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (key != null)
          IconButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              visualDensity: VisualDensity.compact,
              overlayColor: context.colorScheme.outline,
              backgroundColor: context.colorScheme.onSurfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              ChangeKeyModal.show(
                songId: songId,
                context: context,
                isFrom: isFromEvent
                    ? TransposerOpenFrom.eventsScreen
                    : TransposerOpenFrom.songsScreen,
                songKey: ref.watch(songNotifierProvider(songId)).song.key ??
                    const SongKey(),
                onKeyChanged: (key) async {
                  ref
                      .read(songNotifierProvider(songId).notifier)
                      .transpose(key);
                  if (ref.watch(permissionServiceProvider).hasAccessToEdit) {
                    if (isFromEvent) await _updateSongOnDB(context, ref, key);
                    return;
                  }
                },
              );
            },
            icon: Text(
              ref.watch(songNotifierProvider(songId)).song.key?.name ?? '',
              style: context.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          ),
        const SizedBox(
          width: 4,
        ),
        if (hasAttachments) ...[
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            color: context.colorScheme.onSurface,
            iconSize: 16,
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              backgroundColor:
                  WidgetStateProperty.all(context.colorScheme.onSurfaceVariant),
            ),
            icon: const Icon(LucideIcons.paperclip),
            onPressed: () {
              context.pushNamed(
                AppRoute.songFiles.name,
                queryParameters: {
                  'songId': songId,
                },
              );
            },
          ),
        ],
        SettingsTrailingAppBarButton(
          onTap: () {
            SongPreferencesModal.show(
              songId: songId,
              context: context,
              tonality: ref.watch(songNotifierProvider(songId)).song.key ??
                  const SongKey(),
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
    final songNotifierState = ref.watch(songNotifierProvider(songId));
    final songNotifier = ref.read(songNotifierProvider(songId).notifier);
    final eventItemsNotifier = ref.read(eventItemsNotifierProvider.notifier);
    songNotifier.updateSongKey(songKey);
    await eventItemsNotifier.updateSongInEventItems(songNotifierState.song);
  }
}
