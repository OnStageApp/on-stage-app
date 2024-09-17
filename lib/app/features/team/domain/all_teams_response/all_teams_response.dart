import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/team/domain/team.dart';

part 'all_teams_response.freezed.dart';
part 'all_teams_response.g.dart';

@freezed
class AllTeamsResponse with _$AllTeamsResponse {
  const factory AllTeamsResponse({
    required List<Team> teams,
    required String currentTeamId,
  }) = _AllTeamsResponse;

  factory AllTeamsResponse.fromJson(Map<String, dynamic> json) =>
      _$AllTeamsResponseFromJson(json);
}
