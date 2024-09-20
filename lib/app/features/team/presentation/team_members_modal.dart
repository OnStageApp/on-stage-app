import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/controller/event_controller.dart';
import 'package:on_stage_app/app/features/login/domain/user_model.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/loading_widget.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class TeamMembersModal extends ConsumerStatefulWidget {
  const TeamMembersModal({
    required this.teamId,
    this.onPressed,
    super.key,
  });

  final String? teamId;
  final void Function()? onPressed;

  @override
  TeamMembersModalState createState() => TeamMembersModalState();

  static void show({
    required BuildContext context,
    String? teamId,
    void Function()? onPressed,
  }) {
    showModalBottomSheet<Widget>(
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      context: context,
      builder: (context) => Container(
        margin: const EdgeInsets.only(top: 24),
        child: NestedScrollModal(
          buildFooter: () => SizedBox(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                32,
              ),
              child: Consumer(
                builder: (context, ref, _) {
                  return ContinueButton(
                    text: 'Invite People to Event',
                    onPressed: () {
                      if (onPressed != null) {
                        onPressed();
                      }
                      context.popDialog();
                    },
                    isEnabled: true,
                  );
                },
              ),
            ),
          ),
          buildHeader: () => const ModalHeader(title: 'Add Members'),
          headerHeight: () {
            return 64;
          },
          footerHeight: () {
            return 64;
          },
          buildContent: () => TeamMembersModal(
            teamId: teamId,
          ),
        ),
      ),
    );
  }
}

class TeamMembersModalState extends ConsumerState<TeamMembersModal> {
  final TextEditingController _searchController = TextEditingController();
  List<User> _members = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ref.watch(teamNotifierProvider).isLoading
          ? const OnStageLoadingIndicator()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(bottom: 42),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {},
                        child: Container(
                          height: 48,
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: context.colorScheme.onSurfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _isItemChecked(index)
                                  ? context.colorScheme.primary
                                  : context.colorScheme.onSurfaceVariant,
                              width: 1.6,
                            ),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 12),
                              Container(
                                width: 30,
                                height: 30,
                                alignment: Alignment.center,
                                key: ValueKey(
                                  _members.elementAt(index).hashCode.toString(),
                                ),
                                decoration: BoxDecoration(
                                  color: context.colorScheme.onSurfaceVariant,
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 3,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  _members
                                          .elementAt(index)
                                          .name!
                                          .substring(0, 1) ??
                                      '',
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.titleSmall,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  _members.elementAt(index).name ?? '',
                                  style: context.textTheme.titleSmall,
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Icon(
                                  _isItemChecked(index)
                                      ? Icons.check_circle_rounded
                                      : Icons.circle_outlined,
                                  size: 20,
                                  color: _isItemChecked(index)
                                      ? context.colorScheme.primary
                                      : context.colorScheme.surfaceBright,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  bool _isItemChecked(int index) => ref
      .watch(eventControllerProvider)
      .selectedTeamMembers
      .contains(_members.elementAt(index));
}
