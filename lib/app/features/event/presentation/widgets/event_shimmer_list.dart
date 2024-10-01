import 'package:flutter/material.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:shimmer/shimmer.dart';

class EventShimmerList extends StatelessWidget {
  const EventShimmerList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            // Featured Event Shimmer
            return Shimmer.fromColors(
              baseColor: context.colorScheme.onSurfaceVariant.withOpacity(0.3),
              highlightColor: context.colorScheme.onSurfaceVariant,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 86),
                child: Container(
                  height: 174, // Adjust this to match your FeaturedEvent height
                  decoration: BoxDecoration(
                    color: context.colorScheme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            );
          }
          // Regular Event Shimmer
          return Shimmer.fromColors(
            baseColor: context.colorScheme.onSurfaceVariant.withOpacity(0.3),
            highlightColor: context.colorScheme.onSurfaceVariant,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: Insets.normal,
              ),
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
        childCount: 11,
      ),
    );
  }
}
