import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_template.freezed.dart';
part 'event_template.g.dart';

@Freezed()
class EventTemplate with _$EventTemplate {
  const factory EventTemplate({
    String? id,
    String? name,
    DateTime? dateTime,
    String? location,
    @Default([]) List<int> reminders,
  }) = _Event;

  factory EventTemplate.fromJson(Map<String, dynamic> json) =>
      _$EventTemplateFromJson(json);
}
