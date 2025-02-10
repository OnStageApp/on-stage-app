import 'package:on_stage_app/app/features/team/application/teams/teams_state.dart';
import 'package:on_stage_app/app/features/team/data/team_repository.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/logger.dart';
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
    try {
      logger.i('Setting current team: $teamId');

      await _teamRepository.setCurrentTeam(teamId);

      state = state.copyWith(
        currentTeamId: teamId,
        isLoading: true,
      );

      logger.i('Successfully set current team to: $teamId');
    } catch (e, stackTrace) {
      logger.e('Failed to set current team', e, stackTrace);

      state = state.copyWith(
        isLoading: false,
        currentTeamId: state.currentTeamId,
      );

      rethrow;
    }
  }
}
