import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item_create.dart';
import 'package:on_stage_app/app/features/event_items/domain/item_base.dart';

part 'event_item_template.freezed.dart';
part 'event_item_template.g.dart';

@Freezed()
class EventItemTemplate with _$EventItemTemplate implements ItemBase {
  const factory EventItemTemplate({
    required String id,
    String? name,
    String? description,
    int? index,
    String? eventTemplateId,
    @DurationConverter() @Default(Duration.zero) Duration? duration,
  }) = _EventItemTemplate;

  factory EventItemTemplate.fromJson(Map<String, dynamic> json) =>
      _$EventItemTemplateFromJson(json);
}
