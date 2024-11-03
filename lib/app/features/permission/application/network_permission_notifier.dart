import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/user/domain/enums/permission_type.dart';

/// This class is responsible for notifying the user when they don't have permission to access a certain feature.
/// Is listened on the main_screen, if the user doesn't have permission to access a certain feature, a modal will be shown.
class NetworkPermissionNotifier extends StateNotifier<PermissionType?> {
  NetworkPermissionNotifier() : super(null);

  /// This method is called when the user has no permission to access a certain feature.
  void permissionDenied(PermissionType permissionType) {
    state = permissionType;
  }

  void clearPermission() {
    state = null;
  }
}

final networkPermissionProvider =
    StateNotifierProvider<NetworkPermissionNotifier, PermissionType?>((ref) {
  return NetworkPermissionNotifier();
});
