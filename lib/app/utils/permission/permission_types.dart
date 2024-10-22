// lib/app/common/permission/permission_types.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/subscription/subscription_notifier.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';

abstract class PermissionStrategy {
  bool hasPermission(WidgetRef ref);
}

class AddTeamMembersPermission implements PermissionStrategy {
  @override
  bool hasPermission(WidgetRef ref) {
    final currentMemberCount =
        ref.read(teamNotifierProvider).currentTeam?.membersCount ?? 0;
    final currentSubscription =
        ref.read(subscriptionNotifierProvider).currentSubscription;
    return currentSubscription != null &&
        currentMemberCount < currentSubscription.plan.maxMembers;
  }
}

class RemindersPermission implements PermissionStrategy {
  @override
  bool hasPermission(WidgetRef ref) {
    final currentSubscription =
        ref.read(subscriptionNotifierProvider).currentSubscription;
    return currentSubscription != null && currentSubscription.plan.hasReminders;
  }
}
