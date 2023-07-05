import 'package:flutter/material.dart';
import 'package:on_stage_app/app/shared/stage_tile.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongAuthorTile extends StatelessWidget {
  const SongAuthorTile({
    required this.title,
    required this.description,
    required this.chord,
    super.key,
  });

  final String title;
  final String description;
  final String chord;

  @override
  Widget build(BuildContext context) {
    return StageTile(
      title: title,
      description: description,
      trailing: Container(
        padding: const EdgeInsets.symmetric(
            vertical: Insets.extraSmall, horizontal: Insets.small),
        decoration: BoxDecoration(
          color: context.colorScheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Text(
          chord,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: Colors.white),
          maxLines: 1,
        ),
      ),
    );
  }
}
