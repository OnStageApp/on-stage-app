import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';

class ArtistSelectTile extends StatelessWidget {
  final Artist artist;
  final VoidCallback onTap;

  const ArtistSelectTile({
    required this.artist,
    required this.onTap,
    Key? key,
  }) : super(key: key);

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
              backgroundImage: AssetImage(artist.imageUrl!),
            ),
            SizedBox(width: 12),
            Text(
              artist.fullName,
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: onTap,
            ),
          ],
        ),
      ),
    );
  }
}
