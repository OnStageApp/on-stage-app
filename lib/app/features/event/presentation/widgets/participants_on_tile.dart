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

  int get _participantsLength => participantsLength ?? 0;

  bool get _isMoreThanMax => _participantsLength > _participantsMax;

  double get tileWidth {
    final count = _isMoreThanMax ? _participantsMax + 1 : _participantsLength;
    return (count * width) - (count - 1) * 10;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: width,
      width: (_participantsLength * width) - (_participantsLength - 1) * 10,
      child: Stack(
        children: [
          ...(participantsProfileBytes.length > 2
                  ? participantsProfileBytes.sublist(0, _participantsMax)
                  : participantsProfileBytes)
              .asMap()
              .entries
              .map(
            (entry) {
              final index = entry.key;
              if (showOverlay) {
                return Positioned(
                  left: index * 20,
                  child: Container(
                    width: width,
                    height: width,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: backgroundColor ??
                          context.colorScheme.primaryContainer,
                      border: Border.all(
                        color:
                            borderColor ?? context.colorScheme.onSurfaceVariant,
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
                            color: context.colorScheme.surface,
                          )
                        : const SizedBox(),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
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
