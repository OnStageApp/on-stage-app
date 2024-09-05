import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/enums/event_status_enum.dart';
import 'package:on_stage_app/app/features/event/domain/models/rehearsal/rehearsal_model.dart';

part 'create_event_model.freezed.dart';
part 'create_event_model.g.dart';

@Freezed()
class CreateEventModel with _$CreateEventModel {
  const factory CreateEventModel({
    required String name,
    required DateTime? dateTime,
    required String location,
    required EventStatus eventStatus,
    required List<String> userIds,
    required List<RehearsalModel> rehearsals,
  }) = _CreateEventModel;

  factory CreateEventModel.fromJson(Map<String, dynamic> json) =>
      _$CreateEventModelFromJson(json);
}
