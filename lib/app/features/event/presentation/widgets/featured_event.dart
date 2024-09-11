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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.normal),
      child: Column(
        children: [
          const SizedBox(height: Insets.medium),
          SizedBox(
            height: 174,
            child: EventTileEnhanced(
              isEventEmpty: event == null,
              title: event?.name ?? 'No upcoming events',
              locationName:
                  event?.location ?? 'You don\'t have any published events',
              dateTime: event?.dateTime,
              onTap: () {
                if (event == null) {
                  context.pushNamed(AppRoute.addEvent.name);
                  return;
                }
                context.pushNamed(
                  AppRoute.eventDetails.name,
                  queryParameters: {'eventId': event?.id},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
