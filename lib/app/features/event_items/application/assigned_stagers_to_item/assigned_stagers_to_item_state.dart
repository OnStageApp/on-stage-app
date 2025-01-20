import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_overview.dart';

part 'assigned_stagers_to_item_state.freezed.dart';

@Freezed()
class AssignedStagersToItemState with _$AssignedStagersToItemState {
  const factory AssignedStagersToItemState({
    @Default(false) bool isLoading,
    @Default([]) List<StagerOverview> selectedStagers,
  }) = _AssignedStagersToItemState;
}
