import 'package:flutter/material.dart';
import 'package:on_stage_app/app/shared/stage_tile.dart';

class EventTileEnhanced extends StatelessWidget {
  const EventTileEnhanced({
    required this.title,
    required this.description,
    super.key,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    //TODO: Do not use StageTile anymore, too much params
    return StageTile(
      title: title,
      description: description,
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.white,
      ),
      backgroundImage:
          const AssetImage('assets/images/event_tile_background.png'),
      backgroundGradient: const LinearGradient(
        colors: [
          Color(0xFF6F97D4),
          Color(0xFFD9C8EB),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }
}
