import 'package:on_stage_app/app/features/team_member/application/team_members_state.dart';
import 'package:on_stage_app/app/features/team_member/data/team_member_repository.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'team_members_notifier.g.dart';

@riverpod
class TeamMembersNotifier extends _$TeamMembersNotifier {
  late final TeamMemberRepository _teamMemberRepository;

  @override
  TeamMembersState build() {
    final dio = ref.read(dioProvider);
    _teamMemberRepository = TeamMemberRepository(dio);
    return const TeamMembersState();
  }

  Future<void> getTeamMembers({bool? includeCurrentUser}) async {
    state = state.copyWith(isLoading: true);
    final teamMembers = await _teamMemberRepository.getTeamMembers(
      includeCurrentUser: includeCurrentUser,
    );
    state = state.copyWith(isLoading: false, teamMembers: teamMembers);
  }

  Future<void> getUninvitedTeamMembers(String eventId) async {
    state = state.copyWith(isLoading: true);
    try {
      final members =
          await _teamMemberRepository.getUninvitedTeamMembers(eventId);
      state = state.copyWith(uninvitedTeamMembers: members);
    } catch (e) {
      // Handle error
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
