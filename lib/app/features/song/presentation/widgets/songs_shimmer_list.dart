import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:shimmer/shimmer.dart';

class SongsShimmerList extends StatelessWidget {
  const SongsShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Shimmer.fromColors(
            baseColor: context.colorScheme.onSurfaceVariant.withOpacity(0.3),
            highlightColor: context.colorScheme.onSurfaceVariant,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: context.colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          );
        },
        childCount: 10,
      ),
    );
  }
}
