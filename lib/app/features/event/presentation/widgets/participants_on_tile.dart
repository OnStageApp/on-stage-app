import 'dart:typed_data';

import 'package:flutter/material.dart';
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

  int get _participantsLength =>
      participantsLength ?? participantsProfileBytes.length;

  bool get _isMoreThanMax => _participantsLength > _participantsMax;

  double get _tileWidth {
    final count = _isMoreThanMax ? _participantsMax + 1 : _participantsLength;
    return (count * width) - (count - 1) * 10;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: width,
      width: _tileWidth,
      child: Stack(
        children: [
          ...participantsProfileBytes.asMap().entries.map(
            (entry) {
              final index = entry.key;
              if (showOverlay) {
                return Positioned(
                  left: index * (width - 10),
                  child: Container(
                    width: width,
                    height: width,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: borderColor ?? context.colorScheme.surface,
                        width: 2,
                      ),
                      image: participantsProfileBytes[index] != null
                          ? DecorationImage(
                              image:
                                  MemoryImage(participantsProfileBytes[index]!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: participantsProfileBytes[index] == null
                        ? Icon(
                            Icons.person,
                            color:
                                backgroundColor ?? context.colorScheme.surface,
                          )
                        : const SizedBox(),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          if (_participantsLength >= _participantsMax)
            Positioned(
              left: (_participantsLength - 1) * (width - 10),
              child: Container(
                width: width,
                height: width,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor ?? context.colorScheme.surface,
                    width: 2,
                  ),
                  color:
                      backgroundColor ?? context.colorScheme.tertiaryContainer,
                ),
                child: Center(
                  child: Text(
                    '+${_participantsLength - _participantsMax}',
                    style: TextStyle(
                      color: context.colorScheme.onSurface,
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
