import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/tonality_model.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preference_vocal_lead.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_key.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_structure.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_tempo.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_text_size.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_view_mode.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongPreferencesModal extends ConsumerStatefulWidget {
  const SongPreferencesModal(this.tonality, {super.key});

  final SongKey tonality;

  @override
  SongPreferencesModalState createState() => SongPreferencesModalState();

  static void show({
    required BuildContext context,
    required SongKey tonality,
  }) {
    showModalBottomSheet<Widget>(
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface,
      context: context,
      builder: (context) => FractionallySizedBox(
        child: NestedScrollModal(
          buildHeader: () => const ModalHeader(title: 'Preferences'),
          headerHeight: () {
            return 64;
          },
          buildContent: () {
            return SingleChildScrollView(
              child: SongPreferencesModal(tonality),
            );
          },
        ),
      ),
    );
  }
}

class SongPreferencesModalState extends ConsumerState<SongPreferencesModal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: defaultScreenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          PreferencesVocalLead(),
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
          PreferencesKey(),
          SizedBox(height: Insets.medium),
          PreferencesSongStructure(),
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
