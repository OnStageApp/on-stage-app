import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/song_key.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preference_vocal_lead.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_structure.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_tempo.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_text_size.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/song_view_settings.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/adaptive_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';

class SongPreferencesModal extends ConsumerStatefulWidget {
  const SongPreferencesModal(
    this.tonality, {
    this.isFromEvent = false,
    super.key,
  });

  final SongKey tonality;
  final bool isFromEvent;

  @override
  SongPreferencesModalState createState() => SongPreferencesModalState();

  static void show({
    required BuildContext context,
    required SongKey tonality,
    bool isFromEvent = false,
  }) {
    AdaptiveModal.show(
      context: context,
      child: SongPreferencesModal(tonality, isFromEvent: isFromEvent),
    );
  }
}

class SongPreferencesModalState extends ConsumerState<SongPreferencesModal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isSongAddedByCurrentTeam = ref
            .watch(songNotifierProvider)
            .song
            .teamId
            ?.isNotNullEmptyOrWhitespace ??
        false;
    return NestedScrollModal(
      buildHeader: () => const ModalHeader(title: 'Preferences'),
      headerHeight: () {
        return 64;
      },
      buildContent: () {
        return SingleChildScrollView(
          child: Padding(
            padding: defaultScreenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  children: [
                    PreferencesTempo(),
                    SizedBox(width: Insets.medium),
                    PreferencesTextSize(),
                  ],
                ),
                const SizedBox(height: Insets.medium),
                const SongViewSettings(),
                if (widget.isFromEvent) ...[
                  const SizedBox(height: Insets.medium),
                  const PreferencesVocalLead(),
                ],
                if (widget.isFromEvent || isSongAddedByCurrentTeam) ...[
                  const SizedBox(height: Insets.medium),
                  const PreferencesSongStructure(),
                ],
                if (isSongAddedByCurrentTeam) ...[
                  const SizedBox(height: Insets.medium),
                  Text(
                    'Edit Song',
                    style: context.textTheme.titleSmall,
                  ),
                  const SizedBox(height: Insets.smallNormal),
                  PreferencesActionTile(
                    leadingWidget: Icon(
                      LucideIcons.list_music,
                      color: context.colorScheme.outline,
                    ),
                    title: 'Lyrics And Chords',
                    trailingIcon: Icons.keyboard_arrow_right_rounded,
                    onTap: () {
                      context
                        ..popDialog()
                        ..pushNamed(
                          AppRoute.editSongContent.name,
                          queryParameters: {
                            'songId':
                                ref.watch(songNotifierProvider).song.id ?? '',
                          },
                        );
                    },
                  ),
                  const SizedBox(height: Insets.smallNormal),
                  PreferencesActionTile(
                    leadingWidget: Icon(
                      LucideIcons.tags,
                      color: context.colorScheme.outline,
                    ),
                    title: 'Song Info',
                    trailingIcon: Icons.keyboard_arrow_right_rounded,
                    onTap: () {
                      context
                        ..popDialog()
                        ..pushNamed(
                          AppRoute.editSongInfo.name,
                          queryParameters: {
                            'songId':
                                ref.watch(songNotifierProvider).song.id ?? '',
                          },
                        );
                    },
                  ),
                ],
                const SizedBox(height: Insets.medium),
              ],
            ),
          ),
        );
      },
    );
  }
}
