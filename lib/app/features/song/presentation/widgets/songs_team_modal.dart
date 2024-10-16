import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/songs_team_toggle.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongTeamModal extends StatelessWidget {
  const SongTeamModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Songs Selection',
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        const SongsTeamToggle(),
      ],
    );
  }
}
