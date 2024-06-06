import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preference_composer.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preference_vocal_lead.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_tempo.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_text_size.dart';
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
          // SearchFilter(
          //     leadingIconPath: 'assets/images/band2.png',
          //     labelText: 'Composer',
          //     title: 'Bbso',
          //     onTap: () {}),
          PreferenceComposer(),
          SizedBox(height: Insets.medium),
          Row(
            children: [
              PreferencesTempo(),
              SizedBox(width: Insets.medium),
              PreferencesTextSize(),
            ],
          ),
          SizedBox(height: Insets.medium),
          PreferencesViewMode(),
          SizedBox(height: Insets.medium),
          SearchFilter(
              leadingIconPath: 'assets/icons/music_note.svg',
              labelText: 'key',
              title: 'D Major',
              onTap: () {}),
          SizedBox(height: Insets.medium),
          // PreferencesSongStructure(),
          PreferencesActionTile(
            leadingWidget: Icon(Icons.settings),
            title: 'title',
            trailingIcon: Icons.keyboard_arrow_down_rounded,
            onTap: () {},
          ),
          SizedBox(height: Insets.medium),
          // const SizedBox(height: Insets.normal),
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
