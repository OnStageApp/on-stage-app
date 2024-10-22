import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/user/domain/enums/permission_type.dart';

class PermissionNotifier extends StateNotifier<PermissionType?> {
  PermissionNotifier() : super(null);

  void permissionDenied(PermissionType permissionType) {
    state = permissionType;
  }

  void clearPermission() {
    state = null;
  }
}

final permissionNotifierProvider =
    StateNotifierProvider<PermissionNotifier, PermissionType?>((ref) {
  return PermissionNotifier();
});
