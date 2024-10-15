import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/shared/image_with_placeholder.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ProfileImageWidget extends ConsumerWidget {
  const ProfileImageWidget({
    required this.name,
    required this.photo,
    required this.userId,
    Key? key,
    this.canChangeProfilePicture = false,
    this.size = 100,
  }) : super(key: key);

  final String userId;
  final bool canChangeProfilePicture;
  final double size;
  final String name;
  final Uint8List? photo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilePicture = ref.watch(userNotifierProvider).userPhoto;
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
      child: ImageWithPlaceholder(
        photo: photo,
        name: name,
        isLargeTitle: true,
      ),
    );
  }
}
