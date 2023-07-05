import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/shared/stage_tile.dart';

class EventTile extends StatelessWidget {
  const EventTile({
    required this.title,
    required this.description,
    required this.chord,
    super.key,
  });

  final String title;
  final String description;
  final String chord;

  @override
  Widget build(BuildContext context) {
    return StageTile(
      title: title,
      description: description,
      trailing: const ParticipantsOnTile(
        participantsProfile: [
          'assets/images/profile1.png',
          'assets/images/profile2.png',
          'assets/images/profile4.png',
          'assets/images/profile5.png',
          'assets/images/profile5.png',
          'assets/images/profile5.png',
          'assets/images/profile5.png',
          'assets/images/profile5.png',
        ],
      ),
    );
  }
}
