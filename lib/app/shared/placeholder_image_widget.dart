import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/name_utils.dart';

class PlaceholderImageWidget extends StatelessWidget {
  const PlaceholderImageWidget({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        NameUtils.getInitials(title),
        textAlign: TextAlign.center,
        style: context.textTheme.titleSmall,
      ),
    );
  }
}
