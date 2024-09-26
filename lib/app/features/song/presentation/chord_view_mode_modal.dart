import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/application/preferences/preferences_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_view_mode.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ChordViewModeModal extends ConsumerStatefulWidget {
  const ChordViewModeModal({
    super.key,
  });

  @override
  ChordViewModeModalState createState() => ChordViewModeModalState();

  static void show({
    required BuildContext context,
  }) {
    showModalBottomSheet<Widget>(
      backgroundColor: context.colorScheme.surface,
      context: context,
      builder: (context) => NestedScrollModal(
        buildHeader: () => const ModalHeader(title: 'Chords View Mode'),
        headerHeight: () {
          return 64;
        },
        buildContent: () {
          return const SingleChildScrollView(
            child: ChordViewModeModal(),
          );
        },
      ),
    );
  }
}

class ChordViewModeModalState extends ConsumerState<ChordViewModeModal> {
  var _selectedValue = SongViewMode.american;

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
          _buildChordTypes(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildChordTypes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...SongViewMode.values.map(
          _buildChordTypeTile,
        ),
      ],
    );
  }

  Widget _buildChordTypeTile(SongViewMode chordTypeDisplay) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedValue = chordTypeDisplay;
        });
        ref.read(preferencesNotifierProvider.notifier).setChordViewMode(
              chordTypeDisplay,
            );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: _selectedValue == chordTypeDisplay
                ? context.colorScheme.primary
                : context.colorScheme.onSurfaceVariant,
            width: 2,
          ),
          color: context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 42,
              child: Text(
                chordTypeDisplay.example,
                style: context.textTheme.titleMedium!.copyWith(
                  color: context.colorScheme.outline,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              chordTypeDisplay.name,
              style: context.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
