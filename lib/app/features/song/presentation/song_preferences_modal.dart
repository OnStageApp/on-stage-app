import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/song_key.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preference_vocal_lead.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_structure.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_tempo.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_text_size.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/song_version_dropdown.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongPreferencesModal extends ConsumerStatefulWidget {
  const SongPreferencesModal(
    this.tonality, {
    this.isFromEvent = false,
    super.key,
  });

  final SongKey tonality;
  final bool isFromEvent;

  @override
  SongPreferencesModalState createState() => SongPreferencesModalState();

  static void show({
    required BuildContext context,
    required SongKey tonality,
    bool isFromEvent = false,
  }) {
    showModalBottomSheet<Widget>(
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
        minHeight: MediaQuery.of(context).size.height * 0.7,
        maxWidth: MediaQuery.of(context).size.width,
      ),
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
              child: SongPreferencesModal(
                tonality,
                isFromEvent: isFromEvent,
              ),
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
    return Padding(
      padding: defaultScreenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            children: [
              PreferencesTempo(),
              SizedBox(width: Insets.medium),
              PreferencesTextSize(),
            ],
          ),
          if (widget.isFromEvent) ...[
            const SizedBox(height: Insets.medium),
            const PreferencesVocalLead(),
            const SizedBox(height: Insets.medium),
          ],
          if (widget.isFromEvent) ...[
            const PreferencesSongStructure(),
          ],
          const SizedBox(height: Insets.medium),
          const SongVersionDropdown(),
          const SizedBox(height: Insets.medium),
        ],
      ),
    );
  }
}
