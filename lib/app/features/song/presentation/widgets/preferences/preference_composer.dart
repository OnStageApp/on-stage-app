import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';
import 'package:on_stage_app/app/features/song/presentation/preferences/composer_modal.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class PreferenceComposer extends ConsumerStatefulWidget {
  const PreferenceComposer({Key? key}) : super(key: key);

  @override
  PreferenceComposerState createState() => PreferenceComposerState();
}

class PreferenceComposerState extends ConsumerState<PreferenceComposer> {
  late Artist selectedArtist;

  final List<Artist> artists = [
    const Artist(
      id: 1,
      fullName: 'BBSO',
      songIds: [1, 2, 3],
      imageUrl: 'assets/images/band1.png',
    ),
    const Artist(
      id: 2,
      fullName: 'Tabara 477',
      songIds: [4, 5, 6],
      imageUrl: 'assets/images/band2.png',
    ),
    const Artist(
      id: 3,
      fullName: 'El-Shaddai',
      songIds: [7, 8, 9],
      imageUrl: 'assets/images/band3.png',
    ),
    const Artist(
      id: 4,
      fullName: 'Hillsong',
      songIds: [10, 11, 12],
      imageUrl: 'assets/images/profile5.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    selectedArtist = artists.first;
  }

  @override
  Widget build(BuildContext context) {
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Composer',
            style: context.textTheme.labelLarge,
          ),
          const SizedBox(height: Insets.small),

             PreferencesActionTile(
              leadingWidget: CircleAvatar(
                backgroundImage: AssetImage(selectedArtist.imageUrl!),
                radius: 12,
              ),
              title: selectedArtist.fullName,
              trailingIcon: Icons.keyboard_arrow_right_rounded,
              onTap: () {
                ComposerModal.show(context: context, ref: ref);
              },

          ),
        ],
    );
  }

  void _showArtistSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: artists.length,
          itemBuilder: (context, index) {
            final artist = artists[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(artist.imageUrl!),
              ),
              title: Text(artist.fullName),
              onTap: () {
                setState(() {
                  selectedArtist = artist;
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}
