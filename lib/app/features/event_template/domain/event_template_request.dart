import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_template_request.freezed.dart';
part 'event_template_request.g.dart';

@Freezed()
class EventTemplateRequest with _$EventTemplateRequest {
  const factory EventTemplateRequest({
    String? id,
    String? name,
    String? location,
    @Default([]) List<int> reminderDays,
  }) = _EventTemplateRequest;

  factory EventTemplateRequest.fromJson(Map<String, dynamic> json) =>
      _$EventTemplateRequestFromJson(json);
}
