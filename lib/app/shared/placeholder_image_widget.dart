import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/name_utils.dart';

class PlaceholderImageWidget extends StatelessWidget {
  const PlaceholderImageWidget({
    required this.name,
    this.isLargeTitle = false,
    this.textColor,
    super.key,
  });

  final String name;
  final bool isLargeTitle;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: name.isNotEmpty
          ? Text(
              NameUtils.getInitials(name),
              textAlign: TextAlign.center,
              style: isLargeTitle
                  ? context.textTheme.titleLarge?.copyWith(
                      fontSize: 42,
                      color: textColor ?? context.colorScheme.onSurface,
                    )
                  : context.textTheme.titleSmall?.copyWith(
                      color: textColor ?? context.colorScheme.onSurface,
                    ),
            )
          : Icon(
              Icons.person,
              color: textColor ?? context.colorScheme.onSurface,
            ),
    );
  }
}
