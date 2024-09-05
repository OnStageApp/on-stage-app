import 'package:flutter/material.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:shimmer/shimmer.dart';

class EventShimmerList extends StatelessWidget {
  const EventShimmerList({
    required this.isSearchContent,
    super.key,
  });

  final bool isSearchContent;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0 && !isSearchContent) {
            // Featured Event Shimmer
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 86),
                child: Container(
                  height: 174, // Adjust this to match your FeaturedEvent height
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            );
          }
          // Regular Event Shimmer
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: Insets.normal,
              ),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          );
        },
        childCount: 11, // 1 for FeaturedEvent + 10 regular events
      ),
    );
  }
}
