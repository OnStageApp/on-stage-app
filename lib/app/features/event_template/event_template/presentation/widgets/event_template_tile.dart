import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventTemplateTile extends StatelessWidget {
  const EventTemplateTile({
    required this.title,
    required this.location,
    required this.onTap,
    super.key,
  });

  final String title;
  final String location;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          backgroundColor: context.colorScheme.onSurfaceVariant,
          overlayColor: context.colorScheme.outline.withAlpha(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                  ),
                  Text(
                    location,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: context.colorScheme.surfaceDim,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: context.isDarkMode
                    ? const Color(0xFF43474E)
                    : context.colorScheme.surface,
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Icon(
                LucideIcons.chevron_right,
                size: 20,
                color: Color(0xFF8E9199),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
