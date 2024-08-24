import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/event/domain/models/create_event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_overview_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/rehearsal/rehearsal_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/create_stager_request.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'events_repository.g.dart';

@RestApi(baseUrl: API.baseUrl)
abstract class EventsRepository {
  factory EventsRepository(Dio dio) = _EventsRepository;

  @GET(API.eventsByFilter)
  Future<List<EventOverview>> getEvents({
    @Query('startDate') String? startDate,
    @Query('endDate') String? endDate,
    @Query('search') String? search,
  });

  @GET(API.eventById)
  Future<EventModel> getEventById(@Path('id') String id);

  @GET(API.rehearsals)
  Future<List<RehearsalModel>> getRehearsalsByEventId(
    @Query('eventId') String eventId,
  );

  @GET(API.stagers)
  Future<List<Stager>> getStagersByEventId(
    @Query('eventId') String eventId,
  );

  @POST(API.events)
  Future<EventModel> createEvent(@Body() CreateEventModel event);

  @POST(API.stagers)
  Future<Stager> addStagerToEvent(
    @Body() CreateStagerRequest createStagerRequest,
  );

  @PUT(API.eventById)
  Future<EventModel> updateEvent(
    @Path('id') String eventId,
    @Body() EventModel event,
  );
}
