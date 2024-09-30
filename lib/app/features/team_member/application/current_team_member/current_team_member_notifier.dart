import 'dart:async';

import 'package:on_stage_app/app/app_data/app_data_controller.dart';
import 'package:on_stage_app/app/features/team_member/application/current_team_member/current_team_member_state.dart';
import 'package:on_stage_app/app/features/team_member/data/team_member_repository.dart';
import 'package:on_stage_app/app/features/team_member/domain/edit_team_member_request/edit_team_member_request.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member_role/team_member_role.dart';
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
    _initializeState();
    logger.i('CurrentTeamMemberNotifier initialized');
    return const CurrentTeamMemberState();
  }

  Future<void> _initializeState() async {
    final teamMember = await teamMemberRepository.getCurrentTeamMember();
    await setTeamMemberRoleToSharedPrefs(teamMember: teamMember);
    state = state.copyWith(teamMember: teamMember);
  }

  Future<void> setTeamMemberRoleToSharedPrefs({TeamMember? teamMember}) async {
    final newMember =
        teamMember ?? await teamMemberRepository.getCurrentTeamMember();

    await ref
        .read(appDataControllerProvider.notifier)
        .setMemberRole(newMember.role ?? TeamMemberRole.None);
  }

  Future<void> updateTeamMember(EditTeamMemberRequest teamMember) async {
    final teamMemberId = state.teamMember?.id;
    if (teamMemberId == null) return;
    state = state.copyWith(
      teamMember: state.teamMember?.copyWith(position: teamMember.position),
    );
    unawaited(teamMemberRepository.updateTeamMember(teamMemberId, teamMember));
  }

  Future<void> clearTeamMember() async {
    await ref.read(appDataControllerProvider.notifier).clearMemberRole();
  }

  Future<void> refreshTeamMember() async {
    await setTeamMemberRoleToSharedPrefs();
  }
}
