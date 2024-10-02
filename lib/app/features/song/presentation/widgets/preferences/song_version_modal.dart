import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song_configuration/application/song_config_notifier.dart';
import 'package:on_stage_app/app/features/song_configuration/domain/song_config_request/song_config_request.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';

class SongVersionModal extends ConsumerStatefulWidget {
  const SongVersionModal({
    super.key,
  });

  @override
  ChordViewModeModalState createState() => ChordViewModeModalState();

  static void show({
    required BuildContext context,
  }) {
    showModalBottomSheet<Widget>(
      backgroundColor: context.colorScheme.surface,
      context: context,
      builder: (context) => NestedScrollModal(
        buildHeader: () => const ModalHeader(title: 'Song View'),
        headerHeight: () {
          return 64;
        },
        buildContent: () {
          return const SingleChildScrollView(
            child: SongVersionModal(),
          );
        },
      ),
    );
  }
}

class ChordViewModeModalState extends ConsumerState<SongVersionModal> {
  bool _isCustom = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isCustom = ref.watch(songConfigurationNotifierProvider).isCustom;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultScreenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVersion(isTeamsCustomVersion: true),
          _buildVersion(isTeamsCustomVersion: false),
          // const SizedBox(height: 4),
          Text(
            'The selected version of this song will be saved per team, '
            'it will be used in all your events.',
            style: context.textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          ContinueButton(
            text: 'Update Song',
            onPressed: () {
              _setSongVersion(_isCustom);
            },
            isEnabled: true,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildVersion({required bool isTeamsCustomVersion}) {
    return InkWell(
      onTap: () {
        setState(() {
          _isCustom = isTeamsCustomVersion;
        });
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: _isCustom == isTeamsCustomVersion
                ? context.colorScheme.primary
                : context.colorScheme.onSurfaceVariant,
            width: 2,
          ),
          color: context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          isTeamsCustomVersion ? "Team's version" : 'Original',
          style: context.textTheme.titleMedium,
        ),
      ),
    );
  }

  Future<void> _setSongVersion(bool isCustom) async {
    final songId = ref.read(songNotifierProvider).song.id;
    if (songId.isNullEmptyOrWhitespace) return;
    final request = SongConfigRequest(
      isCustom: isCustom,
      teamId: ref.read(teamNotifierProvider).currentTeam?.id,
      songId: songId,
    );
    await ref
        .read(songConfigurationNotifierProvider.notifier)
        .updateSongConfiguration(request);
    context
      ..popDialog()
      ..popDialog();

    unawaited(ref.read(songNotifierProvider.notifier).init(songId!));
  }
}
