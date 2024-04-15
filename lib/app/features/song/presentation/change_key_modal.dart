import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_enum.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/tonality_model.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/chord_type_widget.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ChangeKeyModal extends ConsumerStatefulWidget {
  const ChangeKeyModal(
    this.tonality, {
    super.key,
  });

  final SongKey tonality;

  @override
  ChangeKeyModalState createState() => ChangeKeyModalState();

  static void show({
    required BuildContext context,
    required SongKey tonality,
  }) {
    showModalBottomSheet(
      enableDrag: true,
      backgroundColor: const Color(0xFFF4F4F4),
      context: context,
      builder: (context) => NestedScrollModal(
        buildHeader: () => const ModalHeader(title: 'Change Key'),
        headerHeight: () {
          return 64;
        },
        buildContent: () {
          return SingleChildScrollView(
            child: ChangeKeyModal(tonality),
          );
        },
      ),
    );
  }
}

class ChangeKeyModalState extends ConsumerState<ChangeKeyModal> {
  late SongKey _tonality;

  @override
  void initState() {
    _tonality = widget.tonality;
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
          _buildKey(),
          const SizedBox(height: Insets.small),
          _buildChordTypes(widget.tonality.isSharp ?? false),
          const SizedBox(height: Insets.normal),
          ContinueButton(
            text: 'Save',
            onPressed: _submitForm,
            isEnabled: true,
          ),
        ],
      ),
    );
  }

  Widget _buildKey() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Key',
              style: context.textTheme.labelLarge,
            ),
            Text(
              widget.tonality.name ?? '',
              style: context.textTheme.labelLarge!.copyWith(
                color: const Color(0xFF1996FF),
              ),
            ),
          ],
        ),
        const SizedBox(height: Insets.small),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: ChordsEnum.values.map((chord) {
              if (chord == _tonality.chord) {
                return _buildChordLabel(chord, isSelected: true);
              }
              return _buildChordLabel(chord);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildChordLabel(ChordsEnum chord, {bool isSelected = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _tonality = _tonality.copyWith(chord: chord, isSharp: false);
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xFF1996FF) : const Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            chord.name,
            style: isSelected
                ? _getStyling().copyWith(color: Colors.white)
                : _getStyling(),
          ),
        ),
      ),
    );
  }

  Widget _buildChordTypes(bool isSharp) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ChordTypeWidget(
            isEnabled: _getInactiveForEAndB(),
            chordType: 'b',
            isSharp: _tonality.isSharp == false,
            onTap: () {
              setState(() {
                _tonality = _tonality.copyWith(isSharp: false);
              });
            },
          ),
          ChordTypeWidget(
            chordType: '#',
            isSharp: _tonality.isSharp! == true,
            onTap: _getInactiveForEAndB()
                ? () {
                    setState(() {
                      _tonality = _tonality.copyWith(isSharp: true);
                    });
                  }
                : () {},
          ),
        ],
      ),
    );
  }

  bool _getInactiveForEAndB() {
    return _tonality.chord!.name != ChordsEnum.E.name &&
        _tonality.chord!.name != ChordEnum.B.name;
  }

  TextStyle _getStyling() {
    return context.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600);
  }

  Future<void> _submitForm() async {
    ref.read(songNotifierProvider.notifier).transpose(_tonality);
    context.popDialog();
  }
}
