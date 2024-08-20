import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/event/domain/models/create_event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_overview_model.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:on_stage_app/app/utils/patch_operation.dart';
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
  Future<EventModel> getEventById(@Path('eventId') String eventId);

  @POST(API.events)
  Future<CreateEventModel> createEvent(@Body() CreateEventModel event);

  @PATCH(API.eventById)
  Future<CreateEventModel> updateEvent(
    @Path('id') String eventId,
    @Body() List<PatchOperation> operations,
  );

// @GET(API.getEvents)
// Future<List<StagerOverview>> getStagers() async {
//   final stagers = await Future.delayed(
//     const Duration(seconds: 1),
//     () => StagersDummy.stagers,
//   );
//   return stagers;
// }
}
