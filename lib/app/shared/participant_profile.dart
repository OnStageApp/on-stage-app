import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ParticipantProfile extends StatelessWidget {
  final String profilePicture;
  final String fullName;

  ParticipantProfile({required this.profilePicture, required this.fullName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48, // You can adjust the width as needed
          height: 48, // This sets the circular avatar height
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(profilePicture), // Use AssetImage for local assets
            ),
          ),
        ),
        SizedBox(height: 8), // Adjust the spacing between the circle and text
        Text(
          fullName,
          style: context.textTheme.bodySmall,
        ),
      ],
    );
  }
}
