import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/enums/event_status_enum.dart';

part 'event_overview_model.freezed.dart';
part 'event_overview_model.g.dart';

@Freezed()
class EventOverview with _$EventOverview {
  const factory EventOverview({
    required String id,
    required String? name,
    required String? dateTime,
    required EventStatus? eventStatus,
  }) = _EventOverview;

  factory EventOverview.fromJson(Map<String, dynamic> json) =>
      _$EventOverviewFromJson(json);
}
