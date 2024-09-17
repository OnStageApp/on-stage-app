import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/team/domain/team.dart';

part 'team_state.freezed.dart';

@freezed
class TeamState with _$TeamState {
  const factory TeamState({
    Team? currentTeam,
    @Default(false) bool isLoading,
  }) = _TeamState;
}
