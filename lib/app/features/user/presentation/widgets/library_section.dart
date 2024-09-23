import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_notifier.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/resources/generated/assets.gen.dart';

class LibrarySection extends ConsumerWidget {
  const LibrarySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedSongs = ref.watch(songsNotifierProvider).savedSongs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Library',
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        Container(
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
                  '${savedSongs.length}',
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
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: context.colorScheme.onSurfaceVariant,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            title: Text(
              'Request a new song',
              style: context.textTheme.titleMedium!.copyWith(
                color: context.colorScheme.primary,
              ),
            ),
            trailing: _buildArrowWidget(context),
            onTap: () {
              showOnboardingOverlay(context);
            },
          ),
        ),
      ],
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
