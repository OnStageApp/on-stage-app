import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/plan/domain/plan.dart';
import 'package:on_stage_app/app/features/subscription/domain/subscription.dart';
import 'package:on_stage_app/app/features/subscription/presentation/paywall_modal.dart';
import 'package:on_stage_app/app/features/subscription/subscription_notifier.dart';
import 'package:on_stage_app/app/features/team_member/application/current_team_member/current_team_member_notifier.dart';
import 'package:on_stage_app/app/features/team_member/application/team_members_notifier.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member_role/team_member_role.dart';
import 'package:on_stage_app/app/features/user/domain/enums/permission_type.dart';

class PermissionService {
  PermissionService({
    required this.teamMember,
    required this.currentSubscription,
    required this.currentPlan,
    required this.membersCount,
  });

  final TeamMember? teamMember;
  final Subscription? currentSubscription;
  final Plan? currentPlan;
  final int membersCount;

  bool get isLeaderOnTeam => teamMember?.role == TeamMemberRole.leader;

  bool get hasAccessToEdit =>
      teamMember?.role == TeamMemberRole.editor || isLeaderOnTeam;

  bool get isNone => teamMember?.role == TeamMemberRole.none;

  bool get hasPaidPlan => currentPlan?.entitlementId != 'starter';

  bool get hasReminders => currentPlan?.hasReminders ?? false;

  bool get canAddTeamMembers {
    if (!isLeaderOnTeam && !hasPaidPlan && currentPlan?.maxMembers == null) {
      return false;
    }
    return (currentPlan?.maxMembers ?? 1) > membersCount;
  }

  bool get canAddEvents => true;

  bool hasPermissions(PermissionType permissionType) {
    switch (permissionType) {
      case PermissionType.addEvents:
        return canAddEvents;
      case PermissionType.addTeamMembers:
        return canAddTeamMembers;
      case PermissionType.reminders:
        return hasReminders;
      case PermissionType.addSong:
      case PermissionType.screenSync:
      case PermissionType.songFileStorage:
      case PermissionType.none:
        return false;
    }
  }

  Future<void> callMethodIfHasPermission({
    required PermissionType permissionType,
    required void Function() onGranted,
    required BuildContext context,
  }) async {
    if (hasPermissions(permissionType)) {
      onGranted();
    } else {
      PaywallModal.show(
        context: context,
        permissionType: permissionType,
      );
    }
  }
}

final permissionServiceProvider = Provider<PermissionService>((ref) {
  final teamMember = ref.watch(currentTeamMemberNotifierProvider).teamMember;
  final currentSubscription =
      ref.watch(subscriptionNotifierProvider).currentSubscription;
  final currentPlan = ref.watch(subscriptionNotifierProvider).currentPlan;
  final membersCount =
      ref.watch(teamMembersNotifierProvider).teamMembers.length;

  return PermissionService(
    teamMember: teamMember,
    currentSubscription: currentSubscription,
    currentPlan: currentPlan,
    membersCount: membersCount,
  );
});
