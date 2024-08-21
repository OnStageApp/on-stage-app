import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@Freezed()
class EventModel with _$EventModel {
  const factory EventModel({
    required String id,
    required String? name,
    required DateTime? date,
    required List<DateTime>? rehearsalDates,
    required List<EventItem>? eventItems,
    required String location,
  }) = _Event;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
}
