import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/songs/presentation/widgets/stage_search_bar.dart';
import 'package:on_stage_app/app/shared/event_tile.dart';
import 'package:on_stage_app/app/shared/song_chord_tile.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Insets.normal,
            vertical: Insets.normal,
          ),
          child: ListView(
            children: [
              Text(
                'Songs',
                style: context.textTheme.headlineMedium,
              ),
              const SizedBox(height: Insets.medium),
              const StageSearchBar(),
              const SizedBox(height: Insets.medium),
              Text(
                'Upcoming',
                style: context.textTheme.titleMedium,
              ),
              const SizedBox(height: Insets.normal),
              const EventTile(
                title: 'Nu e munte prea mare',
                description: 'Monday, 14 Feb',
                chord: 'C# major',
              ),
              const SizedBox(height: Insets.medium),
              Text(
                'Songs (3)',
                style: context.textTheme.titleMedium,
              ),
              const SizedBox(height: Insets.normal),
              const SongChordTile(
                title: 'Nu e munte prea mare',
                description: 'Tabara 477',
                chord: 'C# major',
              )
            ],
          ),
        ),
      ),
    );
  }
}
