import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/events/events_notifier.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/features/team/application/teams/teams_notifier.dart';
import 'package:on_stage_app/app/features/team/domain/team.dart';
import 'package:on_stage_app/app/shared/loading_widget.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/adaptive_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/navigator/router_notifier.dart';

class TeamsSelectionModal extends ConsumerStatefulWidget {
  const TeamsSelectionModal({
    this.onSave,
    super.key,
  });

  final void Function()? onSave;

  @override
  TeamsSelectionModalState createState() => TeamsSelectionModalState();

  static void show({
    required BuildContext context,
    void Function()? onSave,
  }) {
    AdaptiveModal.show(
      context: context,
      isFloatingForLargeScreens: true,
      expand: false,
      child: SingleChildScrollView(
        child: TeamsSelectionModal(
          onSave: onSave,
        ),
      ),
    );
  }
}

class TeamsSelectionModalState extends ConsumerState<TeamsSelectionModal> {
  List<Team> _teams = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(teamsNotifierProvider.notifier).getTeams();
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _teams = ref.watch(teamsNotifierProvider).teams;
    return SafeArea(
      child: NestedScrollModal(
        buildHeader: () => const ModalHeader(title: 'Your Teams'),
        headerHeight: () => 64,
        buildContent: () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const SizedBox(height: 16),
              if (ref.watch(teamsNotifierProvider).isLoading)
                const Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: OnStageLoadingIndicator(),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(bottom: 42),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: ref.watch(teamsNotifierProvider).teams.length,
                    itemBuilder: (context, index) {
                      final team = _teams.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          splashColor: context.colorScheme.surfaceBright,
                          tileColor: context.colorScheme.onSurfaceVariant,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: _isItemChecked(index)
                                  ? context.colorScheme.primary
                                  : context.colorScheme.onSurfaceVariant,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          title: Text(
                            team.name,
                            style: context.textTheme.headlineMedium,
                          ),
                          subtitle: Text(
                            (team.membersCount ?? 0) > 1
                                ? '${team.membersCount} Members'
                                : '${team.membersCount} Member',
                            style: context.textTheme.bodyMedium!.copyWith(
                              color: context.colorScheme.outline,
                            ),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: context.colorScheme.surface,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _getRole(team),
                              style: context.textTheme.titleMedium!
                                  .copyWith(color: context.colorScheme.outline),
                            ),
                          ),
                          onTap: () async {
                            if (_isItemChecked(index)) return;

                            final teamsNotifier =
                                ref.read(teamsNotifierProvider.notifier);
                            final teamNotifier =
                                ref.read(teamNotifierProvider.notifier);
                            final eventsNotifier =
                                ref.read(eventsNotifierProvider.notifier);
                            final navigationNotifier =
                                ref.read(navigationNotifierProvider.notifier);

                            await teamsNotifier
                                .setCurrentTeam(_teams.elementAt(index).id);

                            if (!mounted) return;

                            await teamNotifier.getCurrentTeam();

                            if (!mounted) return;

                            eventsNotifier.resetState();
                            navigationNotifier.resetRouterAndState();
                          },
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRole(Team team) =>
      '${team.role?.toLowerCase() == 'none' ? 'Member' : team.role}';

  bool _isItemChecked(int index) =>
      ref.watch(teamsNotifierProvider).currentTeamId ==
      _teams.elementAt(index).id;
}
