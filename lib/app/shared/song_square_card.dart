import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongSquareCard extends StatelessWidget {
  const SongSquareCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: const Color(0xFFF9F9FC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0xFFe9eaec),
            blurRadius: 10,
            offset: Offset(0, 6),
            spreadRadius: 4,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/band1.png'),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Yahweh',
            style: context.textTheme.titleMedium,
          ),
          Text(
            'El-Shaddai Worship',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.primary,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.bookmark_border,
                color: context.colorScheme.outline,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '125',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.outline,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.play_circle,
                color: context.colorScheme.outline,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '30',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.outline,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
