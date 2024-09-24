import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member_photo/team_member_photo.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ProfileImageWidget extends ConsumerWidget {
  const ProfileImageWidget({
    required this.userId,
    Key? key,
    this.canChangeProfilePicture = false,
    this.size = 100,
  }) : super(key: key);

  final String userId;
  final bool canChangeProfilePicture;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(databaseProvider);

    return FutureBuilder<TeamMemberPhoto?>(
      future: database.getTeamMemberPhoto(userId),
      builder: (context, snapshot) {
        final profilePicture = snapshot.data?.profilePicture;

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border.all(
              color: context.colorScheme.primaryContainer,
            ),
            shape: BoxShape.circle,
            image: profilePicture != null
                ? DecorationImage(
                    image: MemoryImage(profilePicture),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: profilePicture == null
              ? Container(
                  decoration: BoxDecoration(
                    color: context.colorScheme.onSurfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: context.colorScheme.primaryContainer,
                    size: size * 0.6,
                  ),
                )
              : null,
        );
      },
    );
  }
}
