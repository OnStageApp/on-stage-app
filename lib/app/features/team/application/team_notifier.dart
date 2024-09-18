import 'dart:async';

import 'package:on_stage_app/app/features/team/application/team_state.dart';
import 'package:on_stage_app/app/features/team/data/team_repository.dart';
import 'package:on_stage_app/app/features/team/domain/team_request/team_request.dart';
import 'package:on_stage_app/app/features/team_member/application/current_team_member/current_team_member_notifier.dart';
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

  Future<void> getCurrentTeam() async {
    state = state.copyWith(isLoading: true);
    final currentTeam = await _teamRepository.getCurrentTeam();
    unawaited(
      ref.read(currentTeamMemberNotifierProvider.notifier).getTeamMember(),
    );
    state = state.copyWith(isLoading: false, currentTeam: currentTeam);
  }

  Future<void> createTeam(TeamRequest team) async {
    state = state.copyWith(isLoading: true);
    final createdTeam = await _teamRepository.createTeam(team);
    state = state.copyWith(isLoading: false, currentTeam: createdTeam);
  }
}
