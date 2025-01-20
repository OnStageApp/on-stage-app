import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_overview.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item_create.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item_type.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';

part 'event_item.freezed.dart';
part 'event_item.g.dart';

@Freezed()
class EventItem with _$EventItem {
  const factory EventItem({
    required String id,
    String? name,
    String? description,
    int? index,
    EventItemType? eventType,
    SongOverview? song,
    String? eventId,
    @Default([]) List<StagerOverview>? assignedTo,
    @DurationConverter() @Default(Duration.zero) Duration? duration,
  }) = _EventItem;

  factory EventItem.fromJson(Map<String, dynamic> json) =>
      _$EventItemFromJson(json);
}
