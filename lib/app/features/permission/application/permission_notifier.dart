import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/plan/domain/plan.dart';
import 'package:on_stage_app/app/features/subscription/domain/subscription.dart';
import 'package:on_stage_app/app/features/subscription/subscription_notifier.dart';
import 'package:on_stage_app/app/features/team_member/application/current_team_member/current_team_member_notifier.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member_role/team_member_role.dart';

class PermissionService {
  PermissionService({
    required this.teamMember,
    required this.currentSubscription,
    required this.currentPlan,
  });

  final TeamMember? teamMember;
  final Subscription? currentSubscription;
  final Plan? currentPlan;

  bool get isLeaderOnTeam => teamMember?.role == TeamMemberRole.leader;

  bool get hasAccessToEdit =>
      teamMember?.role == TeamMemberRole.editor || isLeaderOnTeam;

  bool get isNone => teamMember?.role == TeamMemberRole.none;

  bool get hasPaidPlan => currentPlan?.entitlementId != 'starter';
}

final permissionServiceProvider = Provider<PermissionService>((ref) {
  final teamMember = ref.watch(currentTeamMemberNotifierProvider).teamMember;
  final currentSubscription =
      ref.watch(subscriptionNotifierProvider).currentSubscription;
  final currentPlan = ref.watch(subscriptionNotifierProvider).currentPlan;

  return PermissionService(
    teamMember: teamMember,
    currentSubscription: currentSubscription,
    currentPlan: currentPlan,
  );
});
