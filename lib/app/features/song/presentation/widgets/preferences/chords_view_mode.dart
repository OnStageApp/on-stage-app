import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_view_mode.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ChordsViewModeWidget extends ConsumerStatefulWidget {
  const ChordsViewModeWidget({super.key});

  @override
  ChordsViewModeWidgetState createState() => ChordsViewModeWidgetState();
}

class ChordsViewModeWidgetState extends ConsumerState<ChordsViewModeWidget> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isDropdownOpen = false;
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeOverlay();
      setState(() {
        _isDropdownOpen = false;
      });
    } else {
      _showDropdown();
      setState(() {
        _isDropdownOpen = true;
      });
    }
  }

  void _showDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height),
          child: Material(
            elevation: 8,
            color: Colors.transparent,
            child: _buildDropdownContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownContent() {
    final currentChordView = ref.watch(userSettingsNotifierProvider).chordView;

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 24,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      margin: const EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ...ChordViewMode.values.asMap().entries.map((entry) {
            final index = entry.key;
            final chordsView = entry.value;
            final isSelected = currentChordView == chordsView;
            final isLast = index == ChordViewMode.values.length - 1;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    ref
                        .read(userSettingsNotifierProvider.notifier)
                        .setChordsViewMode(
                          chordsView,
                        );
                    _removeOverlay();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: const BoxDecoration(),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30,
                          child: Text(
                            chordsView.example,
                            style: context.textTheme.titleMedium!.copyWith(
                              color: context.colorScheme.outline,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          chordsView.name,
                          style: context.textTheme.titleMedium,
                        ),
                        const Spacer(),
                        Icon(
                          isSelected ? LucideIcons.check : null,
                          color: context.colorScheme.onSurface,
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 12,
                    endIndent: 12,
                    color: context.colorScheme.outlineVariant.withAlpha(80),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userSettings = ref.watch(userSettingsNotifierProvider);
    final currentChordView = userSettings.chordView;

    return CompositedTransformTarget(
      link: _layerLink,
      child: PreferencesActionTile(
        backgroundColor:
            _isDropdownOpen ? context.colorScheme.surfaceBright : null,
        leadingWidget: Text(
          currentChordView?.example ?? '',
          style: context.textTheme.titleMedium!
              .copyWith(color: context.colorScheme.outline),
        ),
        title: currentChordView?.name ?? '',
        trailingIcon: _isDropdownOpen
            ? Icons.keyboard_arrow_up_rounded
            : Icons.keyboard_arrow_down_rounded,
        onTap: _toggleDropdown,
      ),
    );
  }
}
