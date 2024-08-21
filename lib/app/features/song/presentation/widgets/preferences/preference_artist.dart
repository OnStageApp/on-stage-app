import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/dummy_data/artists_dummy.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';
import 'package:on_stage_app/app/features/search/application/search_controller.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/artist_modal.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class PreferenceArtist extends ConsumerStatefulWidget {
  const PreferenceArtist({super.key});

  @override
  PreferenceArtistState createState() => PreferenceArtistState();
}

class PreferenceArtistState extends ConsumerState<PreferenceArtist> {
  late Artist? selectedArtist;

  final List<Artist> artists = ArtistsDummy.artists;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selectedArtist = ref.watch(searchControllerProvider).artistFilter;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Artist',
          style: context.textTheme.titleMedium,
        ),
        const SizedBox(height: Insets.small),
        PreferencesActionTile(
          leadingWidget: selectedArtist != null
              ? CircleAvatar(
                  backgroundImage: AssetImage(selectedArtist!.imageUrl!),
                  radius: 12,
                )
              : const Icon(Icons.account_circle),
          title: ref.watch(searchControllerProvider).artistFilter?.name ??
              'All Artists',
          trailingIcon: Icons.keyboard_arrow_right_rounded,
          onTap: () {
            ArtistModal.show(context: context);
          },
        ),
      ],
    );
  }
}
