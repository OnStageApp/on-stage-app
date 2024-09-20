import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/enums/event_status_enum.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@Freezed()
class EventModel with _$EventModel {
  const factory EventModel({
    String? id,
    String? name,
    DateTime? dateTime,
    String? location,
    EventStatus? eventStatus,
  }) = _Event;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
}
