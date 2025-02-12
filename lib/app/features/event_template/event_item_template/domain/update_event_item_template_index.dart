import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_event_item_template_index.freezed.dart';
part 'update_event_item_template_index.g.dart';

@freezed
class UpdateEventItemTemplateIndex with _$UpdateEventItemTemplateIndex {
  const factory UpdateEventItemTemplateIndex({
    required String eventItemTemplateId,
    required int index,
  }) = _UpdateEventItemTemplateIndex;

  factory UpdateEventItemTemplateIndex.fromJson(Map<String, dynamic> json) =>
      _$UpdateEventItemTemplateIndexFromJson(json);
}
