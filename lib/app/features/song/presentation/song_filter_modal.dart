import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/search/application/search_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/filter_tempo_range.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preference_artist.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_theme.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/song_library_toggle.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/adaptive_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongFilterModal extends ConsumerStatefulWidget {
  const SongFilterModal({this.expand = false, super.key});

  final bool expand;

  @override
  SongFilterModalState createState() => SongFilterModalState();

  static void show({
    required BuildContext context,
    bool expand = false,
  }) {
    AdaptiveModal.show(
      isFloatingForLargeScreens: true,
      expand: expand,
      context: context,
      child: const SingleChildScrollView(
        child: SongFilterModal(),
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
    return NestedScrollModal(
      buildHeader: () => ModalHeader(
        title: 'Advanced Filter',
        leadingButton: Container(
          width: 80 - 6,
          padding: const EdgeInsets.only(left: 6),
          child: Consumer(
            builder: (context, ref, _) {
              return InkWell(
                onTap: () {
                  ref.read(searchNotifierProvider.notifier).resetAllFilters();
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
        return Padding(
          padding: defaultScreenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const PreferenceArtist(),
              const SizedBox(height: Insets.medium),
              const PreferenceTheme(),
              const SizedBox(height: Insets.medium),
              const SongLibraryToggle(),
              const SizedBox(height: Insets.medium),
              TempoRangeSlider(
                startValue:
                    ref.watch(searchNotifierProvider).tempoFilter?.min ?? 30,
                endValue:
                    ref.watch(searchNotifierProvider).tempoFilter?.max ?? 120,
                onChanged: (min, max) {
                  final minValue = min == 30 ? null : min;
                  final maxValue = max == 120 ? null : max;

                  ref
                      .read(searchNotifierProvider.notifier)
                      .setTempoFilter(minValue, maxValue);
                },
              ),
              const SizedBox(height: Insets.medium),
            ],
          ),
        );
      },
    );
  }
}
