import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_type_enum.dart';

part 'event_item.freezed.dart';
part 'event_item.g.dart';

@Freezed()
class EventItem with _$EventItem {
  // Private constructor for custom methods

  const factory EventItem({
    required String? name,
    required int? index,
    required EventTypeEnum? eventType,
    String? songId,
  }) = _EventItem;

  const EventItem._();

  factory EventItem.fromJson(Map<String, dynamic> json) =>
      _$EventItemFromJson(json);

  bool get isSong => songId != null;
}
