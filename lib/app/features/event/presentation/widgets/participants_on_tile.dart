import 'package:flutter/material.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ParticipantsOnTile extends StatelessWidget {
  static const _maxNumberOfParticipants = 3;
  const ParticipantsOnTile({
    required this.participantsProfile,
    super.key,
  });

  final List<String> participantsProfile;

  bool get _isMoreThanMax =>
      participantsProfile.length > _maxNumberOfParticipants;
  int get _lengthOfParticipants => participantsProfile.length;
  double get _widthOfParticipants => _isMoreThanMax
      ? Insets.medium * 4
      : Insets.medium * (_lengthOfParticipants + 1);
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
            if (index <= _maxNumberOfParticipants) {
              return Positioned(
                left: (participantsProfile.indexOf(e)) * Insets.normal,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary,
                    shape: BoxShape.circle,
                    image: index < _maxNumberOfParticipants
                        ? DecorationImage(
                            image: AssetImage(e),
                            fit: BoxFit.fill,
                          )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: context.colorScheme.shadow.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(-2, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: index == _maxNumberOfParticipants
                        ? Text(
                            '+'
                            '${_lengthOfParticipants - _maxNumberOfParticipants}',
                            style: context.textTheme.titleSmall!
                                .copyWith(color: Colors.white),
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
