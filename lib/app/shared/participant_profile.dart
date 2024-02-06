import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ParticipantProfile extends StatelessWidget {
  const ParticipantProfile({
    required this.profilePicture,
    required this.fullName,
    super.key,
  });

  final String profilePicture;
  final String fullName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(profilePicture),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          fullName,
          style: context.textTheme.bodySmall,
        ),
      ],
    );
  }
}
