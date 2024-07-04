import 'package:flutter/material.dart';

class ParticipantsOnTile extends StatelessWidget {
  const ParticipantsOnTile({
    required this.participantsProfile,
    this.width = 30,
    this.showOverlay = true,
    this.borderColor = Colors.white,
    super.key,
  });

  static const _participantsMax = 4;

  final List<String> participantsProfile;
  final double width;
  final bool showOverlay;
  final Color borderColor;

  bool get _isMoreThanMax => participantsProfile.length > _participantsMax;

  int get _participantsLength => participantsProfile.length;

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
        children: participantsProfile.asMap().entries.map(
          (entry) {
            final index = entry.key;
            final e = entry.value;
            if (index < _participantsMax ||
                (index == _participantsMax && showOverlay)) {
              return Positioned(
                left: index * (width - 10),
                child: Container(
                  width: width,
                  height: width,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor, width: 2),
                    image: index < _participantsMax
                        ? DecorationImage(
                            image: AssetImage(e),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: index == _participantsMax && showOverlay
                        ? Colors.white
                        : null,
                  ),
                  child: Center(
                    child: index == _participantsMax && showOverlay
                        ? Text(
                            '+${_participantsLength - _participantsMax}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const SizedBox(),
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ).toList(),
      ),
    );
  }
}
