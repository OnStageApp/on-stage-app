import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item_create.dart';

part 'event_items_request.freezed.dart';
part 'event_items_request.g.dart';

@Freezed()
class EventItemsRequest with _$EventItemsRequest {
  const factory EventItemsRequest({
    required List<EventItemCreate> eventItems,
    required String eventId,
  }) = _EventItemsRequest;

  factory EventItemsRequest.fromJson(Map<String, dynamic> json) =>
      _$EventItemsRequestFromJson(json);
}
