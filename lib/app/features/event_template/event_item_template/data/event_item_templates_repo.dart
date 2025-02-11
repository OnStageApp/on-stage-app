import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item_create.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_items_request.dart';
import 'package:on_stage_app/app/features/event_items/domain/update_event_item_index.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_item_templates_repo.g.dart';

@RestApi()
abstract class EventItemTemplatesRepo {
  factory EventItemTemplatesRepo(Dio dio) = _EventItemTemplatesRepo;

  @POST(API.eventItems)
  Future<List<EventItem>> addEventItems(
    @Body() EventItemsRequest eventItemsRequest,
  );

  @POST(API.createEventItemMoment)
  Future<EventItem> addMomentItem(
    @Body() EventItemCreate eventItemRequest,
  );

  @GET(API.eventItems)
  Future<List<EventItem>> getEventItems(@Query('eventId') String eventId);

  @PUT(API.eventItems)
  Future<List<EventItem>> updateEventItems(
    @Body() EventItemsRequest eventItemsRequest,
  );

  @PUT(API.updateEventItem)
  Future<EventItem> updateEventItem(
    @Path('id') String id,
    @Body() EventItemCreate eventItemRequest,
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

  @PUT(API.updateEventItemIndexes)
  Future<void> updateEventItemIndexes(
    @Body() List<UpdateEventItemIndex> updateEventItemIndex,
  );

  @DELETE(API.deleteEventId)
  Future<void> deleteEventItem(
    @Path('id') String id,
  );
}
