import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/groups/shared/domain/group_base.dart';

part 'group_event.freezed.dart';
part 'group_event.g.dart';

@freezed
class GroupEvent with _$GroupEvent implements GroupBase {
  const factory GroupEvent({
    required String id, // from GroupBase
    required String name, // from GroupBase
    @Default(0) int membersCount, // from GroupBase
    @Default([]) List<String>? stagersWithPhoto, // from GroupBase
    @JsonKey(includeFromJson: false)
    List<Uint8List>? profilePictures, // from GroupBase
    @Default(0) int confirmedCount, // additional field specific to GroupEvent
  }) = _GroupEvent;

  factory GroupEvent.fromJson(Map<String, dynamic> json) =>
      _$GroupEventFromJson(json);
}
