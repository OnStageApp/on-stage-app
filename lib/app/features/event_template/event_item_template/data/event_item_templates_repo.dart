import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/event_items/domain/update_event_item_index.dart';
import 'package:on_stage_app/app/features/event_template/event_item_template/domain/event_item_template.dart';
import 'package:on_stage_app/app/features/event_template/event_item_template/domain/event_item_template_create.dart';
import 'package:on_stage_app/app/features/event_template/event_item_template/domain/update_event_item_template_index.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'event_item_templates_repo.g.dart';

@RestApi()
abstract class EventItemTemplatesRepo {
  factory EventItemTemplatesRepo(Dio dio) = _EventItemTemplatesRepo;

//DONE
  @GET(API.getEventItemTemplates)
  Future<List<EventItemTemplate>> getEventItems(
    @Query('eventTemplateId') String eventTemplateId,
  );

  @POST(API.addEventItemTemplate)
  Future<EventItemTemplate> addMoment(
    @Body() EventItemTemplateCreate eventItemTemplateCreate,
  );

  @DELETE(API.deleteEventItemTemplate)
  Future<void> deleteEventItemTemplate(
    @Path('id') String id,
  );

  @PUT(API.updateEventItemTemplateIndexes)
  Future<void> updateEventItemTemplateIndexes(
    @Body() List<UpdateEventItemTemplateIndex> updateEventItemTemplateIndex,
  );

  @PUT(API.updateEventItemTemplate)
  Future<EventItemTemplate> updateEventItem(
    @Path('id') String id,
    @Body() EventItemTemplate eventItemRequest,
  );
}
