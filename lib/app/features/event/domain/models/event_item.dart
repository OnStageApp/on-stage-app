import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_item.freezed.dart';
part 'event_item.g.dart';

@Freezed()
class EventItem with _$EventItem {
  const factory EventItem({
    required String? name,
    required int? index,
    required String? eventType,
    required String? songId,
  }) = _EventItem;

  factory EventItem.fromJson(Map<String, dynamic> json) =>
      _$EventItemFromJson(json);
}
