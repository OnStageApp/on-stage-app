import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/team/presentation/widgets/change_permissions_tile.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member_role/team_member_role.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/adaptive_modal.dart';

class ChangePermissionsModal extends ConsumerWidget {
  const ChangePermissionsModal({
    required this.selectedRole,
    super.key,
  });

  final TeamMemberRole selectedRole;

  static Future<TeamMemberRole?> show({
    required BuildContext context,
    required TeamMemberRole selectedRole,
  }) {
    return AdaptiveModal.show(
      context: context,
      expand: false,
      child: ChangePermissionsModal(selectedRole: selectedRole),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        NestedScrollModal(
          buildHeader: () => const ModalHeader(title: 'Change Permissions'),
          headerHeight: () => 64,
          buildContent: () => SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: defaultScreenPadding.left,
                right: defaultScreenPadding.right,
                top: defaultScreenPadding.top,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: TeamMemberRole.values.length,
                    itemBuilder: (context, index) {
                      if (index == 0) return const SizedBox();
                      final role = TeamMemberRole.values[index];
                      return ChangePermissionsTile(
                        title: role.name,
                        isSelected: selectedRole == role,
                        onTap: () => Navigator.of(context).pop(role),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
