import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/plan/application/plan_service.dart';
import 'package:on_stage_app/app/features/subscription/subscription_notifier.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/features/user/domain/enums/permission_type.dart';

final localPermissionCheckerProvider = Provider<LocalPermissionChecker>((ref) {
  return LocalPermissionChecker(ref);
});

class LocalPermissionChecker {
  LocalPermissionChecker(this.ref);

  final Ref ref;

  final Map<PermissionType, bool Function(Ref)> _permissionChecks = {
    PermissionType.addTeamMembers: (ref) {
      final currentMemberCount =
          ref.read(teamNotifierProvider).currentTeam?.membersCount ?? 0;
      final subscriptionState = ref.read(subscriptionNotifierProvider);

      final currentPlan = ref.watch(planServiceProvider).plans.firstWhere(
            (plan) => plan.id == subscriptionState.currentSubscription?.planId,
          );
      return currentMemberCount < currentPlan.maxMembers;
    },
    PermissionType.reminders: (ref) {
      final subscriptionState = ref.read(subscriptionNotifierProvider);
      final currentPlan = ref.watch(planServiceProvider).plans.firstWhere(
            (plan) => plan.id == subscriptionState.currentSubscription?.planId,
          );
      return currentPlan.hasReminders;
    },
  };

  bool checkPermission(PermissionType permissionType) {
    final check = _permissionChecks[permissionType];
    if (check == null) return false;
    return check(ref);
  }
}

//TODO: Check if it s working, check conditions, it was modified
