import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_enum.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/chord_type_enum.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/song_key.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/chord_type_widget.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/adaptive_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ChangeKeyModal extends ConsumerStatefulWidget {
  const ChangeKeyModal(
    this.songKey, {
    required this.onKeyChanged,
    this.title = 'Change Key',
    super.key,
  });

  final SongKey songKey;
  final Future<void> Function(SongKey) onKeyChanged;
  final String title;

  @override
  ChangeKeyModalState createState() => ChangeKeyModalState();

  static void show({
    required BuildContext context,
    required SongKey songKey,
    required Future<void> Function(SongKey) onKeyChanged,
    String title = 'Change Key',
  }) {
    AdaptiveModal.show<void>(
      context: context,
      expand: false,
      isFloatingForLargeScreens: true,
      child: ChangeKeyModal(songKey, onKeyChanged: onKeyChanged, title: title),
    );
  }
}

class ChangeKeyModalState extends ConsumerState<ChangeKeyModal> {
  late SongKey _songKey;
  late SongKey _initialSongKey;
  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    _songKey = widget.songKey;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _songKey = ref.read(songNotifierProvider).song.key ?? _songKey;
        _initialSongKey = _songKey;
      });
    });
  }

  void _updateSongKey(SongKey newKey) {
    setState(() {
      _songKey = newKey;
      _hasChanged = _songKey != _initialSongKey;
    });
  }

  //TODO: Add constraints on width
  @override
  Widget build(BuildContext context) {
    return NestedScrollModal(
      buildHeader: () => ModalHeader(title: widget.title),
      headerHeight: () {
        return 64;
      },
      buildContent: () {
        return SingleChildScrollView(
          child: Padding(
            padding: defaultScreenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildKeys(),
                const SizedBox(height: Insets.small),
                _buildChordTypes(),
                const SizedBox(height: Insets.medium),
                Center(
                  child: ContinueButton(
                    text: 'Save',
                    onPressed: _submitForm,
                    isEnabled: _hasChanged,
                  ),
                ),
                const SizedBox(height: Insets.normal),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildKeys() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Key',
              style: context.textTheme.titleSmall,
            ),
            if (ref.watch(songNotifierProvider).song.originalKey != null)
              Text(
                'Original '
                '${ref.watch(songNotifierProvider).song.originalKey?.name}',
                style: context.textTheme.titleSmall!.copyWith(
                  color: context.colorScheme.primary,
                ),
              ),
          ],
        ),
        const SizedBox(height: Insets.small),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          height: 80,
          decoration: BoxDecoration(
            color: context.colorScheme.onSurfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: ChordsWithoutSharp.values.map((chord) {
              if (chord == _songKey.chord) {
                return _buildChordLabel(chord, isSelected: true);
              }
              return _buildChordLabel(chord);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildChordTypes() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: ChordTypeEnum.values.map((type) {
          final isSelected = _songKey.keyType == type;
          final isEnabled = _isChordTypeEnabled(type);

          return ChordTypeWidget(
            chordType: type.name,
            isSelected: isSelected,
            isEnabled: isEnabled,
            onTap: isEnabled
                ? () {
                    final songKey = _songKey.copyWith(keyType: type);
                    _updateSongKey(songKey);
                  }
                : null,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChordLabel(ChordsWithoutSharp chord, {bool isSelected = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          final songKey =
              _songKey.copyWith(chord: chord, keyType: ChordTypeEnum.natural);
          _updateSongKey(songKey);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? context.colorScheme.primary
                : context.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(chord.name, style: _getStyling(isSelected: isSelected)),
        ),
      ),
    );
  }

  bool _isChordTypeEnabled(ChordTypeEnum type) {
    if (_songKey.chord == null) return false;

    return switch (_songKey.chord!) {
      ChordsWithoutSharp.E => type != ChordTypeEnum.sharp,
      ChordsWithoutSharp.B => type != ChordTypeEnum.sharp,
      ChordsWithoutSharp.F => type != ChordTypeEnum.flat,
      ChordsWithoutSharp.C => type != ChordTypeEnum.flat,
      _ => true,
    };
  }

  TextStyle _getStyling({bool isSelected = false}) {
    return context.textTheme.titleMedium!.copyWith(
      color: isSelected ? Colors.white : context.colorScheme.onSurface,
    );
  }

  Future<void> _submitForm() async {
    await widget.onKeyChanged(_songKey);
    if (mounted) {
      context.popDialog();
    }
  }
}
