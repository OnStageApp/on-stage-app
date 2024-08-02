import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ParticipantListingItem extends StatefulWidget {
  const ParticipantListingItem({
    required this.name,
    required this.assetPath,
    super.key,
  });

  final String name;
  final String assetPath;

  @override
  State<ParticipantListingItem> createState() => _ParticipantListingItemState();
}

class _ParticipantListingItemState extends State<ParticipantListingItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 8,
      ),
      child: Row(
        children: [
          Image.asset(
            widget.assetPath,
            width: 32,
            height: 32,
          ),
          const SizedBox(width: 12),
          Text(
            widget.name,
            style: context.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
