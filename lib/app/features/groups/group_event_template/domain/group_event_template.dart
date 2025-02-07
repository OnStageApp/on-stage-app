import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/groups/shared/domain/group_base.dart';

part 'group_event_template.freezed.dart';
part 'group_event_template.g.dart';

@freezed
class GroupEventTemplate with _$GroupEventTemplate implements GroupBase {
  const factory GroupEventTemplate({
    required String id,
    required String name,
    @Default(0) int membersCount,
    @Default([]) List<String>? stagersWithPhoto,
    @JsonKey(includeFromJson: false) List<Uint8List>? profilePictures,
  }) = _GroupEventTemplate;

  factory GroupEventTemplate.fromJson(Map<String, dynamic> json) =>
      _$GroupEventTemplateFromJson(json);
}
