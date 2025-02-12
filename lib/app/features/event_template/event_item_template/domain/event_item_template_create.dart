import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event_template/event_item_template/domain/event_item_template.dart';

part 'event_item_template_create.freezed.dart';
part 'event_item_template_create.g.dart';

@freezed
class EventItemTemplateCreate with _$EventItemTemplateCreate {
  const factory EventItemTemplateCreate({
    required String? name,
    required int? index,
    required String? eventTemplateId,
    String? description,
  }) = _EventItemTemplateCreate;

  const EventItemTemplateCreate._();

  factory EventItemTemplateCreate.fromEventItemTemplate(
    EventItemTemplate eventItemTemplate,
  ) =>
      EventItemTemplateCreate(
        eventTemplateId: eventItemTemplate.eventTemplateId,
        name: eventItemTemplate.name,
        index: eventItemTemplate.index,
        description: eventItemTemplate.description,
      );

  factory EventItemTemplateCreate.fromJson(Map<String, dynamic> json) =>
      _$EventItemTemplateCreateFromJson(json);
}
