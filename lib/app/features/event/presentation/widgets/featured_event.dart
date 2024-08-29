import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/event_tile_enhanced.dart';
import 'package:on_stage_app/app/theme/theme.dart';

class FeaturedEvent extends StatelessWidget {
  const FeaturedEvent({this.event, super.key});

  final EventModel? event;

  @override
  Widget build(BuildContext context) {
    if (event == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.normal),
      child: Column(
        children: [
          const SizedBox(height: Insets.medium),
          SizedBox(
            height: 174,
            child: EventTileEnhanced(
              isSingleEvent: true,
              title: event!.name ?? '',
              locationName: event!.location ?? '',
              dateTime: event!.dateTime,
              onTap: () {
                context.pushNamed(
                  AppRoute.eventDetails.name,
                  queryParameters: {'eventId': event!.id},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
