import 'dart:async';

import 'package:on_stage_app/app/features/team_member/application/current_team_member/current_team_member_state.dart';
import 'package:on_stage_app/app/features/team_member/data/team_member_repository.dart';
import 'package:on_stage_app/app/features/team_member/domain/edit_team_member_request/edit_team_member_request.dart';
import 'package:on_stage_app/app/features/team_member/domain/position_enum/position.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_team_member_notifier.g.dart';

@Riverpod(keepAlive: true)
class CurrentTeamMemberNotifier extends _$CurrentTeamMemberNotifier {
  TeamMemberRepository? _teamMemberRepository;

  TeamMemberRepository get teamMemberRepository {
    _teamMemberRepository ??= TeamMemberRepository(ref.read(dioProvider));
    return _teamMemberRepository!;
  }

  @override
  CurrentTeamMemberState build() {
    final dio = ref.read(dioProvider);
    _teamMemberRepository = TeamMemberRepository(dio);
    logger.i('CurrentTeamMemberNotifier initialized');
    return const CurrentTeamMemberState();
  }

  Future<void> initializeState() async {
    final teamMember = await teamMemberRepository.getCurrentTeamMember();

    state = state.copyWith(teamMember: teamMember);
  }

  Future<void> updateTeamMemberPosition(Position? position) async {
    final teamMemberId = state.teamMember?.id;
    if (teamMemberId == null) {
      await initializeState();
    }
    if (teamMemberId == null || position == null) return;
    state = state.copyWith(
      teamMember: state.teamMember?.copyWith(position: position),
    );
    final request = EditTeamMemberRequest(position: position);
    unawaited(
      teamMemberRepository.updateTeamMember(teamMemberId, request),
    );
  }
}
