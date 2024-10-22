import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/user/domain/enums/permission_type.dart';
import 'package:on_stage_app/app/utils/permission/permission_types.dart';

class PermissionChecker {
  PermissionChecker(this.ref);

  final WidgetRef ref;

  final Map<PermissionType, PermissionStrategy> _strategies = {
    PermissionType.ADD_TEAM_MEMBERS: AddTeamMembersPermission(),
    PermissionType.REMINDERS: RemindersPermission(),
  };

  bool checkPermission(PermissionType permissionType) {
    final strategy = _strategies[permissionType];
    if (strategy == null) return false;
    return strategy.hasPermission(ref);
  }
}
