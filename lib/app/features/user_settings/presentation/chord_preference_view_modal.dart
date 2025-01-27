import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/features/user_settings/domain/chord_type_view_enum.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/adaptive_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ChordPreferenceViewModal extends ConsumerStatefulWidget {
  const ChordPreferenceViewModal({
    required this.onSelected,
    super.key,
  });

  final void Function(ChordViewPref?) onSelected;

  @override
  ChordPreferenceViewModalState createState() =>
      ChordPreferenceViewModalState();

  static void show({
    required BuildContext context,
    required void Function(ChordViewPref?) onSelected,
  }) {
    AdaptiveModal.show(
      context: context,
      child: ChordPreferenceViewModal(onSelected: onSelected),
    );
  }
}

class ChordPreferenceViewModalState
    extends ConsumerState<ChordPreferenceViewModal> {
  final _allThemes = ChordViewPref.values;

  @override
  Widget build(BuildContext context) {
    return NestedScrollModal(
      buildHeader: () => const ModalHeader(title: 'Chord Preferences'),
      headerHeight: () => 64,
      footerHeight: () => 64,
      buildContent: () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _allThemes.length,
              itemBuilder: (context, index) {
                return _buildTile(_allThemes[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(ChordViewPref pref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          final newPref = _isItemSelected(pref) ? null : pref;
          widget.onSelected(newPref);
          if (context.mounted) {
            context.popDialog();
          }
        },
        overlayColor:
            WidgetStateProperty.all(context.colorScheme.surfaceBright),
        child: Ink(
          height: 48,
          decoration: BoxDecoration(
            color: context.colorScheme.onSurfaceVariant,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isItemSelected(pref)
                  ? context.colorScheme.primary
                  : context.colorScheme.onSurfaceVariant,
              width: 1.6,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Text(
                pref.icon,
                style: context.textTheme.titleLarge,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  pref.description,
                  style: context.textTheme.titleSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isItemSelected(ChordViewPref theme) =>
      ref.watch(userSettingsNotifierProvider).chordViewPref == theme;
}
