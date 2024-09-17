import 'dart:async';

import 'package:on_stage_app/app/app_data/app_data_controller.dart';
import 'package:on_stage_app/app/features/team_member/data/team_member_repository.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member_role/team_member_role.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_team_member_notifier.g.dart';

@Riverpod(keepAlive: true)
class CurrentTeamMemberNotifier extends _$CurrentTeamMemberNotifier {
  late final TeamMemberRepository _teamMemberRepository;

  @override
  void build() {
    final dio = ref.read(dioProvider);
    _teamMemberRepository = TeamMemberRepository(dio);
    _initializeState();
    logger.i('CurrentTeamMemberNotifier initialized');
  }

  Future<void> _initializeState() async {
    await getTeamMember();
  }

  Future<void> getTeamMember() async {
    final teamMember = await _teamMemberRepository.getCurrentTeamMember();
    await ref
        .read(appDataControllerProvider.notifier)
        .setMemberRole(teamMember.role ?? TeamMemberRole.None);
  }

  Future<void> clearTeamMember() async {
    await ref.read(appDataControllerProvider.notifier).clearMemberRole();
  }

  Future<void> refreshTeamMember() async {
    await getTeamMember();
  }
}
