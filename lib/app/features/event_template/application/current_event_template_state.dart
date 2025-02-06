import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event_template/domain/event_template.dart';

part 'current_event_template_state.freezed.dart';

@freezed
class CurrentEventTemplateState with _$CurrentEventTemplateState {
  const factory CurrentEventTemplateState({
    EventTemplate? eventTemplate,
    @Default(false) bool isLoading,
    Object? error,
  }) = _CurrentEventTemplateState;
}
