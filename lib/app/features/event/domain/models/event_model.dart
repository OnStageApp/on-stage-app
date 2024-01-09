import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_item/event_item_model.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@Freezed()
class EventModel with _$EventModel {
  const factory EventModel({
    required String id,
    required String name,
    required DateTime date,
    required List<DateTime> rehearsalDates,
    required List<String> staggersId,
    required List<String> adminsId,
    required List<EventItem> eventItems,
    required String location,
    String? imageUrl,
  }) = _Event;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
}
