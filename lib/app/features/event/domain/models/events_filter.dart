import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/enums/event_search_type.dart';

part 'events_filter.freezed.dart';
part 'events_filter.g.dart';

@Freezed()
class EventsFilter with _$EventsFilter {
  const factory EventsFilter({
    String? searchValue,
    EventSearchType? eventSearchType,
    int? offset,
    int? limit,
    bool? hasMore,
  }) = _EventsFilter;

  factory EventsFilter.fromJson(Map<String, dynamic> json) =>
      _$EventsFilterFromJson(json);
}
