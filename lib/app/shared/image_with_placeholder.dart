import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_stage_app/app/shared/placeholder_image_widget.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ImageWithPlaceholder extends StatelessWidget {
  const ImageWithPlaceholder({
    super.key,
    this.photo,
    this.name = '',
  });

  final Uint8List? photo;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        border: Border.all(
          color: context.colorScheme.primaryContainer,
        ),
        shape: BoxShape.circle,
        image: photo != null && photo!.isNotEmpty
            ? DecorationImage(
                image: MemoryImage(photo!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: photo == null || photo!.isEmpty
          ? PlaceholderImageWidget(title: name)
          : null,
    );
  }
}
