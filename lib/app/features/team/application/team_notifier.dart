import 'package:on_stage_app/app/features/team/application/team_state.dart';
import 'package:on_stage_app/app/features/team/data/team_repository.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'team_notifier.g.dart';

@riverpod
class TeamNotifier extends _$TeamNotifier {
  late final TeamRepository _teamRepository;

  @override
  TeamState build() {
    final dio = ref.read(dioProvider);
    _teamRepository = TeamRepository(dio);
    return const TeamState();
  }

  Future<void> getTeams() async {
    state = state.copyWith(isLoading: true);
    final teams = await _teamRepository.getTeams();
    state = state.copyWith(
      isLoading: false,
      teams: teams,
    );
  }
}
