import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      final currentSubscription =
          ref.read(subscriptionNotifierProvider).currentSubscription;
      return currentSubscription != null &&
          currentMemberCount < currentSubscription.plan.maxMembers;
    },
    PermissionType.reminders: (ref) {
      final currentSubscription =
          ref.read(subscriptionNotifierProvider).currentSubscription;
      return currentSubscription != null &&
          currentSubscription.plan.hasReminders;
    },
  };

  bool checkPermission(PermissionType permissionType) {
    final check = _permissionChecks[permissionType];
    if (check == null) return false;
    return check(ref);
  }
}
