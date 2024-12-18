import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_items_request.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'event_items_repository.g.dart';

@RestApi()
abstract class EventItemsRepository {
  factory EventItemsRepository(Dio dio) = _EventItemsRepository;

  @POST(API.eventItems)
  Future<List<EventItem>> addEventItems(
    @Body() EventItemsRequest eventItemsRequest,
  );

  @GET(API.eventItems)
  Future<List<EventItem>> getEventItems(@Query('eventId') String eventId);

  @PUT(API.eventItems)
  Future<List<EventItem>> updateEventItems(
    @Body() EventItemsRequest eventItemsRequest,
  );

  @GET(API.leadVocalsByEventItemId)
  Future<List<Stager>> getLeadVocals(
    @Path('id') String id,
  );

  @PUT(API.leadVocalsByEventItemId)
  Future<void> updateLeadVocals(
    @Path('id') String id,
    @Body() List<String> stagerIds,
  );

  @DELETE(API.leadVocalsByEventItemIdAndStagerId)
  Future<void> deleteLeadVocals(
    @Path('id') String id,
    @Path('stagerId') String stagerId,
  );
}
