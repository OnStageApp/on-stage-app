import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/search/application/search_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/filter_tempo_range.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preference_artist.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_genre.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_theme.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/song_library_toggle.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongFilterModal extends ConsumerStatefulWidget {
  const SongFilterModal({super.key});

  @override
  SongFilterModalState createState() => SongFilterModalState();

  static void show({
    required BuildContext context,
  }) {
    showModalBottomSheet<Widget>(
      isScrollControlled: true,
      context: context,
      backgroundColor: context.colorScheme.surface,
      builder: (context) => FractionallySizedBox(
        child: NestedScrollModal(
          buildHeader: () => ModalHeader(
            title: 'Advanced Filter',
            leadingButton: Container(
              width: 68,
              padding: const EdgeInsets.only(left: 8),
              child: Consumer(
                builder: (context, ref, _) {
                  return InkWell(
                    onTap: () {
                      ref
                          .read(searchNotifierProvider.notifier)
                          .resetAllFilters();
                    },
                    child: Text(
                      'Reset',
                      style: context.textTheme.titleSmall!
                          .copyWith(color: context.colorScheme.primary),
                    ),
                  );
                },
              ),
            ),
          ),
          headerHeight: () {
            return 64;
          },
          buildContent: () {
            return const SingleChildScrollView(
              child: SongFilterModal(),
            );
          },
        ),
      ),
    );
  }
}

class SongFilterModalState extends ConsumerState<SongFilterModal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultScreenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const PreferenceArtist(),
          const SizedBox(height: Insets.medium),
          const Row(
            children: [
              PreferenceGenre(),
              SizedBox(width: Insets.medium),
              PreferenceTheme(),
            ],
          ),
          const SizedBox(height: Insets.medium),
          const SongLibraryToggle(),
          const SizedBox(height: Insets.medium),
          TempoRangeSlider(
            startValue: 30,
            endValue: 120,
            onChanged: (start, end) {},
          ),
          const SizedBox(height: Insets.medium),
        ],
      ),
    );
  }
}
