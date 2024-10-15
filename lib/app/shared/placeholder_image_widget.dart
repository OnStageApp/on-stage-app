import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/name_utils.dart';

class PlaceholderImageWidget extends StatelessWidget {
  const PlaceholderImageWidget({
    required this.title,
    this.isLargeTitle = false,
    super.key,
  });

  final String title;
  final bool isLargeTitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (title != null && title!.isNotEmpty)
          ? Text(
              NameUtils.getInitials(title),
              textAlign: TextAlign.center,
              style: isLargeTitle
                  ? context.textTheme.titleLarge?.copyWith(fontSize: 42)
                  : context.textTheme.titleSmall?.copyWith(),
            )
          : Icon(
              Icons.person,
              color: context.colorScheme.primaryContainer,
            ),
    );
  }
}
