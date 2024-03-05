import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:on_stage_app/app/dummy_data/participants_dummy.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_overview_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager_overview.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_repository.g.dart';

@riverpod
class EventRepository extends _$EventRepository {
  @override
  FutureOr<dynamic> build() {}

  // Future<List<SongModel>> fetchPlaylist() async {
  //   final playlist = await Future.delayed(
  //     const Duration(seconds: 1),
  //     () => SongDummy.playlist,
  //   );
  //   return playlist;
  // }

  // Future<List<ParticipantProfile>> fetchParticipants() async {
  //   final participants = await Future.delayed(
  //     const Duration(seconds: 1),
  //         () => ParticipantsDummy.participants,
  //   );
  //   return participants;
  // }

  Future<List<StagerOverview>> getStagers() async {
    final stagers = await Future.delayed(
      const Duration(seconds: 1),
      () => StagersDummy.stagers,
    );
    return stagers;
  }

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
    } on HttpException catch (e, s) {
      logger.e('Failed fetching events: $e with stacktrace: $s');
    }
    return [];
  }

  Future<EventModel?> getEventById(String eventId) async {
    try {
      final uri = API.getEvent(eventId);
      final response = await http.get(uri);
      logger.fetchedRequestResponse(
        'event',
        response.statusCode,
        response.body,
      );

      switch (response.statusCode) {
        case 200:
          final eventJson = jsonDecode(response.body) as Map<String, dynamic>;
          final event = EventModel.fromJson(eventJson);
          return event;
        case 404:
          logger.e('Event not found.');
          return null;
        default:
          logger.e('Internal server error, please try again later.');
      }
    } on HttpException catch (e, s) {
      logger.e('Failed fetching event: $e with stacktrace: $s');
    }
    return null;
  }

  Future<String?> createEvent(EventModel newEvent) async {
    var eventMap = newEvent.toJson();
    eventMap.remove('id');
    eventMap.remove('imageUrl');
    eventMap.remove('adminsId');
    eventMap.remove('eventItemIds');
    eventMap.remove('staggersId');
    // eventMap.remove('rehearsalDates');
    final response = await http.post(
      API.createEvent,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      // Set the Content-Type header
      body: jsonEncode(eventMap),
    );
    logger.postRequestResponse('event', response.statusCode, response.body);
    try {
      switch (response.statusCode) {
        case 200:
          final eventId = response.body;
          return eventId;
        default:
          logger.e('Internal server error, please try again later.');
      }
    } on HttpException catch (e, s) {
      logger.e('Failed fetching events: $e with stacktrace: $s');
    }
    return null;
  }
}
