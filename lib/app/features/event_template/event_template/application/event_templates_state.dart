import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event_template/event_template/domain/event_template.dart';

part 'event_templates_state.freezed.dart';

@freezed
class EventTemplatesState with _$EventTemplatesState {
  const factory EventTemplatesState({
    @Default([]) List<EventTemplate> eventTemplates,
    @Default(false) bool isLoading,
    Object? error,
  }) = _EventTemplatesState;
}
