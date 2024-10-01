import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
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
    final key = ref.watch(songNotifierProvider).song.key;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (key != null && key.isNotEmpty)
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
                songKey: ref.watch(songNotifierProvider).song.songKey,
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                ref.watch(songNotifierProvider).song.key ?? '',
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
              tonality: ref.watch(songNotifierProvider).song.songKey,
              isFromEvent: isFromEvent,
            );
          },
        ),
      ],
    );
  }
}
