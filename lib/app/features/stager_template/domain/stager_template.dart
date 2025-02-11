import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_base.dart';

part 'stager_template.freezed.dart';
part 'stager_template.g.dart';

@Freezed()
class StagerTemplate with _$StagerTemplate implements StagerBase {
  const factory StagerTemplate({
    required String id,
    required String? name,
    required String? userId,
    String? groupId,
    String? positionId,
    @JsonKey(includeFromJson: false) Uint8List? profilePicture,
  }) = _StagerTemplate;

  factory StagerTemplate.fromJson(Map<String, dynamic> json) =>
      _$StagerTemplateFromJson(json);
}
