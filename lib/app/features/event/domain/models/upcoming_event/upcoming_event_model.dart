import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/enums/event_status_enum.dart';

part 'upcoming_event_model.freezed.dart';
part 'upcoming_event_model.g.dart';

@Freezed()
class UpcomingEventModel with _$UpcomingEventModel {
  const factory UpcomingEventModel({
    String? id,
    String? name,
    DateTime? dateTime,
    String? location,
    EventStatus? eventStatus,
    List<String>? userIdsWithPhoto,
    @JsonKey(includeFromJson: false) @Default([]) List<Uint8List?> stagerPhotos,
    int? stagerCount,
  }) = _UpcomingEventModel;

  factory UpcomingEventModel.fromJson(Map<String, dynamic> json) =>
      _$UpcomingEventModelFromJson(json);
}
