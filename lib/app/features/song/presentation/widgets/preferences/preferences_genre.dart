import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/dummy_data/genres_dummy.dart';
import 'package:on_stage_app/app/features/search/application/search_notifier.dart';
import 'package:on_stage_app/app/features/search/domain/enums/genre_filter_enum.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/genre_modal.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class PreferenceGenre extends ConsumerStatefulWidget {
  const PreferenceGenre({super.key});

  @override
  PreferenceGenreState createState() => PreferenceGenreState();
}

class PreferenceGenreState extends ConsumerState<PreferenceGenre> {
  late GenreFilterEnum selectedGenre;

  final List<GenreFilterEnum> genres = GenresDummy.genres;

  @override
  void initState() {
    super.initState();
    selectedGenre = genres.first;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Genre',
            style: context.textTheme.titleMedium,
          ),
          const SizedBox(height: Insets.small),
          PreferencesActionTile(
            title: ref.watch(searchNotifierProvider).genreFilter?.value ??
                'All Genres',
            trailingIcon: Icons.keyboard_arrow_right_rounded,
            onTap: () {
              GenreModal.show(context: context);
            },
          ),
        ],
      ),
    );
  }
}
