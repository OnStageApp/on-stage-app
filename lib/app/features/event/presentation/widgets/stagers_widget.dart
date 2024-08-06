import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_overview.dart';
import 'package:on_stage_app/app/shared/participant_profile.dart';

class StagersList extends StatelessWidget {
  const StagersList({
    required this.stagers,
    super.key,
  });

  final List<StagerOverview> stagers;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stagers.length,
        itemBuilder: (context, index) {
          final stager = stagers[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ParticipantProfile(
              profilePicture: stager.picture,
              fullName: stager.firstName,
            ),
          );
        },
        shrinkWrap: true,
      ),
    );
  }
}
