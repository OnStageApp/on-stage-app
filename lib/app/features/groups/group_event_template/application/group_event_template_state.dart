import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/groups/group_event_template/domain/group_event_template.dart';

part 'group_event_template_state.freezed.dart';

@freezed
class GroupEventTemplateState with _$GroupEventTemplateState {
  const factory GroupEventTemplateState({
    @Default([]) List<GroupEventTemplate> groupEventTemplates,
    @Default(false) bool isLoading,
    Object? error,
  }) = _GroupEventTemplateState;
}
