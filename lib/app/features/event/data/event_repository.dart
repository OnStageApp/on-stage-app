import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:json_patch/json_patch.dart';
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

  Future<String?> createEvent(EventModel newEvent) async {
    final eventMap = newEvent.toJson();

    ///This is temporary, until we have a proper way to handle this
    eventMap
      ..remove('id')
      ..remove('imageUrl')
      ..remove('adminsId')
      ..remove('eventItemIds')
      ..remove('staggersId');

    final response = await http.post(
      API.createEvent,
      headers: API.getHeaders(),
      body: jsonEncode(eventMap),
    );
    logger.postRequestResponse(
      'event',
      response.statusCode,
      response.body,
    );
    try {
      switch (response.statusCode) {
        case 200:
          final eventId = response.body;
          return eventId;
        default:
          logger.e('Internal server error, please try again later.');
      }
    } on IOException catch (e, s) {
      logger.e('Failed fetching events: $e with stacktrace: $s');
    }
    return null;
  }

  Future<void> patchEvent({
    required EventModel oldEvent,
    required EventModel newEvent,
  }) async {
    final eventId = oldEvent.id;
    final diff = JsonPatch.diff(
      oldEvent.toJson(),
      newEvent.toJson(),
    );

    print('DIFF: $diff');
    print("DIFF: ${jsonEncode(diff)}");
    var diffed = jsonEncode(diff);
    var url = API.patchEvent(eventId);
    final response = await http.patch(
      url,
      headers: API.getHeaders(),
      body: diffed,
    );

    logger.postRequestResponse(
      'event',
      response.statusCode,
      response.body,
    );

    try {
      switch (response.statusCode) {
        case 200:
          return;
        default:
          logger.e('Internal server error, please try again later.');
      }
    } on IOException catch (e, s) {
      logger.e('Failed fetching events: $e with stacktrace: $s');
    }
  }
}
