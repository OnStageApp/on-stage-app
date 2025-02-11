import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/create_stager_request.dart';

part 'create_all_stager_templates.freezed.dart';
part 'create_all_stager_templates.g.dart';

@Freezed()
class CreateAllStagerTemplates with _$CreateAllStagerTemplates {
  const factory CreateAllStagerTemplates({
    required String eventTemplateId,
    required List<CreateStagerRequest> stagerTemplates,
  }) = _CreateAllStagerTemplates;

  factory CreateAllStagerTemplates.fromJson(Map<String, dynamic> json) =>
      _$CreateAllStagerTemplatesFromJson(json);
}
