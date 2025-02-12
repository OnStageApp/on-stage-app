import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event_template/event_item_template/domain/event_item_template.dart';

part 'event_item_templates_state.freezed.dart';

@Freezed()
class EventItemTemplatesState with _$EventItemTemplatesState {
  const factory EventItemTemplatesState({
    @Default(false) bool isLoading,
    @Default([]) List<EventItemTemplate> eventItemTemplates,
    @Default(0) int currentIndex,
  }) = _EventItemTemplatesState;
}
