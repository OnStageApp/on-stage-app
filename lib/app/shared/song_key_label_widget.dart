import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongKeyLabelWidget extends StatelessWidget {
  const SongKeyLabelWidget({
    required this.songKey,
    super.key,
  });

  final String songKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          songKey ?? '',
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: const Color(0xFF7F818B)),
        ),
      ),
    );
  }
}
