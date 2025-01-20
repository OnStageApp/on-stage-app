import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item.dart';

part 'event_item_create.freezed.dart';
part 'event_item_create.g.dart';

@Freezed()
class EventItemCreate with _$EventItemCreate {
  const factory EventItemCreate({
    required String? name,
    required int? index,
    required String? eventId,
    String? description,
    @DurationConverter() Duration? duration,
    List<String>? assignedStagerIds,
  }) = _EventItemCreate;

  const EventItemCreate._();

  factory EventItemCreate.fromEventItem(EventItem eventItem) => EventItemCreate(
        name: eventItem.name,
        index: eventItem.index,
        eventId: eventItem.eventId,
        description: eventItem.description,
        duration: eventItem.duration,
        assignedStagerIds: eventItem.assignedTo?.map((e) => e.id).toList(),
      );

  factory EventItemCreate.fromJson(Map<String, dynamic> json) =>
      _$EventItemCreateFromJson(json);
}

class DurationConverter implements JsonConverter<Duration?, int?> {
  const DurationConverter();

  @override
  Duration? fromJson(int? json) {
    if (json == null) return Duration.zero;
    return Duration(milliseconds: json);
  }

  @override
  int? toJson(Duration? duration) {
    if (duration == null) return 0;
    return duration.inMilliseconds;
  }
}
