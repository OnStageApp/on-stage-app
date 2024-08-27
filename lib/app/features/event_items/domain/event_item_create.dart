import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';

part 'event_item_create.freezed.dart';
part 'event_item_create.g.dart';

@Freezed()
class EventItemCreate with _$EventItemCreate {
  const factory EventItemCreate({
    required String? name,
    required int? index,
    String? songId,
  }) = _EventItemCreate;

  const EventItemCreate._();

  factory EventItemCreate.fromEventItem(EventItem eventItem) => EventItemCreate(
        name: eventItem.name,
        index: eventItem.index,
        songId: eventItem.song?.id,
      );

  factory EventItemCreate.fromJson(Map<String, dynamic> json) =>
      _$EventItemCreateFromJson(json);
}
