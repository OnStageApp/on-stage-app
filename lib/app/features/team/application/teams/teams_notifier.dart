import 'package:on_stage_app/app/features/team/application/teams/teams_state.dart';
import 'package:on_stage_app/app/features/team/data/team_repository.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'teams_notifier.g.dart';

@riverpod
class TeamsNotifier extends _$TeamsNotifier {
  late final TeamRepository _teamRepository;

  @override
  TeamsState build() {
    final dio = ref.watch(dioProvider);
    _teamRepository = TeamRepository(dio);
    return const TeamsState();
  }

  Future<void> getTeams() async {
    state = state.copyWith(isLoading: true);
    final teamsWithCurrentTeamId = await _teamRepository.getTeams();
    state = state.copyWith(
      isLoading: false,
      teams: teamsWithCurrentTeamId.teams,
      currentTeamId: teamsWithCurrentTeamId.currentTeamId,
    );
  }

  Future<void> setCurrentTeam(String teamId) async {
    state = state.copyWith(
      currentTeamId: teamId,
    );
    await _teamRepository.setCurrentTeam(teamId);
  }
}
