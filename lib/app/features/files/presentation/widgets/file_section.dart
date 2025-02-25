// Create a dedicated widget for file sections
import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';
import 'package:on_stage_app/app/features/files/presentation/widgets/song_file_tile.dart';

class FileSection extends StatelessWidget {
  const FileSection({
    required this.title,
    required this.files,
    required this.songId,
    super.key,
  });
  final String title;
  final List<SongFile> files;
  final String songId;

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        ...files.map((file) => SongFileTile(file, songId)),
      ],
    );
  }
}
