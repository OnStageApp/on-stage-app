import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';

class ArtistSelectTile extends StatelessWidget {
  const ArtistSelectTile({
    required this.artist,
    required this.onTap,
    super.key,
  });
  final Artist artist;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 12,
              // backgroundImage: AssetImage(artist.imageUrl!),
            ),
            const SizedBox(width: 12),
            Text(
              artist.name,
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: onTap,
            ),
          ],
        ),
      ),
    );
  }
}
