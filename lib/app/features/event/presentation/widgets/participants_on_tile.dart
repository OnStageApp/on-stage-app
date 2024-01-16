import 'package:flutter/material.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ParticipantsOnTile extends StatelessWidget {
  const ParticipantsOnTile({
    required this.participantsProfile,
    this.width = 48,
    super.key,
  });

  static const _participantsMax = 3;

  final List<String> participantsProfile;
  final double width;

  bool get _isMoreThanMax => participantsProfile.length > _participantsMax;

  int get _participantsLength => participantsProfile.length;

  double get _widthOfParticipants => _isMoreThanMax
      ? Insets.medium * 4
      : Insets.medium * (_participantsLength + 1);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: _widthOfParticipants,
      child: Stack(
        alignment: Alignment.centerRight,
        children: participantsProfile.map(
          (e) {
            final index = participantsProfile.indexOf(e);
            if (index <= _participantsMax) {
              return Positioned(
                left: (participantsProfile.indexOf(e)) * Insets.normal,
                child: Container(
                  width: width,
                  height: width,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colorScheme.primary,
                  ),
                  child: Container(
                    width: width - 6,
                    height: width - 6,
                    decoration: BoxDecoration(
                      color: context.colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                      image: index < _participantsMax
                          ? DecorationImage(
                              image: AssetImage(e),
                              scale: 0.5,
                              fit: BoxFit.fill,
                            )
                          : null,
                    ),
                    child: Center(
                      child: index == _participantsMax
                          ? Text(
                              '+'
                              '${_participantsLength - _participantsMax}',
                              style: context.textTheme.titleSmall!
                                  .copyWith(color: Colors.white),
                            )
                          : const SizedBox(),
                    ),
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
