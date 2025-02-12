import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event_template/event_template/domain/event_template.dart';
import 'package:on_stage_app/app/features/stager_template/domain/stager_template.dart';

part 'current_event_template_state.freezed.dart';

@freezed
class CurrentEventTemplateState with _$CurrentEventTemplateState {
  const factory CurrentEventTemplateState({
    EventTemplate? eventTemplate,
    List<StagerTemplate>? stagerTemplates,
    @Default(false) bool isLoading,
    Object? error,
  }) = _CurrentEventTemplateState;
}
