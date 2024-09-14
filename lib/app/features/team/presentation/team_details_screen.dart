import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/custom_setting_tile.dart';
import 'package:on_stage_app/app/features/team/presentation/team_member_modal.dart';
import 'package:on_stage_app/app/features/team/presentation/team_members_modal.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/member_tile.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class TeamDetailsScreen extends ConsumerStatefulWidget {
  const TeamDetailsScreen({
    this.isCreating = false,
    super.key,
  });

  final bool isCreating;

  @override
  TeamDetailsScreenState createState() => TeamDetailsScreenState();
}

class TeamDetailsScreenState extends ConsumerState<TeamDetailsScreen> {
  final teamNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StageAppBar(
        title: widget.isCreating ? 'Create New Team' : 'Echipa Racheta',
        isBackButtonVisible: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            CustomSettingTile(
              backgroundColor: context.colorScheme.onSurfaceVariant,
              placeholder: 'Echipa Racheta',
              headline: 'Team Name',
              suffix: const SizedBox(),
              onTap: () {},
              controller: widget.isCreating ? teamNameController : null,
            ),
            const SizedBox(height: 16),
            Text('Members', style: context.textTheme.titleSmall),
            const SizedBox(height: 12),
            _buildParticipantsList(),
            const SizedBox(height: 12),
            EventActionButton(
              onTap: () {
                TeamMembersModal.show(teamId: '1', context: context);
              },
              text: 'Invite People',
              icon: Icons.add,
            ),
            if (widget.isCreating) ...[
              const Spacer(),
              ContinueButton(
                text: 'Create',
                onPressed: () {},
                isEnabled: true,
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantsList() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 2,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: MemberTileWidget(
              name: 'Timotei George',
              photo: 'assets/images/profile1.png',
              trailing: 'Editor',
              onTap: () {
                TeamMemberModal.show(onSave: (model) {}, context: context);
              },
            ),
          );
        },
      ),
    );
  }
}
