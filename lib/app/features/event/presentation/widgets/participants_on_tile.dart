import 'package:flutter/material.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ParticipantsOnTile extends StatelessWidget {
  const ParticipantsOnTile({
    required this.participantsProfile,
    super.key,
  });

  static const _participantsMax = 3;

  final List<String> participantsProfile;

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
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: context.colorScheme.shadow.withOpacity(0.05),
                        blurRadius: 4,
                      ),
                    ],
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF6F97D4),
                        Color(0xFFD9C8EB),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary,
                      gradient: index == _participantsMax
                          ? const LinearGradient(
                              colors: [
                                Color(0xFF6F97D4),
                                Color(0xFFD9C8EB),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )
                          : null,
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
