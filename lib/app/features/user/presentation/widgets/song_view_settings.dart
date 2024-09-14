import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/song_view_toggle.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongViewSettings extends StatelessWidget {
  const SongViewSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Song View',
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        const SongViewToggle(),
      ],
    );
  }
}
