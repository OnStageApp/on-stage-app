import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_item_model.freezed.dart';
part 'event_item_model.g.dart';

@Freezed()
class EventItem with _$EventItem {
  const factory EventItem({
    required String id,
    required String name,
    required EventTypeEnum eventType,
    required int index,
    String? songId,
  }) = _EventItem;

  factory EventItem.fromJson(Map<String, dynamic> json) =>
      _$EventItemFromJson(json);
}

enum EventTypeEnum { song, other }
