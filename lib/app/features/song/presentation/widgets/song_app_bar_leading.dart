import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/song_key.dart';
import 'package:on_stage_app/app/features/song/presentation/change_key_modal.dart';
import 'package:on_stage_app/app/features/song/presentation/song_preferences_modal.dart';
import 'package:on_stage_app/app/features/song_configuration/application/song_config_notifier.dart';
import 'package:on_stage_app/app/features/song_configuration/domain/song_config_request/song_config_request.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
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
                songKey: ref.watch(songNotifierProvider).song.key!,
                onKeyChanged: (key) async {
                  ref.read(songNotifierProvider.notifier).transpose(key);
                  if (isFromEvent) await _updateSongOnDB(ref, key);
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
              tonality: ref.watch(songNotifierProvider).song.key!,
              isFromEvent: isFromEvent,
            );
          },
        ),
      ],
    );
  }

  Future<void> _updateSongOnDB(WidgetRef ref, SongKey songKey) async {
    final songId = ref.read(songNotifierProvider).song.id;
    final teamId = ref.read(teamNotifierProvider).currentTeam?.id;
    await ref
        .read(songConfigurationNotifierProvider.notifier)
        .updateSongConfiguration(
          SongConfigRequest(
            songId: songId,
            teamId: teamId,
            isCustom: true,
            key: songKey,
          ),
        );
    unawaited(ref.read(songNotifierProvider.notifier).init(songId!));
  }
}
