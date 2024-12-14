import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:shimmer/shimmer.dart';

class SongDetailShimmerWidget extends StatelessWidget {
  const SongDetailShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 12,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox.fromSize(
              size: const Size.fromHeight(36),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor:
                        context.colorScheme.onSurfaceVariant.withOpacity(0.3),
                    highlightColor: context.colorScheme.onSurfaceVariant,
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: context.colorScheme.onSurfaceVariant,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            _buildLyrics(false, context),
            const SizedBox(height: 12),
            _buildLyrics(true, context),
            const SizedBox(height: 12),
            _buildLyrics(false, context),
          ],
        ),
      ),
    );
  }

  Widget _buildLyrics(bool isDifferent, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 18),
            child: Row(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: 110,
                      height: 38,
                      child: Shimmer.fromColors(
                        baseColor: context.colorScheme.onSurfaceVariant
                            .withOpacity(0.3),
                        highlightColor: context.colorScheme.onSurfaceVariant,
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.colorScheme.onSurfaceVariant,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 4,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                if (isDifferent) ...[
                  const SizedBox(width: 12),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
          _buildLine(double.infinity),
          _buildLine(200),
          _buildLine(double.infinity),
          _buildLine(350),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildLine(double width) {
    return SizedBox(
      width: width,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          height: 23,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
