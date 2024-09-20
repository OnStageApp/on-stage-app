import 'dart:typed_data';

import 'package:flutter/material.dart';

class ParticipantsOnTile extends StatelessWidget {
  const ParticipantsOnTile({
    this.participantsProfile = const [],
    this.participantsProfileBytes = const [],
    this.width = 30,
    this.showOverlay = true,
    this.borderColor = Colors.white,
    this.backgroundColor,
    this.participantsLength,
    super.key,
  });

  static const _participantsMax = 2;

  final List<Uint8List?> participantsProfileBytes;
  final List<String> participantsProfile;
  final double width;
  final bool showOverlay;
  final Color borderColor;
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
              if (showOverlay && participantsProfileBytes[index] != null) {
                return Positioned(
                  left: index * (width - 10),
                  child: Container(
                    width: width,
                    height: width,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: borderColor, width: 2),
                        image: DecorationImage(
                          image: MemoryImage(participantsProfileBytes[index]!),
                          fit: BoxFit.cover,
                        )),
                    child: const Center(
                      child: SizedBox(),
                    ),
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
                  border: Border.all(color: borderColor, width: 2),
                  color: backgroundColor ?? const Color(0xFFD8E1FE),
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
