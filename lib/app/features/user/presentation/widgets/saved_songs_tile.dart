import 'package:flutter/material.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/resources/generated/assets.gen.dart';

class SavedSongsTile extends StatelessWidget {
  final int savedSongsCount;

  const SavedSongsTile({super.key, required this.savedSongsCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        title: Text(
          'Saved Songs',
          style: context.textTheme.titleMedium,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$savedSongsCount',
              style: context.textTheme.titleMedium!
                  .copyWith(color: context.colorScheme.outline),
            ),
            const SizedBox(width: 8),
            _buildArrowWidget(context),
          ],
        ),
        onTap: () {
          context.goNamed(AppRoute.favorites.name);
        },
      ),
    );
  }

  Widget _buildArrowWidget(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Center(
        child: Assets.icons.arrowForward.svg(),
      ),
    );
  }
}
