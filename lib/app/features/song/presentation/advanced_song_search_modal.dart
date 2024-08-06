import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preference_artist.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_genre.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preference_vocal_lead.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_key.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_tempo.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_tempo_range.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_text_size.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_theme.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_view_mode.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/search_filter.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';

class AdvancedSongSearchModal extends ConsumerStatefulWidget {
  const AdvancedSongSearchModal({super.key});

  // final SongKey tonality;

  @override
  AdvancedSongSearchModalState createState() => AdvancedSongSearchModalState();

  static void show({
    required BuildContext context,
    // required SongKey tonality,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: const Color(0xFFF4F4F4),
      context: context,
      builder: (context) => FractionallySizedBox(
        child: NestedScrollModal(
          buildHeader: () => const ModalHeader(title: 'Advanced Search'),
          headerHeight: () {
            return 64;
          },
          buildContent: () {
            return SingleChildScrollView(
              child: AdvancedSongSearchModal(),
            );
          },
        ),
      ),
    );
  }
}

class AdvancedSongSearchModalState
    extends ConsumerState<AdvancedSongSearchModal> {
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
          PreferenceArtist(),
          SizedBox(height: Insets.medium),
          Row(
            children: [
              PreferenceGenre(),
              SizedBox(width: Insets.medium),
              PreferenceTheme(),
            ],
          ),
          SizedBox(height: Insets.medium),
          PreferencesViewMode(),
          SizedBox(height: Insets.medium),
          //PreferencesKey(),
        PreferencesTempoRange(),
          SizedBox(height: Insets.medium),
          // ContinueButton(
          //   text: 'Save',
          //   onPressed: _submitForm,
          //   isEnabled: true,
          // ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {}
}
