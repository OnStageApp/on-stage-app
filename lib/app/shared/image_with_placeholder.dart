import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_stage_app/app/shared/placeholder_image_widget.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/list_utils.dart';

class ImageWithPlaceholder extends StatelessWidget {
  const ImageWithPlaceholder({
    super.key,
    this.photo,
    this.name = '',
    this.isLargeTitle = false,
  });

  final Uint8List? photo;
  final String name;
  final bool isLargeTitle;

  @override
  Widget build(BuildContext context) {
    final hasValidPhoto = photo?.isNotNullOrEmpty ?? false;
    final hasName = name.isNotEmpty;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: context.colorScheme.onPrimaryFixedVariant,
        border: Border.all(
          color: context.colorScheme.surfaceTint,
        ),
        shape: BoxShape.circle,
        image: hasValidPhoto
            ? DecorationImage(
                image: MemoryImage(photo!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: !hasValidPhoto
          ? hasName
              ? PlaceholderImageWidget(
                  title: name,
                  isLargeTitle: isLargeTitle,
                )
              : Icon(
                  Icons.person,
                  color: context.colorScheme.outline.withOpacity(0.7),
                )
          : null,
    );
  }
}
