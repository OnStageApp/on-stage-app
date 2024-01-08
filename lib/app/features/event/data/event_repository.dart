import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_overview_model.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_repository.g.dart';

@riverpod
class EventRepository extends _$EventRepository {
  @override
  FutureOr<dynamic> build() {}

  Future<List<EventOverview>> getEvents({
    String? search,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final uri = API.getEvents(startDate, endDate, search);
      final response = await http.get(uri);
      logger.fetchedRequestResponse(
        'events',
        response.statusCode,
        response.body,
      );

      switch (response.statusCode) {
        case 200:
          final eventsJsn = jsonDecode(response.body) as List<dynamic>;
          final events = eventsJsn
              .map(
                (eventJson) => EventOverview.fromJson(
                  eventJson as Map<String, dynamic>,
                ),
              )
              .toList();

          return events;
        default:
          logger.e('Internal server error, please try again later.');
      }
    } on IOException catch (e, s) {
      logger.e('Failed fetching events: $e with stacktrace: $s');
    }
    return [];
  }

  Future<EventModel?> createEvent(EventModel newEvent) async {
    final response = await http.post(API.createEvent, body: newEvent.toJson());
    logger.postRequestResponse('event', response.statusCode, response.body);
    try {
      switch (response.statusCode) {
        case 200:
          final eventJson = jsonDecode(response.body) as Map<String, dynamic>;
          final event = EventModel.fromJson(eventJson);
          return event;
        default:
          logger.e('Internal server error, please try again later.');
      }
    } on IOException catch (e, s) {
      logger.e('Failed fetching events: $e with stacktrace: $s');
    }
    return null;
  }
}
