import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_overview_model.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'events_repository.g.dart';

@RestApi(baseUrl: API.baseUrl)
abstract class EventsRepository {
  factory EventsRepository(Dio dio) = _EventsRepository;

  @GET(API.getEvents)
  Future<List<EventOverview>> getEvents({
    @Query('startDate') String? startDate,
    @Query('endDate') String? endDate,
    @Query('search') String? search,
  });

  @GET(API.getEventById)
  Future<EventModel> getEventById(@Path('eventId') String eventId);

  @POST(API.createEvent)
  Future<EventModel> createEvent(@Body() EventModel event);

  // @GET(API.getEvents)
  // Future<List<StagerOverview>> getStagers() async {
  //   final stagers = await Future.delayed(
  //     const Duration(seconds: 1),
  //     () => StagersDummy.stagers,
  //   );
  //   return stagers;
  // }
}
