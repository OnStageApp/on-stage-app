import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/groups/domain/group.dart';

part 'group_state.freezed.dart';

@freezed
class GroupState with _$GroupState {
  const factory GroupState({
    @Default([]) List<Group> groups,
    @Default(false) bool isLoading,
    Object? error,
  }) = _GroupState;
}
