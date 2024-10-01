import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item_type.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';

part 'event_item.freezed.dart';
part 'event_item.g.dart';

@Freezed()
class EventItem with _$EventItem {
  const factory EventItem({
    String? id,
    String? name,
    int? index,
    EventItemType? eventType,
    SongOverview? song,
    String? eventId,
    @Default([]) List<Stager>? leadVocals,
  }) = _EventItem;

  const EventItem._();

  factory EventItem.fromSong(SongOverview song, int index) => EventItem(
        name: song.title,
        index: index,
        song: song,
        eventType: EventItemType.song,
      );

  factory EventItem.fromMoment(String momentName, int index) => EventItem(
        name: momentName,
        index: index,
        eventType: EventItemType.other,
      );

  factory EventItem.fromJson(Map<String, dynamic> json) =>
      _$EventItemFromJson(json);
}
