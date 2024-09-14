import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/features/team/domain/team.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/loading_widget.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

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
    showModalBottomSheet<Widget>(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface,
      constraints: const BoxConstraints(
        minHeight: 400,
      ),
      context: context,
      builder: (context) => SafeArea(
        child: NestedScrollModal(
          buildHeader: () => const ModalHeader(title: 'Teams'),
          headerHeight: () => 64,
          buildContent: () => SingleChildScrollView(
            child: TeamsSelectionModal(
              onSave: onSave,
            ),
          ),
          footerHeight: () {
            return 64;
          },
          buildFooter: () => SizedBox(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                0,
              ),
              child: Consumer(
                builder: (context, ref, _) {
                  return ContinueButton(
                    text: 'Save',
                    onPressed: () {
                      // if (onPressed != null) {
                      //   onPressed();
                      // }
                      context.popDialog();
                    },
                    isEnabled: true,
                  );
                },
              ),
            ),
          ),
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
      ref.read(teamNotifierProvider.notifier).getTeams();
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _teams = ref.watch(teamNotifierProvider).teams;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          if (ref.watch(teamNotifierProvider).isLoading)
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
                itemCount: ref.watch(teamNotifierProvider).teams.length,
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
                              _teams.elementAt(index).hashCode.toString(),
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
                              _teams.elementAt(index).name.substring(0, 1) ??
                                  '',
                              textAlign: TextAlign.center,
                              style: context.textTheme.titleSmall,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              _teams.elementAt(index).name ?? '',
                              style: context.textTheme.titleSmall,
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
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

  bool _isItemChecked(int index) => false;
}
