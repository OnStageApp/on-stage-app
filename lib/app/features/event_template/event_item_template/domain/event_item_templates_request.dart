import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event_template/event_item_template/domain/event_item_template_create.dart';

part 'event_item_templates_request.freezed.dart';
part 'event_item_templates_request.g.dart';

@freezed
class EventItemTemplatesRequest with _$EventItemTemplatesRequest {
  const factory EventItemTemplatesRequest({
    required List<EventItemTemplateCreate> eventItems,
    required String eventTemplateId,
  }) = _EventItemTemplatesRequest;

  factory EventItemTemplatesRequest.fromJson(Map<String, dynamic> json) =>
      _$EventItemTemplatesRequestFromJson(json);
}
