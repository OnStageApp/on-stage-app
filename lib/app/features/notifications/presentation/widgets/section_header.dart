// section_header.dart
import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.isUnread, super.key});

  final bool isUnread;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isUnread)
          Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              Icons.circle,
              size: 12,
              color: context.colorScheme.error,
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            isUnread ? 'Unread' : 'Older',
            style: context.textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
