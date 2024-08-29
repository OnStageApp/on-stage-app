import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_overview_model.dart';

part 'events_response.freezed.dart';
part 'events_response.g.dart';

@freezed
class EventsResponse with _$EventsResponse {
  const factory EventsResponse({
    required List<EventOverview> events,
    required bool hasMore,
  }) = _EventsResponse;

  factory EventsResponse.fromJson(Map<String, dynamic> json) =>
      _$EventsResponseFromJson(json);
}
