import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_view_mode.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongViewModeModal extends ConsumerStatefulWidget {
  const SongViewModeModal({
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
        buildHeader: () => const ModalHeader(title: 'Song View'),
        headerHeight: () {
          return 64;
        },
        buildContent: () {
          return const SingleChildScrollView(
            child: SongViewModeModal(),
          );
        },
      ),
    );
  }
}

class ChordViewModeModalState extends ConsumerState<SongViewModeModal> {
  SongViewMode? _selectedValue;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedValue = ref.watch(userSettingsNotifierProvider).songView ??
            SongViewMode.american;
      });
    });
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

  Widget _buildChordTypeTile(SongViewMode songViewMode) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedValue = songViewMode;
        });
        ref.read(userSettingsNotifierProvider.notifier).setSongViewMode(
              songViewMode,
            );
        context.popDialog();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: _selectedValue == songViewMode
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
                songViewMode.example,
                style: context.textTheme.titleMedium!.copyWith(
                  color: context.colorScheme.outline,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              songViewMode.name,
              style: context.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
