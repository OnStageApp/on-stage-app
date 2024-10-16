import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:on_stage_app/app/shared/image_with_placeholder.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ParticipantsOnTile extends StatelessWidget {
  const ParticipantsOnTile({
    this.participantsProfile = const [],
    this.participantsProfileBytes = const [],
    this.width = 30,
    this.showOverlay = true,
    this.borderColor,
    this.backgroundColor,
    this.participantsLength,
    this.participantsName,
    super.key,
  });

  static const _participantsMax = 2;

  final List<Uint8List?> participantsProfileBytes;
  final List<String> participantsProfile;
  final double width;
  final bool showOverlay;
  final Color? borderColor;
  final Color? backgroundColor;
  final int? participantsLength;
  final String? participantsName;

  int get _participantsLength => participantsLength ?? 0;

  bool get _isMoreThanMax => _participantsLength > _participantsMax;

  double get tileWidth {
    final count = _isMoreThanMax ? _participantsMax + 1 : _participantsLength;
    return (count * width) - (count - 1) * 10;
  }

  @override
  Widget build(BuildContext context) {
    final participants = List.generate(
      _participantsLength,
      (index) => {
        'photo': participantsProfileBytes.length > index
            ? participantsProfileBytes[index]
            : null,
        'name': participantsProfile.length > index
            ? participantsProfile[index]
            : participantsName ?? '',
      },
    );

    return SizedBox(
      height: width,
      width: tileWidth,
      child: Stack(
        children: [
          ...participants.asMap().entries.map((entry) {
            final index = entry.key;
            final participant = entry.value;

            if (showOverlay) {
              return Positioned(
                left: index * 20,
                child: SizedBox(
                  width: width,
                  height: width,
                  child: ImageWithPlaceholder(
                    photo: participant['photo'] as Uint8List?,
                    name: participant['name']! as String,
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          }),
          if (_participantsLength > _participantsMax)
            Positioned(
              left: _participantsMax * (width - 10),
              child: Container(
                width: width,
                height: width,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor ?? context.colorScheme.onSurfaceVariant,
                    width: 2,
                  ),
                  color:
                      backgroundColor ?? context.colorScheme.tertiaryContainer,
                ),
                child: Center(
                  child: Text(
                    '+${_participantsLength - _participantsMax}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
