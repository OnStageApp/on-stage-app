import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/domain/models/rehearsal/rehearsal_model.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/features/team/domain/team_request/team_request.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class CreateNewTeamModal extends ConsumerStatefulWidget {
  const CreateNewTeamModal({
    this.onTeamCreated,
    super.key,
  });

  final void Function(RehearsalModel)? onTeamCreated;

  @override
  CreateNewTeamModalState createState() => CreateNewTeamModalState();

  static void show({
    required BuildContext context,
    RehearsalModel? rehearsal,
    void Function(RehearsalModel)? onTeamCreated,
    bool enabled = true,
  }) {
    showModalBottomSheet<Widget>(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surfaceContainerHigh,
      context: context,
      builder: (context) => SafeArea(
        child: NestedScrollModal(
          buildHeader: () => const ModalHeader(title: 'New Team'),
          headerHeight: () => 64,
          buildContent: () => SingleChildScrollView(
            child: CreateNewTeamModal(
              onTeamCreated: onTeamCreated,
            ),
          ),
        ),
      ),
    );
  }
}

class CreateNewTeamModalState extends ConsumerState<CreateNewTeamModal> {
  final TextEditingController _teamNameController = TextEditingController();
  final FocusNode _rehearsalNameFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_rehearsalNameFocus);
    });
  }

  @override
  void dispose() {
    _rehearsalNameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultScreenPadding,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              enabled: true,
              label: 'Team Name',
              hint: 'Rocket Team',
              icon: null,
              focusNode: _rehearsalNameFocus,
              controller: _teamNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a team name';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            ContinueButton(
              isEnabled: true,
              text: 'Create',
              onPressed: _createTeam,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _createTeam() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();
    await ref.read(teamNotifierProvider.notifier).createTeam(
          TeamRequest(
            name: _teamNameController.text,
            membersCount: 1,
          ),
        );

    if (mounted) {
      context.popDialog();
    }
  }
}
