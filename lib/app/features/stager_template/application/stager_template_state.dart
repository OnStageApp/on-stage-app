import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/stager_template/domain/stager_template.dart';

part 'stager_template_state.freezed.dart';

@freezed
class StagerTemplateState with _$StagerTemplateState {
  const factory StagerTemplateState({
    @Default([]) List<StagerTemplate> stagerTemplates,
    @Default(false) bool isLoading,
    @Default(null) String? error,
  }) = _StagerTemplateState;
}
