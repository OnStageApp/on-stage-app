import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/team/domain/team.dart';

part 'teams_state.freezed.dart';

@freezed
class TeamsState with _$TeamsState {
  const factory TeamsState({
    @Default([]) List<Team> teams,
    @Default('') String currentTeamId,
    @Default(false) bool isLoading,
  }) = _TeamsState;
}
