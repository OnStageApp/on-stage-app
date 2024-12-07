import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/shared/image_with_placeholder.dart';
import 'package:on_stage_app/app/shared/profile_photo_viewer.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

// Using InkWell with Material for proper splash effect
class ProfileImageWidget extends ConsumerWidget {
  const ProfileImageWidget({
    required this.name,
    required this.photo,
    super.key,
    this.canChangeProfilePicture = false,
    this.size = 100,
  });

  final bool canChangeProfilePicture;
  final double size;
  final String name;
  final Uint8List? photo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          if (photo != null || name.isNotEmpty) {
            ProfilePhotoViewer.show(
              context: context,
              imageBytes: photo,
              name: name,
            );
          }
        },
        overlayColor: WidgetStateProperty.all(
          context.colorScheme.primary.withOpacity(1),
        ),
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border.all(
              color: context.colorScheme.primaryContainer,
            ),
            shape: BoxShape.circle,
            image: photo != null
                ? DecorationImage(
                    image: MemoryImage(photo!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: ImageWithPlaceholder(
            photo: photo,
            name: name,
            isLargeTitle: true,
          ),
        ),
      ),
    );
  }
}
