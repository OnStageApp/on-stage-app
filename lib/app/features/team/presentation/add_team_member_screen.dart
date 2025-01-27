import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/features/team/presentation/widgets/change_permissions_modal.dart';
import 'package:on_stage_app/app/features/team_member/application/team_members_notifier.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member_role/team_member_role.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/loading_widget.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/shared/top_flush_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/input_validator.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';

class AddTeamMemberScreen extends ConsumerStatefulWidget {
  const AddTeamMemberScreen({
    super.key,
  });

  @override
  TeamMembersModalState createState() => TeamMembersModalState();
}

class TeamMembersModalState extends ConsumerState<AddTeamMemberScreen> {
  final FocusNode _emailFocus = FocusNode();
  final TextEditingController _emailUsernameController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _selectedRole = TeamMemberRole.none;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {});

    super.initState();
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _emailUsernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StageAppBar(
        title: 'Invite Members',
        isBackButtonVisible: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: ref.watch(teamNotifierProvider).isLoading
            ? const OnStageLoadingIndicator()
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      label: 'Email or Username',
                      hint: 'ionutpopescu32',
                      icon: Icons.add,
                      focusNode: _emailFocus,
                      controller: _emailUsernameController,
                      validator: InputValidator.validateEmptyValue,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: context.colorScheme.onSurfaceVariant,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          'Change Permissions',
                          style: context.textTheme.titleMedium,
                        ),
                        trailing: Text(
                          _selectedRole.name,
                          style: context.textTheme.titleMedium!.copyWith(
                            color: context.colorScheme.surfaceDim,
                          ),
                        ),
                        onTap: () async {
                          final role = await ChangePermissionsModal.show(
                            context: context,
                            selectedRole: _selectedRole,
                          );

                          if (role != null) {
                            setState(() => _selectedRole = role);
                          }
                        },
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: ContinueButton(
                        text: 'Invite',
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final errorMessage = await ref
                                .read(teamMembersNotifierProvider.notifier)
                                .inviteTeamMember(
                                  _emailUsernameController.text,
                                  _selectedRole,
                                );
                            if (errorMessage.isNullEmptyOrWhitespace &&
                                mounted) {
                              context.pop();
                              return;
                            }
                            if (mounted) {
                              TopFlushBar.show(
                                context,
                                errorMessage ?? 'Error inviting team member',
                                isError: true,
                              );
                            }
                          }
                        },
                        isEnabled: true,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
